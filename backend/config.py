import os
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, "data")

INGREDIENTS_JSON_PATH = os.path.join(DATA_DIR, "ingredients_dict.json")
YOLO_MODEL_PATH = os.path.join(DATA_DIR, "yolov8s-world.pt")

# LLM 配置 (LM Studio / OpenAI 兼容接口)
LLM_API_URL = os.getenv("LLM_API_URL", "http://localhost:1234/v1/chat/completions")
LLM_MODEL = os.getenv("LLM_MODEL", "qwen3-14b-mlx")

# YOLO 识别阈值
YOLO_REVIEW_CONFIDENCE = float(os.getenv("YOLO_REVIEW_CONFIDENCE", "0.25"))
YOLO_ACCEPTED_CONFIDENCE = float(os.getenv("YOLO_ACCEPTED_CONFIDENCE", "0.45"))

# JWT
JWT_SECRET = os.getenv("JWT_SECRET", "change-me-in-production")
JWT_ALGORITHM = "HS256"
JWT_EXPIRE_MINUTES = 60 * 24 * 7  # 7天

# 数据库
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql:///eatfor?host=/tmp")
