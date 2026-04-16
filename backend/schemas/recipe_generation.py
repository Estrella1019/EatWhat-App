from typing import Any

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator


def _strip_required(value: Any, label: str) -> str:
    if not isinstance(value, str):
        raise TypeError(f"{label}必须是字符串")
    stripped = value.strip()
    if not stripped:
        raise ValueError(f"{label}不能为空")
    return stripped


def _normalize_string_list(values: list[str], label: str) -> list[str]:
    normalized: list[str] = []
    seen: set[str] = set()
    for value in values:
        stripped = _strip_required(value, label)
        if stripped not in seen:
            normalized.append(stripped)
            seen.add(stripped)
    return normalized


class GenerateRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    diners: int = Field(ge=1, le=12)
    ingredients: list[str] = Field(min_length=1, max_length=40)
    dietary: list[str] = Field(default_factory=list, max_length=20)
    allergens: list[str] = Field(default_factory=list, max_length=20)
    preferences: list[str] = Field(default_factory=list, max_length=20)

    @field_validator("ingredients", "dietary", "allergens", "preferences")
    @classmethod
    def normalize_lists(cls, values: list[str], info) -> list[str]:
        labels = {
            "ingredients": "食材",
            "dietary": "忌口",
            "allergens": "过敏原",
            "preferences": "偏好",
        }
        return _normalize_string_list(values, labels[info.field_name])


class LocalizedText(BaseModel):
    model_config = ConfigDict(extra="ignore")

    zh: str
    en: str

    @field_validator("zh", "en")
    @classmethod
    def validate_text(cls, value: str, info) -> str:
        label = "中文文本" if info.field_name == "zh" else "英文文本"
        return _strip_required(value, label)


class GeneratedIngredient(BaseModel):
    model_config = ConfigDict(extra="ignore")

    name: LocalizedText
    quantity: str
    unit: LocalizedText

    @field_validator("quantity")
    @classmethod
    def validate_quantity(cls, value: str) -> str:
        return _strip_required(value, "食材数量")


class GeneratedStep(BaseModel):
    model_config = ConfigDict(extra="ignore")

    step: int = Field(ge=1, le=50)
    description: LocalizedText


class GeneratedRecipe(BaseModel):
    model_config = ConfigDict(extra="ignore")

    name: LocalizedText
    description: LocalizedText
    category: LocalizedText
    difficulty: LocalizedText
    calories: int = Field(ge=0, le=5000)
    cooking_time: int = Field(ge=1, le=720)
    servings: int = Field(ge=1, le=20)
    ingredients: list[GeneratedIngredient] = Field(min_length=1, max_length=30)
    steps: list[GeneratedStep] = Field(min_length=1, max_length=50)
    tips: LocalizedText
    tags: list[LocalizedText] = Field(default_factory=list, max_length=20)


class GeneratedMenu(BaseModel):
    model_config = ConfigDict(extra="ignore")

    reasoning: str
    planned_dish_count: int = Field(default=0, ge=0)
    recipes: list[GeneratedRecipe] = Field(min_length=1, max_length=20)
    candidates: list[GeneratedRecipe] = Field(default_factory=list, max_length=10)

    @field_validator("reasoning")
    @classmethod
    def validate_reasoning(cls, value: str) -> str:
        return _strip_required(value, "推理说明")

    @model_validator(mode="after")
    def normalize_counts_and_uniqueness(self) -> "GeneratedMenu":
        seen_names: set[str] = set()
        for recipe in [*self.recipes, *self.candidates]:
            recipe_name = recipe.name.zh.strip()
            if recipe_name in seen_names:
                raise ValueError(f"菜谱名称重复: {recipe_name}")
            seen_names.add(recipe_name)

        self.planned_dish_count = len(self.recipes)
        return self
