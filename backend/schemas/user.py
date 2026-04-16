from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field, field_validator


def _strip_required(value: Any, label: str) -> str:
    if not isinstance(value, str):
        raise TypeError(f"{label}必须是字符串")
    stripped = value.strip()
    if not stripped:
        raise ValueError(f"{label}不能为空")
    return stripped


class AllergenCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    name: str = Field(min_length=1, max_length=100)

    @field_validator("name", mode="before")
    @classmethod
    def normalize_name(cls, value: Any) -> str:
        return _strip_required(value, "过敏原名称")


class AllergenOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class FavoriteCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    recipe_name: str = Field(min_length=1, max_length=200)
    recipe_data: dict[str, Any]

    @field_validator("recipe_name", mode="before")
    @classmethod
    def normalize_name(cls, value: Any) -> str:
        return _strip_required(value, "菜谱名称")

    @field_validator("recipe_data")
    @classmethod
    def validate_recipe_data(cls, value: dict[str, Any]) -> dict[str, Any]:
        if not value:
            raise ValueError("菜谱内容不能为空")
        return value


class FavoriteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    recipe_name: str
    recipe_data: dict[str, Any]
    created_at: datetime
