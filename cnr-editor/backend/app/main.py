"""FastAPI application for the Control Panel."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.routers import admin, arcane, audit, auth, dm_access, identity, recipes

settings = get_settings()
app = FastAPI(title=settings.panel_title, version="0.1.0", docs_url="/api/docs")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.frontend_origin],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
    allow_headers=["Content-Type", "X-CSRF-Token"],
)
app.include_router(auth.router, prefix="/api")
app.include_router(admin.router, prefix="/api")
app.include_router(arcane.router, prefix="/api")
app.include_router(audit.router, prefix="/api")
app.include_router(dm_access.router, prefix="/api")
app.include_router(identity.router, prefix="/api")
app.include_router(recipes.router, prefix="/api")


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
