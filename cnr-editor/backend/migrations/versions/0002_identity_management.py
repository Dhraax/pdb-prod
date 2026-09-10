"""Add normalized account and character management tables."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0002_identity_management"
down_revision: str | None = "0001_editor_identity"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


CLASS_DEFINITIONS = [
    (0, "Barbarian", "Bárbaro"),
    (1, "Bard", "Bardo"),
    (2, "Cleric", "Clérigo"),
    (3, "Druid", "Druida"),
    (4, "Fighter", "Guerrero"),
    (5, "Monk", "Monje"),
    (6, "Paladin", "Paladín"),
    (7, "Ranger", "Explorador"),
    (8, "Rogue", "Pícaro"),
    (9, "Sorcerer", "Hechicero"),
    (10, "Wizard", "Mago"),
    (27, "Shadowdancer", "Danzarín sombrío"),
    (28, "Harper", "Arpista"),
    (29, "Arcane_Archer", "Arquero arcano"),
    (30, "Assassin", "Asesino"),
    (32, "CampeonDivino", "Campeón divino"),
    (33, "WeaponMaster", "Maestro de armas"),
    (34, "Pale_Master", "Maestro de la lividez"),
    (35, "Shifter", "Cambiante"),
    (36, "Dwarven_Defender", "Defensor enano"),
    (37, "DiscipuloDeDragon", "Discípulo del dragón"),
    (42, "Tirador_Espesura", "Tirador de la espesura"),
    (43, "Bribon_Arcano", "Bribón arcano"),
    (44, "Ladron_Sombras_Amn", "Ladrón de las Sombras de Amn"),
    (45, "Caballero_Arcano", "Caballero arcano"),
    (46, "ShadowAdept", "Adepto sombrío"),
    (48, "Teurgo", "Teúrgo"),
    (49, "Orc_Warlord", "Señor de la guerra orco"),
    (52, "Cavalier", "Caballero"),
    (53, "Archmage", "Archimago"),
    (54, "Harper", "Arpista (variante PDB)"),
    (55, "ShadowAdept", "Adepto sombrío (variante PDB)"),
    (56, "Frenzied_Berserker", "Bersérker frenético"),
    (57, "Warlock", "Brujo"),
    (58, "Swashbuckler", "Espadachín"),
    (59, "AlmaPredilecta", "Alma predilecta"),
    (60, "Paladin_Antiguos", "Paladín de los Antiguos"),
    (61, "Paladin_Oscuro", "Paladín oscuro"),
    (62, "Paladin_Vengador", "Paladín vengador"),
    (63, "Maestro_formas", "Maestro de las formas"),
    (64, "Artifice", "Artífice"),
]


def _has_table(table_name: str) -> bool:
    """Return whether MySQL already created a table during a partial migration."""
    return sa.inspect(op.get_bind()).has_table(table_name)


def upgrade() -> None:
    if not _has_table("pwdb_class_definition"):
        op.create_table(
            "pwdb_class_definition",
            sa.Column(
                "class_id",
                mysql.SMALLINT(unsigned=True),
                autoincrement=False,
                nullable=False,
            ),
            sa.Column("code", sa.String(length=32), nullable=False),
            sa.Column("display_name", sa.String(length=64), nullable=False),
            sa.Column("enabled", sa.Boolean(), server_default=sa.true(), nullable=False),
            sa.PrimaryKeyConstraint("class_id"),
        )
    else:
        # MySQL commits CREATE TABLE even when the following migration statement
        # fails. Repair the table created by the first, interrupted attempt.
        op.alter_column(
            "pwdb_class_definition",
            "class_id",
            existing_type=mysql.SMALLINT(unsigned=True),
            autoincrement=False,
            existing_nullable=False,
        )
    class_table = sa.table(
        "pwdb_class_definition",
        sa.column("class_id", mysql.SMALLINT(unsigned=True)),
        sa.column("code", sa.String(length=32)),
        sa.column("display_name", sa.String(length=64)),
        sa.column("enabled", sa.Boolean()),
    )
    op.execute(
        class_table.insert()
        .prefix_with("IGNORE")
        .values(
            [
                {
                    "class_id": class_id,
                    "code": code,
                    "display_name": display_name,
                    "enabled": True,
                }
                for class_id, code, display_name in CLASS_DEFINITIONS
            ]
        )
    )

    if not _has_table("pwdb_account_management"):
        op.create_table(
            "pwdb_account_management",
            sa.Column("account_id", sa.Integer(), nullable=False),
            sa.Column("display_name_override", sa.String(length=64), nullable=True),
            sa.Column("status", sa.String(length=16), server_default="active", nullable=False),
            sa.Column("admin_notes", sa.Text(), nullable=True),
            sa.Column("updated_by", sa.Integer(), nullable=True),
            sa.Column(
                "updated_at",
                mysql.DATETIME(fsp=6),
                server_default=sa.text("CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)"),
                nullable=False,
            ),
            sa.CheckConstraint(
                "status IN ('active','suspended','banned','archived')",
                name="ck_account_management_status",
            ),
            sa.ForeignKeyConstraint(
                ["account_id"], ["pwdb_account.account_id"], ondelete="CASCADE"
            ),
            sa.ForeignKeyConstraint(
                ["updated_by"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
            ),
            sa.PrimaryKeyConstraint("account_id"),
        )

    if not _has_table("pwdb_character_profile"):
        op.create_table(
            "pwdb_character_profile",
            sa.Column("character_id", sa.Integer(), nullable=False),
            sa.Column("display_name_override", sa.String(length=64), nullable=True),
            sa.Column("status", sa.String(length=16), server_default="active", nullable=False),
            sa.Column("race_id", mysql.SMALLINT(unsigned=True), nullable=True),
            sa.Column("subrace", sa.String(length=32), nullable=True),
            sa.Column("gender_id", mysql.SMALLINT(unsigned=True), nullable=True),
            sa.Column("portrait_resref", sa.String(length=16), nullable=True),
            sa.Column("deity", sa.String(length=64), nullable=True),
            sa.Column("admin_notes", sa.Text(), nullable=True),
            sa.Column("updated_by", sa.Integer(), nullable=True),
            sa.Column(
                "updated_at",
                mysql.DATETIME(fsp=6),
                server_default=sa.text("CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)"),
                nullable=False,
            ),
            sa.CheckConstraint(
                "status IN ('active','retired','blocked','deleted')",
                name="ck_character_profile_status",
            ),
            sa.ForeignKeyConstraint(
                ["character_id"], ["pwdb_character.character_id"], ondelete="CASCADE"
            ),
            sa.ForeignKeyConstraint(
                ["updated_by"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
            ),
            sa.PrimaryKeyConstraint("character_id"),
        )

    if not _has_table("pwdb_character_class"):
        op.create_table(
            "pwdb_character_class",
            sa.Column("character_id", sa.Integer(), nullable=False),
            sa.Column("class_slot", mysql.TINYINT(unsigned=True), nullable=False),
            sa.Column("class_id", mysql.SMALLINT(unsigned=True), nullable=False),
            sa.Column("class_level", mysql.TINYINT(unsigned=True), nullable=False),
            sa.Column(
                "updated_at",
                mysql.DATETIME(fsp=6),
                server_default=sa.text("CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)"),
                nullable=False,
            ),
            sa.CheckConstraint("class_slot BETWEEN 1 AND 3", name="ck_character_class_slot"),
            sa.CheckConstraint("class_level BETWEEN 1 AND 40", name="ck_character_class_level"),
            sa.ForeignKeyConstraint(
                ["character_id"], ["pwdb_character.character_id"], ondelete="CASCADE"
            ),
            sa.ForeignKeyConstraint(["class_id"], ["pwdb_class_definition.class_id"]),
            sa.PrimaryKeyConstraint("character_id", "class_slot"),
            sa.UniqueConstraint("character_id", "class_id", name="uq_character_class_once"),
        )

    if not _has_table("pwdb_identity_revision"):
        op.create_table(
            "pwdb_identity_revision",
            sa.Column("revision_id", sa.BigInteger(), autoincrement=True, nullable=False),
            sa.Column("target_type", sa.String(length=16), nullable=False),
            sa.Column("target_id", sa.Integer(), nullable=False),
            sa.Column("actor_user_id", sa.Integer(), nullable=False),
            sa.Column("action", sa.String(length=16), nullable=False),
            sa.Column(
                "changed_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("before_json", sa.JSON(), nullable=False),
            sa.Column("after_json", sa.JSON(), nullable=False),
            sa.CheckConstraint(
                "target_type IN ('account','character')", name="ck_identity_revision_target"
            ),
            sa.ForeignKeyConstraint(["actor_user_id"], ["cnr_editor_user.user_id"]),
            sa.PrimaryKeyConstraint("revision_id"),
        )
    revision_indexes = {
        index["name"] for index in sa.inspect(op.get_bind()).get_indexes("pwdb_identity_revision")
    }
    if "ix_identity_revision_target" not in revision_indexes:
        op.create_index(
            "ix_identity_revision_target",
            "pwdb_identity_revision",
            ["target_type", "target_id", "changed_at"],
        )

    op.execute(
        "INSERT IGNORE INTO pwdb_account_management (account_id) "
        "SELECT account_id FROM pwdb_account"
    )
    op.execute(
        "INSERT IGNORE INTO pwdb_character_profile (character_id) "
        "SELECT character_id FROM pwdb_character"
    )


def downgrade() -> None:
    op.drop_index("ix_identity_revision_target", table_name="pwdb_identity_revision")
    op.drop_table("pwdb_identity_revision")
    op.drop_table("pwdb_character_class")
    op.drop_table("pwdb_character_profile")
    op.drop_table("pwdb_account_management")
    op.drop_table("pwdb_class_definition")
