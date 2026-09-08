/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_c_config
/// @author  Dhraax
/// @brief   Constants for persistent account and character identity.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

// Table names.
const string PWDB_TABLE_ACCOUNT   = "pwdb_account";
const string PWDB_TABLE_CHARACTER = "pwdb_character";
const string PWDB_TABLE_PROFILE   = "pwdb_character_profile";
const string PWDB_TABLE_CLASS     = "pwdb_character_class";
const string PWDB_TABLE_LEVEL_UNLOCK = "pwdb_character_level_unlock";
const string PWDB_TABLE_ACCOUNT_MANAGEMENT = "pwdb_account_management";
const string PWDB_TABLE_ACCOUNT_CDKEY_RESET = "pwdb_account_cdkey_reset";
const string PWDB_TABLE_REVISION = "pwdb_identity_revision";
const string PWDB_TABLE_ACCOUNT_NAME_HISTORY = "pwdb_account_name_history";
const string PWDB_TABLE_ACCOUNT_CDKEY_HISTORY = "pwdb_account_cd_key_history";
const string PWDB_TABLE_ACCOUNT_IP_HISTORY = "pwdb_account_ip_history";
const string PWDB_TABLE_CDKEY_BAN = "pwdb_cd_key_ban";

// Cached on CONTENEDOR_VARIABLES. Overwritten from the database on every login;
// a value carried over from a previous session is never trusted.
const string PWDB_VAR_CHARACTER_ID = "PWDB_CHARACTER_ID";

// Set only during the in-game rebuild workflow after the provisional database
// tree has been removed. While present, runtime systems must not recreate it.
const string PWDB_VAR_REBUILD_CLEANED = "PWDB_REBUILD_CLEANED";

// Every character starts with this many completed rebuild opportunities.
const int PWDB_DEFAULT_REBUILDS_AVAILABLE = 2;

// Seconds to wait before permanently deleting an administratively removed PC.
const float PWDB_DELETE_DELAY = 5.0;

const string PWDB_MSG_CONTACT_ADMIN =
    "Ponte en contacto con administracion via foro, en dudas o sugerencias privadas.";

// Message shown when the CD key does not match the one registered for this
// character. Player-facing text stays in Spanish.
const string PWDB_MSG_CDKEY_MISMATCH =
    "Este personaje esta registrado en otra cuenta. "
    + PWDB_MSG_CONTACT_ADMIN;

// Messages shown when control-panel access policy refuses the game session.
const string PWDB_MSG_ACCOUNT_BLOCKED =
    "Esta cuenta no tiene permitido acceder al servidor. "
    + PWDB_MSG_CONTACT_ADMIN;
const string PWDB_MSG_CHARACTER_BLOCKED =
    "Este personaje no tiene permitido acceder al servidor. "
    + PWDB_MSG_CONTACT_ADMIN;
const string PWDB_MSG_CHARACTER_DELETED =
    "Tu personaje ha sido eliminado administrativamente. Se eliminara de forma "
    + "definitiva en 5 segundos.";
const string PWDB_MSG_VALIDATION_FAILED =
    "No se ha podido validar el acceso al servidor. Intentalo de nuevo mas tarde.";
const string PWDB_MSG_CDKEY_BANNED =
    "Esta CD key no tiene permitido acceder al servidor.";
const string PWDB_MSG_ACCOUNT_NAME_MISMATCH =
    "Este nombre de cuenta esta protegido por otra CD key. "
    + PWDB_MSG_CONTACT_ADMIN;
const string PWDB_MSG_ACCOUNT_NAME_AMBIGUOUS =
    "Este nombre de cuenta requiere revision administrativa. "
    + PWDB_MSG_CONTACT_ADMIN;
