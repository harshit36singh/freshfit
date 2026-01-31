import os
import uuid
from fastapi import APIRouter, UploadFile, File, HTTPException

from app.services.image_processor import extract_dominant_color

router = APIRouter(prefix="/upload", tags=["Upload"])

UPLOAD_DIR = "uploads/clothes"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/cloth-image")
async def upload_cloth_image(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Invalid image file")

    ext = file.filename.split(".")[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    file_path = os.path.join(UPLOAD_DIR, filename)

    with open(file_path, "wb") as f:
        f.write(await file.read())

    dominant_color = extract_dominant_color(file_path)

    return {
        "filename": filename,
        "dominant_color": dominant_color
    }
