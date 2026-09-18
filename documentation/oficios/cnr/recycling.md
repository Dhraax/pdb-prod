# Recipe-based recycling

## Crafted output contract

Every newly created table output carries integer locals `CNR_CRAFT_RECIPE`
(the selected recipe ID) and `CNR_CRAFT_TIER` (recipe tier 1 through 4).
`CnrCraft_Attempt` captures both before animation and passes them into
`CnrCraft_Finish`; completion does not read a later menu selection. Main
products, intermediate materials and byproducts are identified and stolen.
The temporary main output is stamped before `CopyItem(..., TRUE)`, and the
returned inventory object is stamped too, including a merged stack.

## Machine behavior

The dedicated placeable has tag, resref and filename `cnrRecyler`, with
`OnUsed = cnr_rec_ou`, an empty blueprint conversation and other event fields
empty. OnUsed explicitly opens `cnr_c_recycle` after inventory closes. The
confirmation uses `cnr_rec_do`; cancellation uses `cnr_rec_cancel`. This is
separate from the crafting and extraction conversations.

Insert one crafted object or stack. The preview covers the entire stack.
The recycler resolves the stored ID in the current `cnr_recipe` table and
always uses that recipe's immediate component rows. For each component:

```
refund = floor((qty - retain_on_success) * input_stack_size / (4 * output_qty))
```

Rounding is separate for each component. Retained ingredients contribute zero;
station tools and crafting gold are not component refunds. There is no recursive
conversion into raw materials. A resolved recipe whose refunds all round to
zero still recycles for zero materials, which the preview states explicitly.
If the recipe is absent, each input unit pays `1000 * stored tier` gold:
1000, 2000, 3000 or 4000. Query errors preserve the input.

Confirmation rereads the input object, quantity and payout and refuses a changed
preview. Materials are staged outside inventories before consuming the input,
using the server's `baseitems.Stacking` limit to split quantities. A missing
material blueprint cleans up the staged payout and preserves the input. Before
paying, the input's tier is revoked synchronously and its destruction queued,
preventing a repeated action from paying twice. Material copies go to the
player; if a copy cannot fit, its staged object stays at the player's feet.
Conversation exit briefly suppresses leftover inventory-use events using the
existing extractor pattern, without changing that system.

## Placed resources

All five current placements are configured in `asy_necrotorre`,
`esmeltarandepend`, `kro_murann_ofici`, `ony_posadasulda` and `thecollege`.
Positions and appearance are retained. Extractor conversation/events are
cleared, and inventory/use flags are explicitly configured for recycling.
The blueprint appears next to the extractor in the custom oficio palette.
Unrelated owner changes to maps and palette stay outside this candidate commit.

## Acceptance

Craft weapons with variants, armour, jewellery, ingots, cut gems, consumables,
ammunition and a byproduct. Inspect recipe/tier locals, identified/stolen flags,
merged stacks and relog persistence. Recycle an input returning 3.5 units of a
component and confirm 3; test refunds below one and entirely zero. Test batch
outputs and input stacks, retained components, cancellation and confirmation
following an inventory or catalogue change. Delete a test recipe and verify all
four exact per-unit gold payouts. Exercise repeated confirmation, a missing
material blueprint and full inventory. Check every placed machine and a new
palette placement; extractor behavior must remain separate.

## Provenance

Policy was selected by the owner for newly crafted testing outputs. Source
review and resources are from this PROD checkout on 2026-09-18; all 181 generated
component tags resolve to an identically named tracked item blueprint. Native
contracts were checked through `nwn-official`, pinned build 8193.37 reference
SHA-256 `c14098d0181f921618622f379ff5cb682b8656d5293f218392531eef7a8478ad`:
`CopyItem` copies locals when requested and may return a merged inventory object;
`GiveGoldToCreature` grants the stated amount. Staging follows the existing
extractor's project-data use of `baseitems.Stacking`. SQL preparation clears
previous query state, per the `nwnx` MCP at upstream revision
`3d4c4e13c6bf01b032ffe90534fc4a19eb036c03`; recipe output quantity is captured
before preparing the component query. Compilation and static checks are not
in-game acceptance.
