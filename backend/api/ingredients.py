import json
from fastapi import APIRouter, UploadFile, File, HTTPException

from api.response_utils import ok
from config import INGREDIENTS_JSON_PATH
from services.yolo_service import get_yolo_service

router = APIRouter()


@router.post("/ingredients/recognize")
async def recognize_ingredients(image: UploadFile = File(...)):
    """Upload an image and return the list of ingredients recognized by YOLO"""
    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="请上传图片文件")

    image_bytes = await image.read()
    try:
        detector = get_yolo_service()
        detected = detector.identify(image_bytes)
    except RuntimeError as e:
        raise HTTPException(status_code=503, detail=str(e)) from e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"识别失败: {str(e)}") from e

    return ok(detected)


@router.get("/ingredients")
def list_ingredients():
    """Return the list of all recognizable ingredients"""
    with open(INGREDIENTS_JSON_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    result = []
    for category, items in data.items():
        for item in items:
            result.append({
                "name": {"zh": item["zh"], "en": item["en"].capitalize()},
                "category": category
            })

    return ok({"ingredients": result})
