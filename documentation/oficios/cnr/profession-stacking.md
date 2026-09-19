# Profession item stacking

## Current rule

Only profession materials and consumable recipe components use the dedicated
stack size of ten. Every profession tool is unitary, whether it is equipped or
merely required in inventory or on a station. Crafted equipment retains its
native limits; ammunition retains its native ammunition stack.

The [blueprint inventory](profession-stack-items.csv) covers 516 resources and
the [shop inventory](profession-stack-shop-copies.csv) covers the current 70
profession stock copies. Roles are established from the actual base-item equip
slots and the station-tool catalogue, rather than inferred from item names.

## Implementation

Dedicated rows 523, 525, 530-533 and 536-537 retain stack ten for materials and
consumable components. Templates and moulds remain stackable because recipes
consume them as components. Bottles and vials remain stackable consumables.

Twenty-four tool blueprints use their original native base type and StackSize
one: 18 equipable tools plus the five inventory kits and the saw. Their 27
tracked shop copies also use the original base type and sell one unit. The ten
formerly assigned equipable dedicated rows 520-522, 524, 526-529 and 534-535
have Stacking one as a defensive limit and are no longer referenced by the
inventoried tool blueprints or shop stock.

The generic tool-break helper still removes one object. Its stack branch is
retained for defensive compatibility with an already-stacked object, but the
current catalogue and stores do not create or sell tool packs.

The obsolete embedded store `tienda_artarcana` is removed from
`_basefaccione001`. It contained only pure water and spell-infusion vials. Its
NPC and dialog references remain so a corrected Arcane store can reuse the
stable tag later; today they find no store and cannot open that stock.

## Release and acceptance

The base-item correction requires repacking the owning 2DA HAK. The store and
embedded stock corrections require repacking the module. Source work does not
package, deploy or restart the server.

Test every listed store: tools must be sold one at a time, while materials,
bottles, vials, templates and moulds remain in packs of ten. Buy and equip each
size variant. Confirm inventory-only kits and the saw stay unitary and that one
break removes the object. Confirm Arcane shop dialogs do not open obsolete
stock. Test representative material node output, processing output and recipe
consumption. Check crafted weapons, armour and accessories remain unitary and
ammunition keeps its native stack.

## Deterministic verification

The correction is data-only and modifies no NWScript. Verification compares all
24 tool blueprints and 27 stock copies against the recorded native base IDs and
quantity one, all ten defensive 2DA limits, retained material/component rows,
and removal of exactly the Arcane store with its two obsolete stock items.
Packaging, runtime acceptance and independent review remain pending.
