# NWScript Style Guide

Canonical style rules for PDB NWScript. `AGENTS.md` carries the summary; this is
the detailed reference it points to.

Apply these rules to new code and to code materially refactored by the current
task. Do not reformat untouched legacy files just to conform.

---

## 1. File header

Every new script and include starts with this header:

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (DESCRIPTION)
/// ----------------------------------------------------------------------------
```

- `@system` names the owning system (for example `CNR`, `NUI`, `RAZAS`).
- `@file` is the resref, without extension.
- `@brief` is one line describing what the file does.

### Authorship tracking

Applies only to scripts created or modified on the user's behalf.

- New project scripts use `/// @author  Dhraax`.
- When modifying an existing project script, **preserve its original `@author`
  line** and add `/// modified by: Dhraax` before the closing separator.
- If `modified by: Dhraax` is already present, do not add it again.
- Do not add the marker to untouched scripts, third-party code, generated files,
  or vendor code.
- Documentation-only inspection is not a modification.

Modified-file example:

```nwscript
/// ----------------------------------------------------------------------------
/// @system  CNR
/// @file    cnr_recipe_load
/// @author  Original Author
/// @brief   Loads recipe metadata for the active tradeskill.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
```

---

## 2. Include layout

Every include declares all public functions as documented prototypes **before**
any implementation, using these exact headings and this order:

```nwscript
// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------
```

Never place a public function definition before the prototype section. Keep
prototypes and definitions synchronized: a signature change edits both.

---

## 3. Function documentation

Every prototype carries a documentation block immediately above it:

```nwscript
/// @brief Run an event, causing all subscribed scripts to trigger.
/// @param sEvent The name of the event.
/// @param oInitiator The object that triggered the event, e.g. a PC on client enter.
/// @param oTarget The object on which to run the event.
/// @param iLocalOnly TRUE to skip scripts from plugins and other objects.
/// @returns A bitmask of EVENT_STATE_* constants describing how the event finished:
///     - EVENT_STATE_OK: all queued scripts executed successfully
///     - EVENT_STATE_ABORT: a script cancelled the remaining queue
///     - EVENT_STATE_DENIED: a script specified that the event should be cancelled
int RunEvent(
    string sEvent,
    object oInitiator = OBJECT_INVALID,
    object oTarget = OBJECT_SELF,
    int iLocalOnly = FALSE
);
```

Rules:

- Exactly one `@brief` line.
- One `@param` line per parameter, in declaration order.
- `@returns` on every non-void function. Continue onto indented `///` lines when
  the return contract needs more detail.
- Additional contract notes go after the tags and before the prototype.

---

## 4. Naming

| Kind | Convention | Example |
|------|------------|---------|
| Function | UpperCamelCase | `GetRecipeMetadata` |
| Class | UpperCamelCase | `RecipeCache` |
| Variable / parameter | lowerCamelCase after prefixes | `oTarget`, `iCount` |
| Macro / define | ALL_CAPS | `CNR_MAX_RECIPES` |
| Constant | `Namespaced::UpperCamelCase` where the language allows | see note below |
| Member variable | `m_` prefix | `m_oOwner` |
| Static global | `s_` prefix | `s_iActiveCount` |

### Type prefixes

Every variable and parameter carries a type prefix:

| Type | Prefix | Example |
|------|--------|---------|
| `object` | `o` | `oTarget` |
| `int` | `i` | `iCount` |
| `float` | `f` | `fDelay` |
| `string` | `s` | `sName` |
| `vector` | `v` | `vPosition` |
| `location` | `l` | `lSpawn` |

Other types use the lowercase first letter of the type name. Combine storage and
type prefixes: `m_oOwner` is an object member; `s_iActiveCount` is a static int
global; a plain local object is `oOwner`.

### Constants in NWScript

NWScript has **no namespace operator**. Do not emulate `Namespaced::Constant`
syntax — it will not compile. Use the system's documented prefix instead:

```nwscript
const int    CNR_STATE_IDLE     = 0;
const string CNR_VAR_RECIPE_ID  = "cnr_recipe_id";
```

### Preserving legacy names

Preserve existing public API parameter names even when they predate this
convention. Do not break callers merely to rename them.

---

## 5. Formatting

- Braces always open on a new line and close on a new line.
- Four spaces of indentation, never tabs.
- Every text file ends with a newline.
- C++ headers use `.hpp`; C++ sources use `.cpp`.

```nwscript
void ApplyRecipe(object oPC, string sRecipeId)
{
    if (!GetIsPC(oPC))
    {
        return;
    }

    SetLocalString(oPC, CNR_VAR_RECIPE_ID, sRecipeId);
}
```

---

## 6. Language and encoding

- Comments, identifiers, and script headers are written in English.
- Existing Spanish player-facing content stays Spanish unless translation is
  part of the task.
- Preserve file encoding. Project files outside Markdown are treated as
  Windows-1252; unpack passes `--gffFlags="--nwn-encoding windows-1252"`. Never
  bypass that flag — accented content will corrupt.
- Prefer ASCII-safe punctuation in technical files. No Unicode decoration in
  game or build files.

---

## 7. Include hygiene and coupling

- Keep include dependency chains shallow.
- Search all consumers before changing a shared include.
- Prefer one clear public include per new system; keep implementation details
  private where NWScript's file model allows it.
- Never invent project APIs or resource relationships. Search references and
  callers before changing a public include, event script, resref, tag, local
  variable name, database key, or persisted data shape.
- Treat module event scripts, shared includes, persistence, character data,
  areas, and deployment as high-risk: their coupling may not be visible from a
  single file.
- Prefer event-driven behavior where the engine exposes a suitable event. Avoid
  global heartbeat work and other unbounded hot paths.

---

## 8. Engine limits

| Limit | Value | Consequence |
|-------|-------|-------------|
| Resref length | 16 characters, `[A-Za-z0-9_]` | Longer names are rejected or truncated; confirm against existing legacy resrefs before renaming |
| Tag length | 32 characters | The engine truncates silently. Truncate constructed tags explicitly — UUID-based tags otherwise fail lookup after truncation |

---

## 9. References

- Native NWScript declarations and engine comments: the `nwn-official` MCP,
  then [`reference/nwscript.nss`](reference/README.md) when neighbouring source
  context is required.
- Reusable behavior not established by that contract:
  [`engine-behavior.md`](engine-behavior.md), backed by a probe, release note or
  pinned source.
- NWNX:EE signatures and plugin behavior: the `nwnx` MCP, then the pinned
  `nwnxee/` source when the extracted view is insufficient.

Never guess undocumented engine or plugin behavior. When either API affects a
design, record the exact source or probe in the resulting module documentation.
