from sqlalchemy import Column, Integer, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from app.db.base import Base


class Outfit(Base):
    __tablename__ = "outfits"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    top_id = Column(Integer, ForeignKey("clothes.id"), nullable=False)
    bottom_id = Column(Integer, ForeignKey("clothes.id"), nullable=False)
    shoes_id = Column(Integer, ForeignKey("clothes.id"), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User")

    top = relationship("Cloth", foreign_keys=[top_id])
    bottom = relationship("Cloth", foreign_keys=[bottom_id])
    shoes = relationship("Cloth", foreign_keys=[shoes_id])
