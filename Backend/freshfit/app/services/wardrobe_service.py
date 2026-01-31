from sqlalchemy.orm import Session
from app.models.cloth import Cloth


def create_cloth(
    db: Session,
    user_id: int,
    name: str,
    category: str,
    color: str,
    image_path: str | None = None,
):
    cloth = Cloth(
        name=name,
        category=category,
        color=color,
        image_path=image_path,
        user_id=user_id,
    )
    db.add(cloth)
    db.commit()
    db.refresh(cloth)
    return cloth


def get_user_clothes(db: Session, user_id: int):
    return db.query(Cloth).filter(Cloth.user_id == user_id).all()


def delete_cloth(db: Session, cloth_id: int, user_id: int):
    cloth = (
        db.query(Cloth)
        .filter(Cloth.id == cloth_id, Cloth.user_id == user_id)
        .first()
    )

    if cloth:
        db.delete(cloth)
        db.commit()

    return cloth
