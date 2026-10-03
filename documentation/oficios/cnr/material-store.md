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
units are restored only when the split remains on the ground, regardless of
MoveTo's return value. The split is made unusable immediately after creation,
before any transfer, and is destroyed before restoring those source units. An
unexpected count after delivery
quarantines the session without restoring already-delivered source units.
Unsupported objects and bags return intact, without copying or unpacking their
contents. Return success is checked against the actual possessor, not just the
MoveTo result. A foreign actor cannot receive pre-existing rejected objects.

## Session safety and failure handling

One character can have one session. Reusing a store reconciles and closes the
caller's previous session before creating a replacement. A visible chest is
reserved only after its inaccessible display has finished initialization; an
interrupted initialization cannot publish a permanent visible-store lock. The transient chest stores its owner and its exact visible
chest reference. Scripted inventory changes use a re-entry guard. Character
variable-container presence, unchanged cached balances, nonnegative counts,
integer limits and sufficient balances are checked before credit/debit.

An inconsistent count, changed balance, failed persistent write or failed
rollback stops replenishment, closes the relevant inventory windows and locks
the chest. `CNR_ALM_BLOCKED` is set on the session, character and variable item.
The last flag survives reconnection and prevents opening another store. The
quarantined chest is retained rather than destroyed, preserving objects for DM
inspection. When the owner quarantine is persisted, only the shared visible
store reservation is released so other characters can continue using their own
holdings. The owner remains blocked and the quarantined chest is retained.
Automatic cleanup does not release a quarantined session. A DM must
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

## Abandoned-session recovery (2026-10-03)

The original session guard tested only whether the old chest object existed.
A missed/cancelled close or a leftover busy flag could therefore leave a valid
chest reference rejecting every subsequent use, including after reconnection
through the visible chest reference. Object validity is not session liveness.

Fresh OnUsed and heartbeat events recover old sessions by reconciling and
closing them; they never create a second display before release. An interrupted
busy flag is cleared only when every physical snapshot is unchanged and any
available owner's cached balances match live state. A pending uncertain delta
is quarantined instead of being credited or debited a second time. Divergent
state remains quarantined. Closing is idempotent even if a previous cleanup
stopped after setting its closed flag. It explicitly closes the inventory GUI.

Active ownership additionally requires membership in the native player list,
the same area, distance at most five metres and a matching character-session
reference. Physical placeable open state is not used as proof that an inventory
GUI is active. A foreign character's close notification cannot close the owner's
session. The existing chest heartbeat performs abandonment cleanup; there is no
global heartbeat. Quarantine flags are never automatically removed by this recovery.

Native player-list, open-state and distance contracts come from the tracked
NWScript reference. The pinned NWNX Player header also documents that a
placeable-inventory close action can be cancelled while walking to the chest;
that is a documented lifecycle risk, not proof of the exact cause on the
reported server. The report establishes the stuck session message; an engine
instruction-limit abort has not been observed or asserted as its cause.

Verification for this lifecycle correction: 17 offline groups executed the
actual AlmClose, AlmSessionActive and AlmRecoverSession function bodies with
mocked native operations. They cover missed and repeated closure, nested GUI
closure, inactive but valid owner references, distance/area changes, a lost
character attachment, interrupted initialization and cleanup, matching versus
uncertain busy state, invalid counts and retained quarantine. Static checks
confirm locks are published after display validation and initialization starts
locked/unusable. Focused compilation of the include and its five executable
consumers passed: five successful, one skipped include, zero errors. The
documentation checker passed. These checks do not establish NWN runtime
callback order; the reported server case still requires an in-game retest.

## Additional failure-path review (2026-10-03)

Pinned `nwnxee/Plugins/Item/Item.cpp`, `MoveTo`, calls engine AcquireItem
without checking its result before returning success. Quantity rollback and
unsupported-item return therefore verify actual possession/counts; an optimistic
return is insufficient. The tracked native reference establishes that
SetUseableFlag prevents ground interaction without affecting inventory use.
Staged rollback objects are unusable from creation, including when delivery
fails or verification cannot establish a successful move. The GetIsOpen contract
only describes physical placeable/door state; it does not establish GUI ownership.

Additional offline checks execute the current include's actual function bodies
with mocked natives. They cover optimistic failed moves, partial and merged
rollback, unsupported-item preservation, foreign closure, quarantine isolation,
the 89-unit regression, duplicate events and recovery. Seventeen security groups,
6,000 randomized transfers and the 17 lifecycle groups passed. The focused check
compiled all five executable consumers with zero errors; the include was skipped.
The documentation checker passed. Compilation and runtime acceptance are separate: engine callback order, full inventories, reconnects and
window closure must still be tested on the server.
