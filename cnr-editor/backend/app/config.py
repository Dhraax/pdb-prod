"""Runtime configuration loaded exclusively from environment variables."""

from functools import lru_cache

from pydantic import AliasChoices, Field, SecretStr, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy import URL


class Settings(BaseSettings):
    """Validated control-panel configuration."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="CNR_EDITOR_",
        extra="ignore",
    )

    database_url: SecretStr | None = None
    mysql_host: str = Field(default="mysql", validation_alias=AliasChoices("MYSQL_HOST"))
    mysql_port: int = Field(default=3306, validation_alias=AliasChoices("MYSQL_PORT"))
    mysql_database: str | None = Field(
        default=None, validation_alias=AliasChoices("MYSQL_DATABASE")
    )
    mysql_user: str | None = Field(default=None, validation_alias=AliasChoices("MYSQL_USER"))
    mysql_password: SecretStr | None = Field(
        default=None, validation_alias=AliasChoices("MYSQL_PASSWORD")
    )
    panel_title: str = Field(
        default="Control Panel",
        min_length=1,
        max_length=80,
        validation_alias=AliasChoices("CONTROL_PANEL_TITLE"),
    )
    frontend_origin: str = "http://127.0.0.1:5173"
    cookie_secure: bool = True
    session_ttl_hours: int = Field(default=12, ge=1, le=168)
    mfa_challenge_ttl_minutes: int = Field(default=5, ge=1, le=15)
    mfa_encryption_key: SecretStr | None = None
    mfa_issuer: str = Field(default="Control Panel", min_length=1, max_length=64)
    login_failure_window_minutes: int = Field(default=15, ge=1, le=60)
    writes_enabled: bool = False
    session_cookie_name: str = "cnr_editor_session"
    csrf_cookie_name: str = "cnr_editor_csrf"
    mfa_challenge_cookie_name: str = "cnr_editor_mfa_challenge"

    @model_validator(mode="after")
    def require_database_credentials(self) -> "Settings":
        if self.database_url is None and not all(
            (self.mysql_database, self.mysql_user, self.mysql_password)
        ):
            raise ValueError("database_url or MYSQL_DATABASE/MYSQL_USER/MYSQL_PASSWORD is required")
        return self

    def sqlalchemy_url(self) -> str | URL:
        """Build a driver URL without interpolating or logging database secrets."""

        if self.database_url is not None:
            return self.database_url.get_secret_value()
        return URL.create(
            "mysql+pymysql",
            username=self.mysql_user,
            password=self.mysql_password.get_secret_value() if self.mysql_password else None,
            host=self.mysql_host,
            port=self.mysql_port,
            database=self.mysql_database,
        )


@lru_cache
def get_settings() -> Settings:
    """Return the process-wide validated settings object."""

    return Settings()  # type: ignore[call-arg]
