# Material store quantity accounting

The PROD material store keeps the existing 282-material catalogue and material
keys on the character's `dmfi_pc_emote` variable item. The Arcane converter is
unchanged; see [material-store-migration.md](material-store-migration.md).

## Conservation rule

Chest materials are temporary representations of stored units, not additional
holdings. `cnr_i_store` compares actual chest quantities with the previous
per-material snapshot: a deposit increases the balance by its actual units;
a withdrawal decreases it by its actual units. It never uses the disturbed
item's surviving size to determine the transfer, because merging or splitting
can change that size. Duplicate notifications with no quantity difference do
nothing. Deposited objects remain as the display until closing.

A replacement display is created only when no units of that material remain,
and contains at most ten units and at most the remaining balance. Its actual
quantity becomes the next snapshot, including base-item stack clamping. The
saldo write is confirmed before replenishment. Closing accounts movements
without replenishing, then explicitly destroys the virtual display objects.
Opening initializes and validates the inaccessible display before publishing
its reservation.

Accepted withdrawals cost five gold per unit. Rejected movements first return
the actual quantity, including units merged into existing stacks or bags.
Partial returns remove source units before delivering a temporary split. If a
split stays on the ground, only the undelivered portion is restored; already
delivered units are never restored a second time. Temporary splits cannot be
picked up while staged on the ground.

When a rejected withdrawal cannot be physically returned, the code reclaims
only the owed quantity, leaving that quantity stored. A dropped event item is
considered before original carried materials. Whole-object deletion is marked
before scheduling `DestroyObject`, so another callback cannot reclaim the same
object again. If some transferred units cannot be reclaimed either, those
remaining units are debited before any replenishment or reopening. A partial
return never creates a full refund alongside units left outside the store.
This exceptional residual settlement preserves material quantities and does
not add a withdrawal fee to a rejected movement.

## Ownership and ordinary recovery

A visible store admits one active owner. A character's previous transient
session is reconciled and closed before a fresh display is created. Ownership
requires an online player in the same area, within five metres, with the
matching session reference. A foreign close event does not close the owner's
session. Fresh use and the existing chest heartbeat recover abandoned sessions;
there is no new global heartbeat.

`CNR_ALM_BLOCKED` and `CNR_ALM_BLOCKED_V2` are retired completely. Store use
deletes both keys from the character and its original variable item. Neither
key is read or written as access control. Players need no individual flag
reset after loading the updated module. This cleanup changes no material keys
or stored quantities, and does not modify offline character files.

Unsupported items, including bags, are returned intact after material deltas
are settled. A failed bag return cannot skip a material debit. The original
donor is remembered for a foreign rejected deposit; another player cannot
receive the owner's pre-existing rejected objects. Closing deletes only virtual
materials, never a rejected real bag or its contents. If a real object still
cannot leave the chest, the visible store reservation is released and the
original object is retained for another return attempt. Freeing inventory
space and using a store retries the return; the player is not blacklisted.
The character-session reference remains until that original object is returned.

A negative stored row is not displayed and is logged; other valid materials
remain available. No historical amount is reconstructed or reset.

## Interrupted operations

All active safety markers belong to the transient chest. `CNR_ALM_BUSY` prevents
nested mutation; `CNR_ALM_READY` separates initialization from player use;
`CNR_ALM_PAUSED` stops an unfinished operation. No pause flag is written to the
character or variable item.

Before a saldo write, the chest records the material index, old/new balance,
physical snapshot and withdrawal fee. Recovery accepts the recorded old or new
balance, completes the pending transition, and advances its snapshot only once.
The fee recovery recognizes the recorded wallet before or after payment rather
than charging twice. The exact original variable-item reference is retained so
a temporarily moved variable item does not redirect a write to another item.
An interrupted refill separately records its requested limit and captured
creation count; a later withdrawal is still measured against that captured
count rather than adopted as a new snapshot.

If the original variable item is unavailable, a pending write disagrees with
both recorded balances, wallet state cannot establish whether a fee was paid,
or a refill was interrupted before its creation count was captured, recovery
cannot safely guess. That transient operation remains paused and produces no
new display. Reopening retries it, but arbitrary corrupted or unobservable
state is not guaranteed to recover automatically. This is an explicit limit,
not a replacement persistent character ban. Runtime instruction-budget and
callback ordering still require server acceptance; local tests do not establish
crash-atomic persistence across a server restart.

## Provenance and verification

Native contracts are provided by the project's `nwn-official` MCP and tracked
`documentation/nwscript/reference/nwscript.nss`: `CreateItemOnObject` can return
a merged/overflow object, `SetItemStackSize` clamps to base-item limits, and
`GetItemPossessor` follows bag ownership. Quantity accounting does not assume
the disturbed item's post-merge size. Deferred destruction is documented in
[engine-behavior.md](../../nwscript/engine-behavior.md).

The project's `nwnx` MCP and pinned `nwnxee/Plugins/Item/Item.cpp`, `MoveTo`,
establish that the wrapper calls AcquireItem without checking its result
before returning success. Accounting therefore verifies actual counts rather
than trusting the wrapper's return value. The pinned Player implementation's
`OpenInventory` sends the GUI close without a target-type filter. Physical
placeable open state does not prove inventory GUI ownership.

Current focused compilation:

```bash
./linux_build.sh --check cnr_i_store.nss sapo_alma_abri.nss sapo_alma_abr2.nss sapo_alma_dist.nss sapo_alma_cerr.nss sapo_alma_beat.nss
python3 scripts/check_documentation.py
```

On 2026-10-03, compilation passed: five executable scripts, one skipped include,
zero errors. Twenty-eight offline test groups executed the actual include,
opening and close-handler bodies with mocked native operations. They include
the 89 stored plus one carried regression, partial/merged transfers, duplicate
events, physical return failures, partially delivered splits, nested bags,
dropped rejected items, retained bag contents, foreign access/closure, both
historical flag cleanups, stale busy state, interrupted saldo/fee/refill
recovery, negative rows, residual settlement, and 6,000 randomized movements.
Temporary test artifacts are outside the repository. These are deterministic
logic checks, not NWN engine or live-server tests.

Packaging, deployment, in-game acceptance and independent review remain pending.
After deployment, retest affected players, the 89-unit withdrawal, partial
movements, closing/reopening, moving away, reconnecting and shared-store access.


## Complete opening review (2026-10-03)

The later report describes 376 Zumos acuosos becoming visible on opening, with
no deposit or withdrawal. That observation does not establish the pre-opening
value of its current stored key. The current opening path runs the converter
before displaying quantities; OnOpen only checks ownership and sets GUI state.

An additional temporary check executes the actual PROD 282-row catalogue,
complete converter, accounting include and all five event-handler bodies with
mocked natives. The previous 28 accounting/lifecycle groups did not execute the
converter or full catalogue bodies; their test fixtures supplied substitutes.
The additional coupled check closes that coverage gap for source logic.

Twelve groups passed. Current-only zumo balances 1, 89, 120, 130, 157 and 376
survive forty opening/reopening rounds each, with repeated disturb callbacks
and no player transfer. A legacy-only 130 migrates to 130 and stays 130 even
when the conversion flag is removed between openings. A synthetic fixture with
157 current and 219 legacy units becomes 376 once, then stays 376; this is a
conservation test, not a claim about the reporting player's historical values.
A completed migration leaves a subsequently present old key untouched. One
merged deposited unit credits one unit. Withdrawing a stored 130 delivers
exactly 130 plus the original carried unit and leaves zero on reopening.
All 282 current material keys and case-normalized resrefs are unique; all 282
balances survive fifteen repeated openings with duplicate notifications.

The temporary executable was compiled and run as follows:

```bash
g++ -std=c++17 -O0 -isystem /usr/include/c++/12 -isystem /usr/include/x86_64-linux-gnu/c++/12 -L/usr/lib/gcc/x86_64-linux-gnu/12 /tmp/pdb-store-session-check/full_open_check.cpp -o /tmp/pdb-store-session-check/full_open_check
stdbuf -oL /tmp/pdb-store-session-check/full_open_check
```

The locally compiled five script consumers in both the Nasher cache and
unpacked working module contain the current transient-pause marker. The four
accounting consumers also contain the residual-return settlement marker and
none contains the retired quarantine diagnostic. This establishes local
compiled-resource currency, not what a remote server has loaded.

No source defect causing current-only 130 to become 376 during opening was
reproduced. These checks do not establish native callback timing or diagnose
the player's historical balance. No player amounts, migration policy or source
behavior were changed on the strength of that unconfirmed explanation.

## Superseded decisions

The initial quantity correction and subsequent lifecycle/failed-transfer fixes
are recorded in the October changelog. Earlier permanent quarantine on the
character and variable item, its V2 replacement, the cached-balance equality
refusal, and DM-only release are superseded by the current behavior above.
Earlier successful mock checks describe their historical implementation, not
proof of current NWN runtime behavior.
