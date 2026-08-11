# NWScript Public Include Template

Copy this template when creating a public system include. Replace all
placeholders and keep the file's resref within NWN limits.

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (DESCRIPTION)
/// ----------------------------------------------------------------------------

#ifndef PDB_SYSTEM_INCLUDED
#define PDB_SYSTEM_INCLUDED

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Perform the system operation for the target object.
/// @param oTarget The object affected by the operation.
/// @param iOption Integer option controlling the operation.
/// @returns TRUE when the operation succeeds; otherwise FALSE.
int PerformOperation(object oTarget, int iOption);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int PerformOperation(object oTarget, int iOption)
{
    if (!GetIsObjectValid(oTarget))
    {
        return FALSE;
    }

    // Implement system behavior here.
    return TRUE;
}

#endif
```

For an executable event script, retain the required header and formatting,
include the system's public include, and keep `main()` focused on capturing the
event context and delegating to the system API.
