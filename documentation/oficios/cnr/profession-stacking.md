# Profession item stacking

## Scope and inventory

The owner authorized profession-only stacks of ten on 2026-09-18. The scope
starts with CNR palette resources and shop stock, including crafting components,
consumables, station tools and the seven harvesting tools used by CNR. The
owner confirmed crafted equipment must retain its existing limits. No
historical object conversion is included.

The [blueprint inventory](profession-stack-items.csv) contains 516 resources:
509 CNR blueprints and seven harvesting tools. It cross-checks all 499 CNR
palette resources. There are 337 materials/consumables, 40 tools and 139
equipment blueprints. Of the selected supplies and tools, 295 need dedicated
types and 82 already have a limit of ten. The inventory includes unlisted CNR
consumable templates referenced by the system rather than guessing ownership
from their prefix alone.

The [shop-copy inventory](profession-stack-shop-copies.csv) identifies 72 item
copies in eight tracked areas, including 62 in `_basefaccione001`. Only nodes
with an exact tag, internal resref and original base-type identity match are
selected; the two skinning knife variants share an internal identity and are
distinguished by base type. Store buy/sell type lists are not item copies.

## Dependencies and compatibility

Stacking in `haks-2da/baseitems.2da` is a type-level maximum. Blueprint StackSize
is the initial amount, not a per-item maximum override. Exact native MCP
SetItemStackSize documentation clamps the requested count to that type maximum;
GetItemStackSize reads the count. Source: accepted nwscript.nss SHA256
c14098d0181f921618622f379ff5cb682b8656d5293f218392531eef7a8478ad.

Crafting finds station tools by tag and equipped slot; harvesting and skinning
also select their tools by tag. These paths do not compare tools against native
base-item IDs. Dedicated rows preserve every original behaviour field except
Stacking, including equipment slots, size, model class, property columns and
weapon requirements. Table copying establishes data consistency; it does not
prove engine equipability or successful stack merging. Those remain runtime
acceptance checks for each equipable tool type.

Crafting property and Arcane crystal rules contain base-type comparisons for
equipment. Equipment blueprints and ammunition are therefore retained in this
scope, preserving those rules. Other scripts may treat dedicated tool IDs as
custom types; tool combat, equipment slots and store handling need testing.

Source evidence: `src/cnr/nss/cnr_i_craft.nss`, `cnr_i_node.nss`,
`cnr_i_skin.nss`, `cnr_i_prop.nss`, `cnr_i_arcane.nss`,
`src/shared/nss/pb_mod_activate.nss`, the CNR palette and inventoried shop areas.
Harvesting quantities, DCs, cooldowns, tool life and crafting breakage chances
are outside this change and remain unchanged.

## Implementation status

1. Inventory and type-dependent consumer inspection completed. No resources
   have been remapped by this inventory slice.
2. Dedicated types 520-537 are appended, copying 18 original rows and changing
   only Stacking to 10. All existing rows and unrelated working-tree edits are
   preserved. The CSV records the original-to-dedicated type mapping.
3. The 295 selected blueprints use their dedicated types. Selected supply/tool
   copies in all eight inventoried shop areas use matching types and quantity
   ten. Existing stack-10 material/consumable types remain unchanged. Names,
   tags, resrefs, appearance and other blueprint fields are preserved. Palette
   resource references remain valid and require no edits.
4. `cnr_i_stack.nss` consumes one broken unit. Database crafting, node wear,
   skinning knife wear and retained legacy CNR breakage callers use it. Wear
   resets for the successor unit only when a wear-based tool breaks. Failure
   messages and outcomes, wear costs and percentages remain unchanged. Legacy
   temporary name-probe cleanup still destroys the temporary object.
5. Deterministic checks and focused compilation are recorded with the tool
   slice. Packaging, independent review and runtime acceptance remain pending.

## Release and acceptance

The HAK and module must be repacked and released together; clients need the
updated HAK. The source slices do not package, deploy or restart the server.
PROD lacks the structural documentation checker. Independent review and
in-game acceptance remain pending.

Test buying packs, counts and prices, merging and splitting each dedicated
type, depositing and crafting exact component quantities, and acquiring node,
skinning, extractor and recycler material outputs. Test both needle and knife
size variants and all gloves/hammer/harvesting tools equipped. Break a tool
from a stack of ten and from a single unit; only one unit must disappear.
Exhaust the current harvesting/knife unit and verify its successor starts with
full uses. Check unrelated items on every original type retain their original
limits, and crafted equipment remains unchanged.

## Deterministic verification

Focused compilation passed with four executables compiled, five includes
skipped and zero errors:

```bash
./linux_build.sh --check cnr_i_stack.nss cnr_i_craft.nss cnr_i_node.nss cnr_i_skin.nss cnr_recipe_utils.nss cnr_a_craft.nss cnr_node_hit.nss cnr_skin_hit.nss cnr_at_b_craft.nss
```

All 295 changed blueprints differ only at BaseItem. Changes in the eight shop
areas are confined to selected item BaseItem and StackSize fields. Every prior
2DA byte remains intact, and all 18 appended rows differ from their original
rows only at the Stacking field. Checks preserve original CRLF line endings.
These results establish source consistency and compilation, not runtime
stackability or equipability.

All 139 equipment blueprints were compared byte-for-byte with the pre-stacking
baseline `08903760` and are unchanged. None of the four stacking candidates
modifies a palette file. The owner confirmed the materials/consumables/tools
scope after the source slices were prepared.

The observed `python3 migration/build_catalogue.py --check` result is failure at
ten existing naming errors in five dirty placeables: `cnralchemytable`,
`cnrarcanetable`, `cnrhebcauldron`, `cnrjewelersbench`, `cnrsewingtable`. These
station files were not edited by the stacking slices. The check stopped there;
a complete catalogue pass is not claimed. Independent review was not run.
