# NWScript Script Templates

Copy-paste starting points for new PDB scripts. Rules behind them are in
[`style-guide.md`](style-guide.md).

Replace every `(...)` placeholder. Keep the separator lines exactly as written —
they are the project's recognizable section markers.

---

## 1. Include template

Use for any file that exposes functions to other scripts.

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (DESCRIPTION)
/// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

const string (PREFIX)_VAR_EXAMPLE = "(prefix)_example";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief (Brief description of the function.)
/// @param oTarget (What this object is and what state it must be in.)
/// @param sValue (What this string carries.)
/// @returns TRUE on success, FALSE when (failure condition).
int (Prefix)DoSomething(object oTarget, string sValue);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int (Prefix)DoSomething(object oTarget, string sValue)
{
    if (!GetIsObjectValid(oTarget))
    {
        return FALSE;
    }

    SetLocalString(oTarget, (PREFIX)_VAR_EXAMPLE, sValue);
    return TRUE;
}
```

Notes:

- The `Constants` section is optional; drop it when the include declares none.
- Every public function needs a prototype **above** the definitions section.
- Private helpers may be defined in the definitions section without a prototype,
  but still carry a `///` documentation block.

---

## 2. Event / action script template

Use for scripts the engine or a conversation calls directly — event handlers,
dialog actions, and conditionals. These have a `void main()` (or
`int StartingConditional()`) and expose nothing.

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (What triggers this script and what it does.)
/// ----------------------------------------------------------------------------

#include "(include_resref)"

void main()
{
    object oPC = GetLastUsedBy();

    if (!GetIsPC(oPC))
    {
        return;
    }

    (Prefix)DoSomething(oPC, "(value)");
}
```

Conditional variant:

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (Which dialog node this gates and on what condition.)
/// ----------------------------------------------------------------------------

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return GetIsObjectValid(oPC) && (condition);
}
```

Replace `GetLastUsedBy()` with the getter matching the actual event
(`GetEnteringObject()`, `GetItemActivator()`, `GetPCSpeaker()`, and so on). Do
not guess: confirm the event getter through the `nwn-official` MCP and, when its
extracted comment is insufficient, the vendored
[`reference/nwscript.nss`](reference/README.md).

---

## 3. Modifying an existing script

Preserve the original `@author` and add the marker before the closing separator:

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  (Original Author)
/// @brief   (Existing description; update only if behavior changed.)
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
```

Add `modified by: Dhraax` once. If it is already present, leave it alone.

---

## 4. Before saving

- Resref is 16 characters or fewer, `[A-Za-z0-9_]` only.
- File ends with a newline.
- Four-space indentation, no tabs.
- Braces open and close on their own lines.
- File is placed correctly: shared resource types go to `src/shared/<ext>/`,
  CNR content to `src/cnr/<ext>/`, NUI content to `src/nui/<ext>/`. Nasher's
  routing rules only fire on unpack, so a new file must be put in the right
  directory by hand.
