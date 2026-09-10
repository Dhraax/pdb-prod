# Rules

How this server's ruleset behaves where it departs from stock NWN:EE, or where
the answer is spread across enough scripts that nobody can hold it in their
head. Mechanics, not content: what the engine and the module do, why, and what
is known to be wrong with it.

This module exists because the ruleset does not belong to any of the others.
`oficios/` owns crafting, `database/` owns persistence, `nwscript/` owns style
and language, `control-panel/` owns the admin tool, and `repository/` owns
operations — a rule about how two bonuses combine has no home in any of them.

A document here describes **what is true now**, including the parts that are
broken. A change that is proposed and not yet taken belongs in
`../pending-changes/` instead, and should link back to the document here that
explains the system it would change.

## Documents

| Document | Scope |
|----------|-------|
| [`spell-effect-library.md`](spell-effect-library.md) | Combined implementation record and remaining plan for the split spell-effect library, area ownership, effect identities and unfinished caller migration |
| [`bonus-stacking.md`](bonus-stacking.md) | How ability, skill, saving throw and regeneration bonuses combine: the item and spell halves of `nostack_inc.nss`, every place stacking is currently allowed and whether that was a decision, the `-1` spell id problem that no list can solve, and what the disabled NWNX NoStack plugin would offer instead |
| [`caster-level.md`](caster-level.md) | **Current caster-level ownership:** the implemented engine-facing prestige modifiers, the still-separate module calculation, 2DA responsibilities and known limitations |
