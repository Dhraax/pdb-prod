# Material store quantity accounting

The PROD material store keeps the existing 282-material catalogue and persistent
keys on the character's `dmfi_pc_emote` variable item. The Arcane converter is
unchanged; see [material-store-migration.md](material-store-migration.md).

## Conservation rule

The displayed chest contains temporary representations of stored units. They
are not additional holdings. After every transfer, `cnr_i_store` compares actual
chest units with the previous per-material snapshot. A positive difference is
credited; a negative difference is debited. The event item's current size is
never used: merging, splitting and invalidated item objects cannot establish the
quantity moved. Deposits stay in the chest as the display until closing rather
than destroying a potentially merged stack.

The persistent write is read back before creating another display. A new stack
is shown only when no units of that material remain in the chest, bounded by
ten and the remaining balance. Actual creation counts are verified; an engine
stack limit of one is accounted as one. Repeated notifications without a
physical difference do nothing. Closing reconciles pending movements without
refilling, then explicitly destroys all remaining display objects before
destroying the chest. Opening validates all rows in one inventory pass.

Withdrawal fees remain five gold per unit actually moved. Insufficient gold
returns exactly those units, including units merged into existing stacks or
bags. Whole objects are moved with `NWNX_Item_MoveTo`; partial returns split only
the required units and reduce the source before delivering that split. Source
units are restored only when a failed move leaves the split on the ground,
where it is made unusable and destroyed. An unexpected count after delivery
quarantines the session without restoring already-delivered source units.
Unsupported objects and bags return intact, without copying or unpacking their
contents.

## Session safety and failure handling

One character can have one session, and each visible chest is reserved before
the inventory opens. The transient chest stores its owner and its exact visible
chest reference. Scripted inventory changes use a re-entry guard. Character
variable-container presence, unchanged cached balances, nonnegative counts,
integer limits and sufficient balances are checked before credit/debit.

An inconsistent count, changed balance, failed persistent write or failed
rollback stops replenishment, closes the relevant inventory windows and locks
the chest. `CNR_ALM_BLOCKED` is set on the session, character and variable item.
The last flag survives reconnection and prevents opening another store. The
quarantined chest is retained rather than destroyed, preserving objects for DM
inspection. Automatic cleanup does not release a quarantined session. A DM must
reconcile physical objects, persisted balances and session snapshots before
clearing the flag and disposing of the quarantined display; blindly clearing it
is not recovery. No historical material quantities are repaired by this change.

## Provenance and verification

Native contracts were read from the tracked
`documentation/nwscript/reference/nwscript.nss`: `CreateItemOnObject` can return
a merged or overflow stack, `SetItemStackSize` clamps to base-item limits, and
`GetItemPossessor` can follow a bag to its owner. These contracts do not specify
the post-merge disturbed-item size; quantity accounting therefore does not
require an assumed event order or a valid disturbed-item object.

The pinned NWNX Item header and `Plugins/Item/Item.cpp` establish `MoveTo`
semantics and inventory-capacity failures. The Player header describes
`NWNX_Player_OpenInventory`; `Plugins/Player/Player.cpp`, `OpenInventory`, sends
the inventory GUI close and clears its open state without a target-type filter.
Placeable window closure remains part of runtime acceptance. The API MCPs were
unavailable in this session, so these tracked primary sources were used.

Focused compilation command: `./linux_build.sh --check cnr_i_store.nss
sapo_alma_abri.nss sapo_alma_abr2.nss sapo_alma_dist.nss sapo_alma_cerr.nss
sapo_alma_beat.nss`. The include is skipped and its five executable consumers
must compile. Offline checks compile the unchanged accounting/opening function
bodies with mocked native operations: 22 groups and 6,000 randomized movements
passed, including 89 stored units plus one carried, all partial quantities,
merged deposits, fee rollback in bags, duplicate events, failed writes,
concurrent sessions, overflow and a full 282-material opening. This is not an
NWN runtime test. Temporary check artifacts live outside the repository.

Packaging, deployment, in-game acceptance and independent review remain pending.

A subsequent logic review reinforced the partial rollback failure path and
explicit display cleanup. Additional offline checks cover a destination-count
failure after successful split delivery and display cleanup when destroying a
container does not automatically destroy its contents. Both checks passed;
runtime acceptance is still pending.
