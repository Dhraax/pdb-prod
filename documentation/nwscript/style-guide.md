# NWScript Style Guide

## Scope

These rules apply to new scripts, new includes, and code materially refactored
for Puerta de Baldur. Preserve unrelated legacy code and established public API
names.

## API References

Never guess engine or plugin APIs.

- Confirm native NWScript functions, constants, callbacks, and engine behavior
  in the [NWN Lexicon](https://nwnlexicon.com/index.php/Main_Page).
- Confirm NWNX plugin functions, event data, return values, and runtime behavior
  in the [NWNX:EE unified documentation](https://nwnxee.github.io/unified/).
- Keep native NWN:EE and NWNX APIs clearly distinguished in code and design
  documentation.

When an external lookup reveals behavior not documented locally, add the
durable result to the relevant module documentation in the same change.

## Script Header

Every script and include starts with:

```nwscript
/// ----------------------------------------------------------------------------
/// @system  (SYSTEM NAME)
/// @file    (SCRIPT NAME)
/// @author  Dhraax
/// @brief   (DESCRIPTION)
/// ----------------------------------------------------------------------------
```

Replace every placeholder. Keep descriptions concise and in English. New
project scripts created for the user always use `Dhraax` as the author.

When modifying an existing project script, keep its original author and add the
following line before the closing separator:

```nwscript
/// modified by: Dhraax
```

Add the marker only once. Do not rewrite authorship in untouched scripts,
third-party code, vendor code, or generated files.

## Include Layout

Every public function is declared as a prototype before any function
implementation. Includes use this order:

```nwscript
// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------
```

Do not allow a public prototype and its definition to drift. Search callers
before changing either signature.

## Function Documentation

Place the full documentation block immediately above each prototype:

```nwscript
/// @brief Run an event, causing all subscribed scripts to trigger.
/// @param sEvent The name of the event.
/// @param oInitiator The object triggering the event, such as a PC entering.
/// @param oTarget The object on which to run the event.
/// @param iLocalOnly TRUE to skip scripts from plugins and other objects.
/// @returns A bitmask of EVENT_STATE_* constants describing how the event
///     finished:
///     - EVENT_STATE_OK: all queued scripts executed successfully.
///     - EVENT_STATE_ABORT: a script cancelled the remaining queue.
///     - EVENT_STATE_DENIED: a script denied the event.
int RunEvent(
    string sEvent,
    object oInitiator = OBJECT_INVALID,
    object oTarget = OBJECT_SELF,
    int iLocalOnly = FALSE
);
```

Requirements:

- One `@brief` line per function.
- One `@param` line per parameter, in declaration order.
- One `@returns` entry for every non-void function.
- Continue detailed contracts on indented `///` lines.
- Add side effects, ownership, ordering constraints, failure modes, and event
  context notes when callers need them.
- Do not document behavior that the implementation does not guarantee.

## Naming

- Member variables: `m_` plus type prefix plus lowerCamelCase, for example
  `m_oOwner`.
- Static globals: `s_` plus type prefix plus lowerCamelCase, for example
  `s_iActiveCount`.
- Local variables and parameters: type prefix plus lowerCamelCase, for example
  `oOwner`, `iCount`, `fDelay`, `sMessage`, `vPosition`, or `lDestination`.
- Functions and classes: UpperCamelCase.
- Macros and preprocessor defines: ALL_CAPS.
- Constants: `Namespaced::UpperCamelCase` where the language supports
  namespaces. NWScript does not support `::`; use the documented system naming
  convention instead of invalid syntax.
- Preserve third-party and existing public API names even when they use an
  older convention.

Every variable and parameter carries its data-type prefix. Use `o` for
`object`, `i` for `int`, `f` for `float`, and the lowercase first letter for
other types.

## Formatting

- Opening braces and closing braces always occupy their own lines.
- Indent with four spaces. Never use tabs.
- End every text file with a newline.
- Write comments, identifiers, headers, and technical documentation in English.
- Preserve Spanish player-facing content unless translation is part of the
  requested change.
- C++ headers use `.hpp`; C++ source files use `.cpp`.

## NWN Constraints

- Resrefs are limited to 16 characters and use letters, numbers, and
  underscores. Do not rename an existing resref without tracing every consumer.
- Object tags are limited to 32 characters. Truncate constructed tags
  explicitly before creation and lookup.
- Keep shared include dependency chains shallow and search all consumers before
  changing a public include.
- Prefer one clear public include per new system and keep internal helpers
  private where NWScript permits it.
