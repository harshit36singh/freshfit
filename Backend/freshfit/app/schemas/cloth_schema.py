from pydantic import BaseModel
from typing import Optional


class ClothBase(BaseModel):
    name: str
    category: str
    color: str


class ClothCreate(ClothBase):
    pass


class ClothResponse(ClothBase):
    id: int
    image_url: Optional[str] = None

    class Config:
        from_attributes = True
