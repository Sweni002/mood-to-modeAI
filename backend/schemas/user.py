from pydantic import BaseModel
from typing import List
from .outfit import Outfit

class UserBase(BaseModel):
    name: str
    mood: str
    location: str

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: int
    outfits: List[Outfit] = []

    class Config:
        orm_mode = True
