from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps.db import get_db
from app.api.deps.auth import get_current_user
from app.models.user import User
from app.services.wardrobe_service import get_user_clothes
from app.services.outfit_generator import generate_outfit
from app.utils.file_utils import build_image_url

router = APIRouter(prefix="/outfits", tags=["Outfits"])


@router.post("/generate")
def generate_user_outfit(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    clothes = get_user_clothes(db, current_user.id)

    if not clothes:
        raise HTTPException(status_code=400, detail="No clothes in wardrobe")

    try:
        outfit = generate_outfit(clothes)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    # attach image URLs
    for item in outfit.values():
        item.image_url = build_image_url(item.image_path)

    return outfit
