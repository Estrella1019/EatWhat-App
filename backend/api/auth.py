from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from api.response_utils import ok
from database import get_db
from models import User
from schemas.auth import RegisterRequest, LoginRequest, TokenResponse
from services.auth_service import hash_password, verify_password, create_token

router = APIRouter()


@router.post("/auth/register")
def register(req: RegisterRequest, db: Session = Depends(get_db)):
    """Successful registration of new users token will be returned"""
    if db.query(User).filter(User.username == req.username).first():
        raise HTTPException(status_code=409, detail="用户名已存在")
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail="邮箱已被注册")

    user = User(
        username=req.username,
        email=req.email,
        hashed_password=hash_password(req.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_token(user.id, user.username)
    return ok(TokenResponse(access_token=token, username=user.username).model_dump())


@router.post("/auth/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    """Log in with username and password, token will be returned"""
    user = db.query(User).filter(User.username == req.username).first()
    if not user or not verify_password(req.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="用户名或密码错误")

    token = create_token(user.id, user.username)
    return ok(TokenResponse(access_token=token, username=user.username).model_dump())
