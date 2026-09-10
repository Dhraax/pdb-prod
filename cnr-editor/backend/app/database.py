"""SQLAlchemy engine and request-scoped session factory."""

from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.config import get_settings


class Base(DeclarativeBase):
    """Declarative base shared by control-panel and managed system tables."""


settings = get_settings()
engine = create_engine(
    settings.sqlalchemy_url(),
    pool_pre_ping=True,
    pool_recycle=1800,
)
SessionLocal = sessionmaker(bind=engine, autoflush=False, expire_on_commit=False)


def get_db() -> Generator[Session, None, None]:
    """Yield one database session per HTTP request."""

    with SessionLocal() as session:
        yield session
