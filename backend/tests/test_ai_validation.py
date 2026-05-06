import sys
import unittest
from pathlib import Path


BACKEND_ROOT = Path(__file__).resolve().parents[1]
if str(BACKEND_ROOT) not in sys.path:
    sys.path.insert(0, str(BACKEND_ROOT))

from services.llm_service import parse_llm_json_content, validate_menu_payload
from services.yolo_service import aggregate_detections


def sample_menu(ingredient_name: str = "番茄") -> dict:
    return {
        "reasoning": "基于已有食材做一道简单家常菜",
        "planned_dish_count": 99,
        "recipes": [
            {
                "name": {"zh": "番茄炒蛋", "en": "Tomato Scrambled Eggs"},
                "description": {"zh": "经典家常菜", "en": "Classic home-style dish"},
                "category": {"zh": "热菜", "en": "Main"},
                "difficulty": {"zh": "简单", "en": "Easy"},
                "calories": 280,
                "cooking_time": 15,
                "servings": 2,
                "ingredients": [
                    {
                        "name": {"zh": ingredient_name, "en": "Tomato"},
                        "quantity": "2",
                        "unit": {"zh": "个", "en": "pcs"},
                    },
                    {
                        "name": {"zh": "盐", "en": "Salt"},
                        "quantity": "1",
                        "unit": {"zh": "勺", "en": "tsp"},
                    },
                ],
                "steps": [
                    {
                        "step": 1,
                        "description": {"zh": "下锅翻炒", "en": "Cook in a pan"},
                    }
                ],
                "tips": {"zh": "趁热吃", "en": "Serve hot"},
                "tags": [{"zh": "家常", "en": "Homestyle"}],
            }
        ],
        "candidates": [
            {
                "name": {"zh": "番茄蛋花汤", "en": "Tomato Egg Soup"},
                "description": {"zh": "清爽汤品", "en": "Light soup"},
                "category": {"zh": "汤", "en": "Soup"},
                "difficulty": {"zh": "简单", "en": "Easy"},
                "calories": 120,
                "cooking_time": 10,
                "servings": 2,
                "ingredients": [
                    {
                        "name": {"zh": ingredient_name, "en": "Tomato"},
                        "quantity": "1",
                        "unit": {"zh": "个", "en": "pc"},
                    }
                ],
                "steps": [
                    {
                        "step": 1,
                        "description": {"zh": "煮汤", "en": "Simmer the soup"},
                    }
                ],
                "tips": {"zh": "少盐", "en": "Use less salt"},
                "tags": [{"zh": "汤", "en": "Soup"}],
            }
        ],
    }


class AiValidationTests(unittest.TestCase):
    def test_detection_aggregation_filters_and_groups_results(self) -> None:
        result = aggregate_detections(
            [
                {
                    "name": {"zh": "番茄", "en": "Tomato"},
                    "category": "蔬菜",
                    "confidence": 0.62,
                    "bbox": [0, 0, 10, 10],
                },
                {
                    "name": {"zh": "番茄", "en": "Tomato"},
                    "category": "蔬菜",
                    "confidence": 0.58,
                    "bbox": [1, 1, 12, 12],
                },
                {
                    "name": {"zh": "土豆", "en": "Potato"},
                    "category": "蔬菜",
                    "confidence": 0.32,
                    "bbox": [2, 2, 20, 20],
                },
                {
                    "name": {"zh": "牛肉", "en": "Beef"},
                    "category": "肉类",
                    "confidence": 0.12,
                    "bbox": [2, 2, 20, 20],
                },
            ],
            accepted_confidence=0.45,
            review_confidence=0.25,
        )

        self.assertEqual(len(result["detected_ingredients"]), 1)
        self.assertEqual(result["detected_ingredients"][0]["name"]["zh"], "番茄")
        self.assertEqual(result["detected_ingredients"][0]["count"], 2)
        self.assertEqual(len(result["review_ingredients"]), 1)
        self.assertEqual(result["review_ingredients"][0]["name"]["zh"], "土豆")

    def test_menu_validation_accepts_known_ingredients_and_repairs_count(self) -> None:
        result = validate_menu_payload(
            sample_menu(),
            ingredients=["番茄", "鸡蛋"],
            allergens=[],
        )

        self.assertEqual(result["planned_dish_count"], 1)
        self.assertEqual(result["recipes"][0]["name"]["zh"], "番茄炒蛋")

    def test_menu_validation_fills_blank_units_for_to_taste_ingredients(self) -> None:
        menu = sample_menu()
        menu["recipes"][0]["ingredients"][1]["quantity"] = "适量"
        menu["recipes"][0]["ingredients"][1]["unit"] = {"zh": "", "en": ""}

        result = validate_menu_payload(
            menu,
            ingredients=["番茄"],
            allergens=[],
        )

        unit = result["recipes"][0]["ingredients"][1]["unit"]
        self.assertEqual(unit, {"zh": "适量", "en": "to taste"})

    def test_menu_validation_accepts_common_oil_staple_aliases(self) -> None:
        menu = sample_menu()
        menu["recipes"][0]["ingredients"][1] = {
            "name": {"zh": "植物油", "en": "Vegetable oil"},
            "quantity": "适量",
            "unit": {"zh": "适量", "en": "to taste"},
        }

        result = validate_menu_payload(
            menu,
            ingredients=["番茄"],
            allergens=[],
        )

        self.assertEqual(result["recipes"][0]["ingredients"][1]["name"]["zh"], "植物油")

    def test_parse_llm_json_content_repairs_common_syntax_glitches(self) -> None:
        malformed = """
        {
          "reasoning": "test",
          "planned_dish_count": 1,
          "recipes": [
            {
              "name": {"zh": "青柠番茄沙拉", "en": "Lime Tomato Salad"},
              "description": {"zh": "desc", "en": "desc"},
              "category": {"zh": "凉菜", "en": "Salad"},
              "difficulty": {"zh": "简单", "en": "Easy"},
              "calories": 80,
              "cooking_time": 10,
              "servings": 2,
              "ingredients": [
                {"name": {"zh": "番茄", "en": "Tomato"}, "quantity": "2个", "unit": {"zh": "个", "en": "pieces"}},
                {"name": {"zh": "青柠汁", "en": "Lime juice"}, "quantity": "2汤匙", "unit": {"zh": "汤匙", "en": "tablespoons"}}
              ],
              "steps": [
                {"step": 1, "description": {"zh": "番茄切块，淋上青柠汁", "en": "Dice tomatoes and drizzle with lime juice"}},
                {"step": 2, "description": {"zh": "冷藏10分钟食用", "en": "Chill for 10 minutes before serving")}
              ],
              "tips": {"zh": "可加少量橄榄油提升口感", "en": "A splash of olive oil enhances the texture"},
              "tags": [{"zh": "素食", "en": "Vegetarian"}],
            }
          ],
          "candidates": []
        }
        """

        parsed = parse_llm_json_content(malformed)

        self.assertEqual(parsed["recipes"][0]["name"]["zh"], "青柠番茄沙拉")
        self.assertEqual(parsed["recipes"][0]["steps"][1]["description"]["zh"], "冷藏10分钟食用")

    def test_parse_llm_json_content_still_rejects_unrecoverable_garbage(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "不是合法 JSON"):
            parse_llm_json_content("this is not json at all")

    def test_menu_validation_accepts_synonyms_and_direct_derivatives(self) -> None:
        menu = {
            "reasoning": "用识别到的蔬菜和柑橘做两道清爽菜",
            "planned_dish_count": 3,
            "recipes": [
                {
                    "name": {"zh": "番茄炖胡萝卜土豆", "en": "Tomato Stewed Carrot and Potato"},
                    "description": {"zh": "将蔬菜炖煮至软烂", "en": "Stew vegetables until soft"},
                    "category": {"zh": "热菜", "en": "Main Course"},
                    "difficulty": {"zh": "简单", "en": "Easy"},
                    "calories": 180,
                    "cooking_time": 40,
                    "servings": 2,
                    "ingredients": [
                        {
                            "name": {"zh": "番茄", "en": "Tomato"},
                            "quantity": "2",
                            "unit": {"zh": "个", "en": "pieces"},
                        },
                        {
                            "name": {"zh": "胡萝卜", "en": "Carrot"},
                            "quantity": "1",
                            "unit": {"zh": "根", "en": "roots"},
                        },
                        {
                            "name": {"zh": "土豆", "en": "Potato"},
                            "quantity": "1",
                            "unit": {"zh": "个", "en": "pieces"},
                        },
                        {
                            "name": {"zh": "柠檬汁", "en": "Lemon Juice"},
                            "quantity": "1",
                            "unit": {"zh": "汤匙", "en": "tablespoons"},
                        },
                    ],
                    "steps": [
                        {
                            "step": 1,
                            "description": {"zh": "炖煮蔬菜", "en": "Stew the vegetables"},
                        }
                    ],
                    "tips": {"zh": "可以加少量橄榄油", "en": "Add a little olive oil"},
                    "tags": [{"zh": "炖菜", "en": "Stew"}],
                },
                {
                    "name": {"zh": "柠檬青柠汤", "en": "Lemon and Lime Soup"},
                    "description": {"zh": "带柑橘风味的清爽汤品", "en": "A light citrus soup"},
                    "category": {"zh": "汤品", "en": "Soup"},
                    "difficulty": {"zh": "简单", "en": "Easy"},
                    "calories": 100,
                    "cooking_time": 25,
                    "servings": 2,
                    "ingredients": [
                        {
                            "name": {"zh": "番茄", "en": "Tomato"},
                            "quantity": "1",
                            "unit": {"zh": "个", "en": "pieces"},
                        },
                        {
                            "name": {"zh": "青柠汁", "en": "Lime Juice"},
                            "quantity": "1",
                            "unit": {"zh": "汤匙", "en": "tablespoons"},
                        },
                    ],
                    "steps": [
                        {
                            "step": 1,
                            "description": {"zh": "煮汤并调味", "en": "Simmer and season"},
                        }
                    ],
                    "tips": {"zh": "少量盐即可", "en": "Only a small amount of salt is needed"},
                    "tags": [{"zh": "清爽", "en": "Light"}],
                },
            ],
            "candidates": [
                {
                    "name": {"zh": "青柠烤土豆", "en": "Lime Roasted Potato"},
                    "description": {"zh": "酸香开胃", "en": "Tangy and appetizing"},
                    "category": {"zh": "热菜", "en": "Main Course"},
                    "difficulty": {"zh": "简单", "en": "Easy"},
                    "calories": 200,
                    "cooking_time": 30,
                    "servings": 2,
                    "ingredients": [
                        {
                            "name": {"zh": "土豆", "en": "Potato"},
                            "quantity": "2",
                            "unit": {"zh": "个", "en": "pieces"},
                        },
                        {
                            "name": {"zh": "青柠汁", "en": "Lime Juice"},
                            "quantity": "2",
                            "unit": {"zh": "汤匙", "en": "tablespoons"},
                        },
                        {
                            "name": {"zh": "橄榄油", "en": "Olive Oil"},
                            "quantity": "1",
                            "unit": {"zh": "汤匙", "en": "tablespoons"},
                        },
                    ],
                    "steps": [
                        {
                            "step": 1,
                            "description": {"zh": "拌匀后烤制", "en": "Mix and roast"},
                        }
                    ],
                    "tips": {"zh": "可撒黑胡椒", "en": "Add black pepper if desired"},
                    "tags": [{"zh": "烤制", "en": "Roast"}],
                }
            ],
        }

        result = validate_menu_payload(
            menu,
            ingredients=["胡萝卜", "土豆/马铃薯", "柠檬", "青柠", "番茄/西红柿"],
            allergens=[],
        )

        self.assertEqual(result["planned_dish_count"], 2)
        self.assertEqual(result["recipes"][0]["ingredients"][3]["name"]["zh"], "柠檬汁")

    def test_menu_validation_rejects_unknown_ingredients(self) -> None:
        with self.assertRaisesRegex(RuntimeError, "未识别食材"):
            validate_menu_payload(
                sample_menu("牛肉"),
                ingredients=["番茄", "鸡蛋"],
                allergens=[],
            )

    def test_menu_validation_still_rejects_extra_staple_like_pasta(self) -> None:
        menu = sample_menu()
        menu["candidates"][0]["ingredients"].append(
            {
                "name": {"zh": "意大利面", "en": "Pasta"},
                "quantity": "200",
                "unit": {"zh": "克", "en": "grams"},
            }
        )

        with self.assertRaisesRegex(RuntimeError, "未识别食材"):
            validate_menu_payload(
                menu,
                ingredients=["番茄/西红柿", "鸡蛋"],
                allergens=[],
            )

    def test_menu_validation_rejects_allergens(self) -> None:
        menu = sample_menu("花生米")
        menu["recipes"][0]["name"]["zh"] = "花生番茄"
        menu["candidates"][0]["name"]["zh"] = "花生汤"

        with self.assertRaisesRegex(RuntimeError, "过敏原食材"):
            validate_menu_payload(
                menu,
                ingredients=["番茄"],
                allergens=["花生"],
            )


if __name__ == "__main__":
    unittest.main()
