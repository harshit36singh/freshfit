from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps.db import get_db
from app.api.deps.auth import get_current_user
from app.models.user import User
from app.models.outfit import Outfit
from app.services.wardrobe_service import get_user_clothes
from app.services.outfit_generator import generate_outfit
from app.utils.file_utils import build_image_url

router = APIRouter(prefix="/outfits", tags=["Outfits"])


def _serialize_outfit(outfit: Outfit) -> dict:
    def serialize_cloth(cloth):
        return {
            "id": cloth.id,
            "name": cloth.name,
            "category": cloth.category,
            "color": cloth.color,
            "image_url": build_image_url(cloth.image_path),
        }

    return {
        "id": str(outfit.id),
        "name": "Generated Outfit",
        "created_at": outfit.created_at.isoformat(),
        "occasion": None,
        "clothes": [
            serialize_cloth(outfit.top),
            serialize_cloth(outfit.bottom),
            serialize_cloth(outfit.shoes),
        ],
    }


@router.post("/generate")
def generate_user_outfit(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    clothes = get_user_clothes(db, current_user.id)
    if not clothes:
        raise HTTPException(status_code=400, detail="No clothes in wardrobe")

    try:
        outfit_dict = generate_outfit(clothes)  # returns {"top": ..., "bottom": ..., "shoes": ...}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    # Save to DB using your existing model
    outfit = Outfit(
        user_id=current_user.id,
        top_id=outfit_dict["top"].id,
        bottom_id=outfit_dict["bottom"].id,
        shoes_id=outfit_dict["shoes"].id,
    )
    db.add(outfit)
    db.commit()
    db.refresh(outfit)

    return _serialize_outfit(outfit)


@router.get("/")
def get_user_outfits(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    outfits = (
        db.query(Outfit)
        .filter(Outfit.user_id == current_user.id)
        .order_by(Outfit.created_at.desc())
        .all()
    )
    return [_serialize_outfit(o) for o in outfits]


@router.delete("/{outfit_id}")
def delete_outfit(
    outfit_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    outfit = db.query(Outfit).filter(
        Outfit.id == outfit_id,
        Outfit.user_id == current_user.id,
    ).first()

    if not outfit:
        raise HTTPException(status_code=404, detail="Outfit not found")

    db.delete(outfit)
    db.commit()
    return {"message": "Outfit deleted"}