import requests
import json
import re
from threading import Lock

from config import LLM_API_URL, LLM_MODEL
from schemas.recipe_generation import GeneratedMenu

PANTRY_STAPLES = {
    "盐",
    "食盐",
    "糖",
    "白糖",
    "冰糖",
    "油",
    "食用油",
    "橄榄油",
    "香油",
    "芝麻油",
    "酱油",
    "生抽",
    "老抽",
    "醋",
    "料酒",
    "蚝油",
    "淀粉",
    "水",
    "葱",
    "姜",
    "蒜",
    "葱姜蒜",
    "胡椒",
    "胡椒粉",
    "黑胡椒",
    "辣椒",
    "干辣椒",
    "花椒",
    "豆瓣酱",
    "香菜",
    "葱花",
    "salt",
    "sugar",
    "oil",
    "oliveoil",
    "sesameoil",
    "soy sauce",
    "soy sauce".replace(" ", ""),
    "vinegar",
    "cookingwine",
    "cornstarch",
    "starch",
    "water",
    "scallion",
    "ginger",
    "garlic",
    "pepper",
    "chili",
    "chilli",
    "sichuanpepper",
    "cilantro",
}

INGREDIENT_SPLIT_PATTERN = re.compile(r"[\/／,，、|]+")

ZH_DERIVED_SUFFIXES = (
    "汁",
    "丁",
    "块",
    "片",
    "丝",
    "末",
    "泥",
    "酱",
    "蓉",
    "碎",
)

EN_DERIVED_SUFFIXES = (
    "juice",
    "sauce",
    "paste",
    "puree",
    "zest",
    "slice",
    "slices",
    "chunk",
    "chunks",
)

EN_DERIVED_PREFIXES = (
    "diced",
    "chopped",
    "sliced",
    "minced",
    "crushed",
)

JSON_FENCE_PATTERN = re.compile(r'```(?:json)?\s*(.*?)\s*```', re.DOTALL)


def _normalize_name(value: str) -> str:
    return "".join(value.lower().split())


def _expand_name_variants(value: str) -> set[str]:
    if not isinstance(value, str):
        return set()

    stripped = value.strip()
    if not stripped:
        return set()

    variants = {_normalize_name(stripped)}
    for part in INGREDIENT_SPLIT_PATTERN.split(stripped):
        normalized = _normalize_name(part)
        if normalized:
            variants.add(normalized)
    return variants


def _derive_variants(base_aliases: set[str]) -> set[str]:
    derived = set(base_aliases)
    for alias in base_aliases:
        if not alias:
            continue

        for suffix in ZH_DERIVED_SUFFIXES:
            derived.add(f"{alias}{suffix}")

        for suffix in EN_DERIVED_SUFFIXES:
            derived.add(f"{alias}{suffix}")

        for prefix in EN_DERIVED_PREFIXES:
            derived.add(f"{prefix}{alias}")

    return derived


def _matches_allergen(aliases: set[str], allergens: set[str]) -> bool:
    for alias in aliases:
        for allergen in allergens:
            if alias == allergen or allergen in alias or alias in allergen:
                return True
    return False


def _ingredient_aliases(name) -> set[str]:
    return _expand_name_variants(name.zh) | _expand_name_variants(name.en)


def _extract_json_from_text(text: str) -> str:
    match = JSON_FENCE_PATTERN.search(text)
    if match:
        return match.group(1)

    start = text.find("{")
    end = text.rfind("}")
    if start != -1 and end != -1:
        return text[start:end + 1]
    return text


def _strip_trailing_comma(result: list[str]) -> None:
    index = len(result) - 1
    while index >= 0 and result[index].isspace():
        index -= 1
    if index >= 0 and result[index] == ",":
        result.pop(index)


def _repair_json_text(text: str) -> str:
    normalized = (
        text.strip()
        .replace("\ufeff", "")
        .replace("“", '"')
        .replace("”", '"')
        .replace("‘", "'")
        .replace("’", "'")
    )

    open_to_close = {"{": "}", "[": "]"}
    close_to_open = {"}": "{", "]": "["}
    stack: list[str] = []
    result: list[str] = []
    in_string = False
    escape = False

    for char in normalized:
        if in_string:
            result.append(char)
            if escape:
                escape = False
            elif char == "\\":
                escape = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
            result.append(char)
            continue

        if char in "()":
            continue

        if char in open_to_close:
            stack.append(char)
            result.append(char)
            continue

        if char in close_to_open:
            _strip_trailing_comma(result)
            expected_open = close_to_open[char]

            while stack and stack[-1] != expected_open:
                _strip_trailing_comma(result)
                result.append(open_to_close[stack.pop()])

            if stack and stack[-1] == expected_open:
                stack.pop()
                result.append(char)
            continue

        result.append(char)

    while stack:
        _strip_trailing_comma(result)
        result.append(open_to_close[stack.pop()])

    return "".join(result)


def parse_llm_json_content(text: str) -> dict:
    extracted = _extract_json_from_text(text)
    decoder = json.JSONDecoder()
    candidates = [extracted, _repair_json_text(extracted)]
    last_error: Exception | None = None

    seen: set[str] = set()
    for candidate in candidates:
        if candidate in seen:
            continue
        seen.add(candidate)

        try:
            return json.loads(candidate)
        except json.JSONDecodeError as exc:
            last_error = exc

            try:
                stripped = candidate.lstrip()
                parsed, end = decoder.raw_decode(stripped)
                tail = stripped[end:].strip()
                if not tail or re.fullmatch(r"[\]\}\),;\s]+", tail):
                    return parsed
            except json.JSONDecodeError as raw_exc:
                last_error = raw_exc

    if last_error is None:
        raise RuntimeError("大模型输出为空或不是合法 JSON")
    raise RuntimeError(f"大模型输出不是合法 JSON: {last_error}")


def validate_menu_payload(data: dict, ingredients: list[str], allergens: list[str]) -> dict:
    menu = GeneratedMenu.model_validate(data)
    requested_base_ingredients: set[str] = set()
    for item in ingredients:
        requested_base_ingredients |= _expand_name_variants(item)

    requested_ingredients = _derive_variants(requested_base_ingredients)
    pantry_ingredients = _derive_variants(
        {
            alias
            for item in PANTRY_STAPLES
            for alias in _expand_name_variants(item)
        }
    )
    allowed_ingredients = requested_ingredients | pantry_ingredients
    blocked_allergens = {
        alias
        for item in allergens
        for alias in _expand_name_variants(item)
    }

    for recipe in [*menu.recipes, *menu.candidates]:
        recipe_name = recipe.name.zh
        uses_requested_ingredient = False

        for ingredient in recipe.ingredients:
            aliases = _ingredient_aliases(ingredient.name)

            if _matches_allergen(aliases, blocked_allergens):
                raise RuntimeError(f"菜谱《{recipe_name}》包含过敏原食材")

            if not any(alias in allowed_ingredients for alias in aliases):
                raise RuntimeError(f"菜谱《{recipe_name}》使用了未识别食材: {ingredient.name.zh}")

            if any(alias in requested_ingredients for alias in aliases):
                uses_requested_ingredient = True

        if not uses_requested_ingredient:
            raise RuntimeError(f"菜谱《{recipe_name}》没有使用任何已提供食材")

    return menu.model_dump(mode="json")


class LLMService:
    def __init__(self):
        self.model_name = LLM_MODEL
        self.api_url = LLM_API_URL
        print(f"[LLM Service] initialization completed，the local model has been mounted: {self.model_name}")

    def generate_menu(self, diners: int, ingredients: list, dietary: list = None, allergens: list = None,
                      preferences: list = None):
        """
        core business logic: receive parameters, generate menu JSON data
        """
        dietary = dietary or []
        allergens = allergens or []
        preferences = preferences or []

        # Prompt
        prompt = f"""
你是一个顶级的国际米其林 AI 厨师长。
请根据以下就餐情况，自主决定应该做几道菜（通常 N 个人需要 N 到 N+1 道菜的组合），规划出一桌完美的菜单。
同时，额外再提供 2 道备用菜（candidates），供用户在不满意某道主菜时直接替换，不得与主菜重复。

【当前就餐情况】
- 就餐人数: {diners} 人
- 现有食材: {ingredients}
- 个人忌口: {dietary} (绝对遵守)
- 致死过敏原: {allergens} (必须坚决丢弃或替换危险食材)
- 口味偏好: {preferences}

【食材使用铁律】
1. 只能使用用户提供的食材、常见基础调味料，或这些食材的直接加工形态。
2. 允许的直接加工形态示例：
   - 柠檬 -> 柠檬汁
   - 青柠 -> 青柠汁
   - 番茄/西红柿 -> 番茄丁、番茄酱
   - 土豆/马铃薯 -> 土豆泥、土豆块
3. 严禁新增任何未提供的主食、蛋白质、蔬菜、水果或成品食材。
   例如：意大利面、米饭、鸡蛋、牛奶、奶油、芝士、面粉，如果不在输入里就绝对不能出现。
4. 如果某道菜做不出来，就换一道，不要偷偷补充新食材。

【输出格式要求】
你必须输出一个完整的 JSON。格式如下：
{{
  "reasoning": "你的分析过程",
  "planned_dish_count": 0,
  "recipes": [
    {{
      "name": {{"zh": "菜名", "en": "Name"}},
      "description": {{"zh": "描述", "en": "Description"}},
      "category": {{"zh": "热菜", "en": "Category"}},
      "difficulty": {{"zh": "简单", "en": "Easy"}},
      "calories": 250,
      "cooking_time": 15,
      "servings": {diners},
      "ingredients": [
        {{"name": {{"zh": "食材名", "en": "Ingredient"}}, "quantity": "数量", "unit": {{"zh": "单位", "en": "Unit"}}}}
      ],
      "steps": [
        {{"step": 1, "description": {{"zh": "步骤", "en": "Step"}}}}
      ],
      "tips": {{"zh": "小贴士", "en": "Tips"}},
      "tags": [{{"zh": "标签", "en": "Tag"}}]
    }}
  ],
  "candidates": [
    {{
      "name": {{"zh": "备用菜名", "en": "Name"}},
      "description": {{"zh": "描述", "en": "Description"}},
      "category": {{"zh": "热菜", "en": "Category"}},
      "difficulty": {{"zh": "简单", "en": "Easy"}},
      "calories": 250,
      "cooking_time": 15,
      "servings": {diners},
      "ingredients": [
        {{"name": {{"zh": "食材名", "en": "Ingredient"}}, "quantity": "数量", "unit": {{"zh": "单位", "en": "Unit"}}}}
      ],
      "steps": [
        {{"step": 1, "description": {{"zh": "步骤", "en": "Step"}}}}
      ],
      "tips": {{"zh": "小贴士", "en": "Tips"}},
      "tags": [{{"zh": "标签", "en": "Tag"}}]
    }}
  ]
}}

【重要】只输出纯 JSON，不要输出任何多余文字、解释或 markdown 代码块。确保所有花括号和方括号正确闭合，输出必须是合法可解析的 JSON。
"""
        # Assemble the request body (OpenAI compatible)
        payload = {
            "model": self.model_name,
            "messages": [
                {"role": "system", "content": "You are a Michelin-star chef that outputs structured JSON for recipe planning."},
                {"role": "user", "content": prompt}
            ],
            "temperature": 0.7,
            "max_tokens": -1,
            "stream": False
        }

        try:
            # request to LM Studio / OpenAI API, limit 3 mins
            res = requests.post(self.api_url, json=payload, timeout=180)
            res.raise_for_status()

            # Parse the response in OpenAI format
            result_json = res.json()
            raw_text = result_json["choices"][0]["message"]["content"]

            # Parse JSON with lightweight repair for common LLM syntax glitches.
            data = parse_llm_json_content(raw_text)

            return validate_menu_payload(data, ingredients=ingredients, allergens=allergens)

        except Exception as e:
            # If it fails or times out, throw exception out to caller
            raise RuntimeError(f"大模型生成菜单失败: {str(e)}")


_llm_service: LLMService | None = None
_llm_lock = Lock()


def get_llm_service() -> LLMService:
    global _llm_service
    if _llm_service is None:
        with _llm_lock:
            if _llm_service is None:
                try:
                    _llm_service = LLMService()
                except Exception as exc:
                    raise RuntimeError(f"菜谱生成服务初始化失败: {exc}") from exc
    return _llm_service
