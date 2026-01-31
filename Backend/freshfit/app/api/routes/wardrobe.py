import os
import uuid
from app.utils.file_utils import build_image_url

from fastapi import (
    APIRouter,
    Depends,
    UploadFile,
    File,
    Form,
    HTTPException,
)
from sqlalchemy.orm import Session

from app.api.deps.db import get_db
from app.api.deps.auth import get_current_user
from app.models.user import User
from app.schemas.cloth_schema import ClothResponse
from app.services.wardrobe_service import (
    create_cloth,
    get_user_clothes,
    delete_cloth,
)
from app.services.image_processor import extract_dominant_color

router = APIRouter(prefix="/wardrobe", tags=["Wardrobe"])

UPLOAD_DIR = "uploads/clothes"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/with-image", response_model=ClothResponse)
async def add_cloth_with_image(
    name: str = Form(...),
    category: str = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Invalid image file")

    ext = file.filename.split(".")[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    image_path = os.path.join(UPLOAD_DIR, filename)

    with open(image_path, "wb") as f:
        f.write(await file.read())

    color = extract_dominant_color(image_path)

    cloth = create_cloth(
        db=db,
        user_id=current_user.id,
        name=name,
        category=category,
        color=color,
        image_path=image_path,
    )
    cloth.image_url = build_image_url(cloth.image_path)
    return cloth



@router.get("/", response_model=list[ClothResponse])
def list_clothes(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    clothes = get_user_clothes(db, current_user.id) 
    for cloth in clothes: 
        cloth.image_url = build_image_url(cloth.image_path) 
    return clothes

@router.delete("/{cloth_id}")
def remove_cloth(
    cloth_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    cloth = delete_cloth(db, cloth_id, current_user.id)
    if not cloth:
        raise HTTPException(status_code=404, detail="Cloth not found")
    return {"message": "Cloth deleted"}
