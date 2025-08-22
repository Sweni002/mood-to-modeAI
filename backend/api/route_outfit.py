from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.database import SessionLocal
from models.outfit import Outfit
from schemas.outfit import Outfit, OutfitCreate

router = APIRouter(prefix="/outfits", tags=["Outfits"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/{user_id}", response_model=Outfit)
def create_outfit(user_id: int, outfit: OutfitCreate, db: Session = Depends(get_db)):
    db_outfit = Outfit(description=outfit.description, occasion=outfit.occasion, owner_id=user_id)
    db.add(db_outfit)
    db.commit()
    db.refresh(db_outfit)
    return db_outfit

@router.get("/", response_model=list[Outfit])
def read_outfits(db: Session = Depends(get_db)):
    return db.query(Outfit).all()
