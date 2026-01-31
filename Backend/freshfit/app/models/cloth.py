from sqlalchemy import Column, Integer, String, ForeignKey
from app.db.base import Base


class Cloth(Base):
    __tablename__ = "clothes"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    category = Column(String, nullable=False)
    color = Column(String, nullable=False)

    image_path = Column(String, nullable=True)

    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
