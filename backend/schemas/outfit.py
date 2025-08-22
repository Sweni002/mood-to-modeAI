from pydantic import BaseModel

class OutfitBase(BaseModel):
    description: str
    occasion: str

class OutfitCreate(OutfitBase):
    pass

class Outfit(OutfitBase):
    id: int

    class Config:
        orm_mode = True
