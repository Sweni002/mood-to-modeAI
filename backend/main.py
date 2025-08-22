from fastapi import FastAPI
from models import user, outfit
from database.database import Base, engine
from api import routes_user, route_outfit

# Crée les tables dans PostgreSQL si elles n'existent pas
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Mood-to-Mode AI Backend")

# Inclure les routes API
app.include_router(routes_user.router)
app.include_router(route_outfit.router)
