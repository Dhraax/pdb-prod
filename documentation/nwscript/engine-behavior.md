# NWN:EE Engine Behavior Register

Status: **current through the reviewed 8193.37 native reference copied on
2026-08-25.** This document records reusable engine behavior that requires more
context than one extracted API symbol. Project-specific rules remain in their
owning module.

## Evidence standard

Every entry must identify:

- the engine or server build;
- whether the behavior comes from the vendored native source, pinned NWNX
  source, an upstream release note, or an in-game probe;
- the exact source location or probe procedure;
- what remains inference or untested.

Do not use an ignored local corpus such as `Content/` or `cow-scripts/` as the
only evidence. It may help find the answer, but another clean checkout must be
able to reproduce the resulting claim from a tracked source, a named upstream
source, or a documented probe.

## MCP boundary

The `nwn-official` MCP parses declarations, defaults, constants and engine
comments from the vendored `nwscript.nss`. It already exposes a native when that
declaration is parsed correctly. A new observation about runtime behavior does
not change that MCP automatically.

Use this decision:

| Discovery | Action |
|-----------|--------|
| A declaration or engine comment present in `nwscript.nss` is missing or malformed in a tool result | Fix the parser in the `nwn-official-mcp` provider, publish it, then advance the PDB gitlink |
| The native is already parsed correctly | No MCP change |
| Runtime behavior is established outside `nwscript.nss` and applies generally to NWN:EE | Add a versioned entry here |
| The behavior is a PDB rule or workaround | Document it in the owning PDB module |
| The finding should become queryable across projects | Propose a separate curated corpus in the provider; do not mix hand-written notes into the source-generated API silently |

## Area-of-effect spell context

For the reviewed 8193.37 native contract:

- `GetCasterLevel(oAoE)` returns the caster level used to create an area of
  effect. Evidence: `documentation/nwscript/reference/nwscript.nss`, declaration
  comment above `GetCasterLevel`, source line 7173.
- `GetLastSpellCastClass()` called from an area script returns the creator's
  spellcasting class. Evidence: the same source, line 11065.

These two natives replace project-local bookkeeping when an area script needs
the creation caster level or class. They do not establish metamagic behavior;
that remains a separate question and requires a probe.

Both became reliable in **1.88.8193.36**, whose release notes state that *"Area
of Effect objects now consistently store and retrieve their caster level and
spell ID"*, that *"Area of Effect scripts now use the spell ID and caster level
that was stored when the AOE was created"*, and that `GetLastSpellCastClass()`
*"returns the AOE creator's class in AOE scripts"*. The same build made caster
level calculations *"consistent across the engine including using the Caster
Level Multiplier"*. Evidence: nwn.wiki release notes for 1.88.8193.36, read
2026-09-02. The server runs `nwnxee/unified:build8193.37`
(`docker-compose.yml:3`), so the behavior is available.

## Spellcasting progression columns in classes.2da

For 8193.37:

- **`ArcSpellLvlMod` and `DivSpellLvlMod` govern spell slots, not caster level.**
  Each states how many levels of that class together add one level to an arcane
  or divine class when determining **spell slots**. They add no spells known and
  do not raise the caster level.
- **`CLMultiplier` is the only column that changes caster level.** It multiplies
  a single class's own caster level, is applied to `GetCasterLevel` and to the
  default caster level of effects, and is floored. It cannot borrow levels from
  another class.
- **`SpellCaster = 1` disables `ArcSpellLvlMod` and `DivSpellLvlMod`** for that
  row. A custom class with its own spell list must not carry both.

Evidence: the maintained `classes.2da` column reference at
`https://nwn.wiki/spaces/NWN1/pages/38175085/classes.2da`, read 2026-09-02. This
is a community-maintained page, not a Beamdog-published document. The 8193.36
release note quoted above independently confirms that the multiplier is what the
engine applies for caster level.

**Consequence, stated because it is easy to assume otherwise:** stock NWN:EE has
**no** mechanism by which a prestige class advances another class's caster level.
That a prestige class contributes nothing to `GetCasterLevel` has not been
established here by a probe; it is inferred from the column semantics above and
from NWNX shipping an opt-in tweak for exactly that behavior, described next.

## NWNX prestige caster levels, and its rounding

`Plugins/Tweaks/AddPrestigeclassCasterLevels.cpp` in the pinned NWNX revision
`3d4c4e13c6bf01b032ffe90534fc4a19eb036c03` adds prestige class levels to the
caster level, behind the environment variable
`NWNX_TWEAKS_ADD_PRESTIGECLASS_CASTER_LEVELS`, default off. It hooks
`ExecuteCommandGetCasterLevel`, `ExecuteCommandResistSpell` and
`CGameEffect::SetCreator` (lines 42-46 and 101-131).

Its formula is `(nClassLevel - 1) / nClassMod + 1` - a **ceiling**, which grants
the first caster level at the first class level. **It therefore cannot express a
progression that skips the first class level**; that is an inference from the
formula, not a documented limitation.

`NWNX_Creature_SetCasterLevelModifier` is the alternative and applies only inside
the same three windows (`Plugins/Creature/Creature.cpp:1684-1770`); a modifier of
zero removes the stored value.

## DestroyObject takes effect after the running script, not at the call

`DestroyObject(oItem)` with the default delay does not remove the object at the
call. The object stays valid, keeps its tag and is still returned by
`GetItemPossessedBy` until the script that called it has finished. The engine
comment in `nwscript.nss` says only "Destroy oObject (irrevocably)".

Evidence: probe by failure on the production host, build
`nwnxee/unified:build8193.37`, 2026-09-17. `cnr_i_legacy.nss` emptied an
inventory of a book with
`while (GetIsObjectValid(oBook)) { DestroyObject(oBook); oBook = GetItemPossessedBy(oPC, sTag); }`.
Every conversion that reached that loop ran until the engine aborted it with
`Script cnr_ofi_conv ... ERROR: TOO MANY INSTRUCTIONS`, and the client showed
`Lost Item: Manual de Herreria` only after the abort. The loop found the same
book on every pass.

**The consequence:** never loop on a search that the destroy is expected to
change. Change something the search reads first -`SetTag(oItem, ...)` before
`DestroyObject` moves `GetItemPossessedBy` on- or walk the inventory once with
`GetFirstItemInInventory`/`GetNextItemInInventory`, and cap the loop regardless.

## NWNX serialization does not carry non-persistent plugin variables

`NWNX_Object_Serialize` preserves ordinary object locals, because it goes through
the engine's own `SaveObjectState`. It does **not** preserve NWNX plugin
variables written with `bPersist = FALSE`, which are held in the plugin's own
store. Evidence: pinned revision `3d4c4e13c6`,
`Plugins/Object/NWScript/nwnx_object.nss` and `NWNXLib/POS.cpp`, read via the
external review of commit `2089dc70d` on 2026-09-02 and confirmed against the
call sites in this repository.

**The trap this creates:** an object local used to record that a non-persistent
plugin variable has been set will outlive it. A serialised and restored creature
comes back with the local and without the plugin state.

## Effect attribution metadata

The reviewed native contract exposes all of the following:

- `GetEffectCasterLevel` reads the creating creature's caster level, but returns
  zero for non-creature creators and spell-like abilities;
- `SetEffectCreator` replaces the creator and accepts `OBJECT_INVALID`;
- `SetEffectCasterLevel` sets the value used by dispel magic and
  `GetEffectCasterLevel`;
- `SetEffectSpellId` sets the spell identity used for stacking, dispel magic and
  `GetEffectSpellId`;
- `SpellResistanceCheck` accepts explicit spell id, caster level and spell
  resistance values and can suppress automatic feedback.

Evidence: `documentation/nwscript/reference/nwscript.nss`, lines 11786,
13594-13602 and 13827. The pinned `nwn-official` parser was checked on
2026-09-03 and returned all five declarations with zero parser diagnostics.

This confirms API availability and the contracts written above. It does not by
itself prove link propagation, save-game persistence beyond the native comment,
or how a non-creature creator interacts with faction and dispelling. Record
those only after a focused probe or a pinned implementation-source reading.

## Which saving-throw item property a constructor creates

`ItemPropertyBonusSavingThrowVsX` (save against an element or effect,
`IP_CONST_SAVEVS_*`) creates `ITEM_PROPERTY_SAVING_THROW_BONUS` (40), and
`ItemPropertyBonusSavingThrow` (Fortitude, Reflex, Will,
`IP_CONST_SAVEBASETYPE_*`) creates `ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC`
(41). The names suggest the opposite. `nwscript.nss` does not state the
mapping; `itempropdef.2da` does: row 40 `ImprovedSavingThrows` takes its
subtypes from `IPRP_SAVEELEMENT`, the table `IP_CONST_SAVEVS_*` indexes, and
row 41 `ImprovedSavingThrowsSpecific` from `IPRP_SAVINGTHROW`.

Evidence: the tracked `haks-2da/itempropdef.2da`, rows 40-41, and the
constructor comments in `documentation/nwscript/reference/nwscript.nss`
(lines 10507-10517), read on 2026-09-24. A check that walks item properties
for "the same save" must compare against 40 for a `VsX` bonus, as
`CnrCraft_SocketConflict` does.

## Caster-level ownership in PDB

PDB currently has both an engine-facing and a module-facing path. The current
server rule and the remaining split are documented in
[`../rules/caster-level.md`](../rules/caster-level.md). The implementation
research remains in
[`../pending-changes/caster-level.md`](../pending-changes/caster-level.md) while
its remaining slices are open.
