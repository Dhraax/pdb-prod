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

The remaining producer conditions are unchanged: the target must have
`CNR_LOOT_SOURCE`, the item must not be shop stock, and loot rank must be at
least 2. Ranks 2 through 5 receive extraction tiers 1 through 4. Grey rank 1
receives no extraction mark.

`cnr_i_extract.nss` trusts this mark for equipment classification. Its common
`CnrExt_Tier` predicate also requires identification and refuses
`CNR_ENCANTADO`. Counts, single-item extraction and batch extraction all use
that predicate, including the check immediately before destruction. The
extractor does not repeat the equipment classifier.

## Fresh creature loot

The normal creature branch currently passes loot rank 1 for every challenge
rating. Consequently, ordinary newly generated creature loot is grey and has
no extraction mark. Boss and container generation can produce higher ranks.
This is a separate loot-rank policy from equipment eligibility; this slice
changes neither rarity nor essence yields. A test reporting rejection must
record the source, rank and identification state of its item.

## Verification

Static inspection establishes the marker and refusal paths; compilation does
not establish runtime equipment or conversation behavior. Test freshly
created, identified equipment of each marked rarity, and repeat before
identification: the unidentified item must remain intact. Check a magic staff
and several worn equipment types, then non-equipment loot including magic
rods and wands: the latter must have no extraction mark. Verify shop stock,
quest rewards, grey loot and Arcane-enchanted items remain refused. Exercise
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
