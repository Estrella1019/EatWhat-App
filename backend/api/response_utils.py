from typing import Any

from fastapi.responses import JSONResponse


def build_payload(code: int, message: str, data: Any) -> dict[str, Any]:
    return {"code": code, "message": message, "data": data}


def ok(data: Any = None, status_code: int = 200, message: str = "success") -> JSONResponse:
    return JSONResponse(
        status_code=status_code,
        content=build_payload(status_code, message, data),
    )
