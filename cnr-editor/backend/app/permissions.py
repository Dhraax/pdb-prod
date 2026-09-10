"""Control-panel permission catalogue and compatibility presets."""

PERMISSION_NAMES = (
    "view_recipes",
    "edit_recipes",
    "view_users",
    "edit_users",
    "view_accounts",
    "edit_accounts",
    "activate_cd_keys",
    "view_characters",
    "view_character_identity",
    "edit_character_identity",
    "view_character_timestamps",
    "view_character_abilities",
    "view_character_classes",
    "view_character_level_unlocks",
    "edit_character_level_unlocks",
    "view_character_profile",
    "edit_character_profile",
    "view_character_tradeskills",
    "edit_character_tradeskills",
)

PERMISSION_DEPENDENCIES = {
    "edit_recipes": {"view_recipes"},
    "edit_users": {"view_users"},
    "edit_accounts": {"view_accounts"},
    "activate_cd_keys": {"view_accounts"},
    "view_characters": {"view_accounts"},
    "view_character_identity": {"view_accounts", "view_characters"},
    "edit_character_identity": {"view_character_identity"},
    "view_character_timestamps": {"view_accounts", "view_characters"},
    "view_character_abilities": {"view_accounts", "view_characters"},
    "view_character_classes": {"view_accounts", "view_characters"},
    "view_character_level_unlocks": {"view_accounts", "view_characters"},
    "edit_character_level_unlocks": {"view_character_level_unlocks"},
    "view_character_profile": {"view_accounts", "view_characters"},
    "edit_character_profile": {"view_character_profile"},
    "view_character_tradeskills": {"view_accounts", "view_characters"},
    "edit_character_tradeskills": {"view_character_tradeskills"},
}

ROLE_PERMISSION_PRESETS = {
    "admin": tuple(name for name in PERMISSION_NAMES if name != "activate_cd_keys"),
    "technical": PERMISSION_NAMES,
    "dungeon_master": tuple(
        name
        for name in PERMISSION_NAMES
        if name.startswith("view_") or name == "activate_cd_keys"
    ),
    "editor": ("view_recipes", "edit_recipes"),
    "collaborator": ("view_recipes", "edit_recipes"),
}


def missing_permission_dependencies(permission_names: set[str]) -> set[str]:
    """Return dependencies absent from a requested permission set."""
    missing: set[str] = set()
    for permission_name in permission_names:
        missing.update(PERMISSION_DEPENDENCIES.get(permission_name, set()) - permission_names)
    return missing
