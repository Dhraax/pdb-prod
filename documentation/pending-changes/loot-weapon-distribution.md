# Loot Weapon Distribution

Status: pending review. Nothing here is implemented.

Notes taken while building the CNR base item list, kept so they are not lost.
They come from reading `IniciarObjetoCreado` in
`src/shared/nss/pb_tesoros_inc.nss`, not from playing, and the analysis is
deliberately shallow: the real review comes later.

## What the intent is

Every weapon the server has, including the ones PDB added, should be reachable
from loot and at a comparable rate. The list of types with their base items is
[`documentation/oficios/cnr/base-items.md`](../oficios/cnr/base-items.md), which
is what this should be written against.

## What was found

1. **Three melee cases are empty.** 17 (doble-hacha), 25 (manguales ligeros) and
   29 (mazas ligeras y pesadas) are declared with their comment and hold no
   statement, so `sResref` stays blank and `CreateItemOnObject` returns an
   invalid object that the rest of the function keeps working on. The caller
   rolls `Random(36)+1`, so **8.3% of melee weapons produce nothing**.

2. **The roll is flat.** Every melee case is 1 in 36, whatever its rarity and
   whether it holds 3 variants or 15.

3. **The comments lie.** Case 15 is named `// SAI` and assigns `ZEP_XDBSC_001`,
   a double scimitar (base item 321), so **the sai, base item 303, never
   drops**. Case 3, `// Dagas`, includes a sorcerer dagger (514) among plain
   daggers.

4. **A case is not a type.** Some group several - case 18, "Hachas arrojadizas /
   Chakrams", assigns a battle axe among fifteen variants. Working out what can
   actually drop means resolving all 550 resrefs in the switch to their base
   items, and 361 of those are stock and would have to be extracted from the
   game first. Not done, so **no "type X never drops" claim is safe except case
   15**, which was resolved directly.

## To decide when this is picked up

- Fill the three empty cases, or remove them and shorten the roll.
- Flat roll with one case per base item, or weights.
- Which of the 67 base items should come from loot at all: ammunition, huge
  weapons and crafting-only items are not obvious.
- Whether case 15 should drop the sai its name promises.

The function already has an `iDebugMess` flag that prints every resref it
creates; a large sample with it on is enough to check any new distribution.
