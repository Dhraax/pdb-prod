# Loot extraction eligibility

## Current contract

`pb_tesoros_inc.nss` owns equipment classification. Before assigning
`CNR_LOOT_TIER`, `FinalizarObjetoCreado` asks `TreasureIsEquipment` whether the
item's base type declares a nonzero `EquipableSlots` mask in the server's
`baseitems.2da`. This is a data rule, independent of item names or individual
blueprint resrefs. Empty and undefined masks are refused.

The tracked `haks-2da/baseitems.2da` establishes the relevant distinction:
weapons, armour and worn accessories declare slots; magic staves do too, while
magic rods, magic wands, potions, scrolls, gems and ordinary miscellaneous
items have zero slot masks. Ammunition declares its ammunition slots.
The runtime reads the server table, so testing must use the corresponding hak.

## Colour and tier are one decision (since 2026-09-28)

A piece of equipment the treasure system creates carries `CNR_LOOT_TIER` equal
to the rank of the colour its name was given, set by
`CnrLoot_MarkGenerated` (`cnr_i_loot.nss`) in the same place the name is
coloured:

| Colour | Rank | Named by |
|---|--:|---|
| No colour, no enchantment | 1 | `FinalizarObjetoCreado`, plain branch |
| Grey-blue, "superior" | 1 | `FinalizarObjetoCreado` rank 1; `nombrarObjeto` up to 9 HD |
| Cyan, "encantado/a" | 2 | rank 2; 10-19 HD |
| Blue, "poderoso/a" | 3 | rank 3; 20-29 HD |
| Gold, "legendario/a" | 4 | rank 4; 30-39 HD |
| Magenta, "titánico/a" | 5 | rank 5; 40+ HD |

`FinalizarObjetoCreado` (`pb_tesoros_inc`) marks both of its branches; every
creator of the `pb_tesoro_*` libraries marks next to its `nombrarObjeto`.
What the extractor yields per rank is in `cnr_i_extract.nss` and
`arcane-plan.md` section 7.

**Everything the treasure system creates is loot**: creature and boss drops,
ordinary and boss chests, quest rewards (Doyle's `qa_recompensa`,
`quest_addai3_1`, `quest_selune3_1`, `quest_viuda3_1`, `quest_reliquia6`) and
treasure pouches (`pb_mod_activate`). The only exclusion is shop stock:
`iTienda` set, or a store as the target. Gold, scrolls, gems, potions, junk and
miscellany are not equipment and are never marked.

Until 2026-09-28 a piece was marked only when its target carried
`CNR_LOOT_SOURCE`, which corpses and chests set and players do not, so quest
rewards were never extractable; and `FinalizarObjetoCreado` marked only its
enchanted branch, so plain chest equipment was not either. The flag is gone.
The change is not retroactive: pieces created before it keep whatever they
had.

**The rule is enforced before compiling.** `scripts/check_loot_marks.py`, run
by `linux_build.sh` in `--check` and in a build, fails when a library creator
does not both name and mark its item, when a `pb_tesoros_inc` piece started by
`IniciarObjetoCreado` is not finished by `FinalizarObjetoCreado`, when that
function does not mark both branches, when a new creator there makes items
outside that pair without being listed as non-equipment, or when any script
but `cnr_i_loot` calls `CnrLoot_Mark` directly.

`cnr_i_extract.nss` trusts this mark for equipment classification. Its common
`CnrExt_Tier` predicate also requires identification and refuses
`CNR_ENCANTADO`. Counts, single-item extraction and batch extraction all use
that predicate, including the check immediately before destruction. The
extractor does not repeat the equipment classifier.

## Fresh creature loot

The normal creature branch passes loot rank 1 for every challenge rating, so
ordinary creature loot is rank 1: grey, and minimal at the extractor. Bosses
(`JEFAZO`) and boss chests produce higher ranks from their hit dice.

## Verification

Static inspection establishes the marker and refusal paths; compilation does
not establish runtime equipment or conversation behavior. Test freshly
created, identified equipment of each marked rarity, and repeat before
identification: the unidentified item must remain intact. Check a magic staff
and several worn equipment types, then non-equipment loot including magic
rods and wands: the latter must have no extraction mark. Verify that quest
rewards and plain chest equipment are extractable, and that shop stock and
Arcane-enchanted items remain refused. Exercise
single and mixed batch extraction, confirming refused items remain inside.

## Provenance

Equipment masks come from the tracked PDB `haks-2da/baseitems.2da`, reviewed
2026-09-18; classification is based on that project data, without claiming a
stock-game baseline. The native API contract was checked through
`nwn-official` against the pinned build 8193.37 reference, SHA-256
`c14098d0181f921618622f379ff5cb682b8656d5293f218392531eef7a8478ad`:
`GetBaseItemType` supplies the row, `Get2DAString` reads the named column and
returns empty when missing, and `GetIdentified` reports identification.
`Get2DAString` warns against use in loops; the new helper reads the table once
per classified generated item, outside its short string-mask loop, and adds
no heartbeat or inventory scan. Hexadecimal integer parsing is not assumed.
