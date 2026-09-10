/// ---------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_mod_load.nss
/// @author  Dhraax
/// @brief   Initializes PWDB before delegating to the production module load.
/// ---------------------------------------------------------------------------

#include "pwdb_i_user"

void main()
{
    PWDB_EnsureIdentitySchema();
    ExecuteScript("wrap_on_mod_load", OBJECT_SELF);
}
