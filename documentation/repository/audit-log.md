# Audit log

The register of every external audit run against this repository: what it
covered, what it found, and whether it closed.

**This file exists because the evidence does not survive.** `.audit/` artifacts
are deleted after 48 hours by `CleanExpiredArtifacts`, so a review's findings are
gone two days after it runs. What persists on its own is only a marker file per
audited commit under `.git/agent-audit-attempts/`, which records that an attempt
was started and nothing about what it concluded. Anything worth knowing has to be
copied here while the artifacts are still on disk.

## What one audit covers

**Exactly one commit, against its first parent.** The reviewer wrapper says so
verbatim: *"Review exactly local commit `$commit` against its first parent
(`$commit^`). This immutable commit diff is the only change boundary."*

Three consequences that are easy to get wrong, and were:

- An audit does **not** cover a slice. A change spread over four commits has
  three unreviewed commits and one reviewed one.
- The **remediation commit is never reviewed**. `finalize` checks it
  deterministically - that it is the candidate or one direct child, and that
  every finding carries a disposition - and no reviewer reads its diff.
- A commit with no marker was **not** audited, whatever its neighbours did.

## Nothing open

> **Superseded 2026-09-02.** `6d9521c00` is open: reviewed, both blockers
> fixed, and `finalize` refuses it because the owner committed between the
> candidate and the remediation. `71bae51f9` ran after it and closed cleanly.
> See below.

Every audit with artifacts on disk is closed. `a020e6636` was the last one
waiting: its first review died on the reviewer's own usage limit two minutes in,
and it was re-run after the quota reset on the owner's instruction. The recipe
for that situation is worth keeping, because a failed attempt is recorded as
consumed and re-running needs both markers cleared:

```bash
C=<full commit id>
rm -f ".audit/attempt-${C}.tsv"
rm -f "$(git rev-parse --git-common-dir)/agent-audit-attempts/${C}"
scripts/agent_audit.sh review $C
```

## One audit open

**`78724379` — arcane groups editable and audit search.** Prepared and sent on
2026-09-20; the reviewer answered with its own usage limit eight seconds in.
The workflow records that as the single attempt consumed, so the gate is
**incomplete, not passed**, and the commit carries no review.

Its quota resets 2026-09-23. Re-running needs the owner's instruction and both
markers cleared, per the recipe above:

```bash
C=7872437926f8a917c4b5d71df4a2483119647c69
rm -f ".audit/attempt-${C}.tsv"
rm -f "$(git rev-parse --git-common-dir)/agent-audit-attempts/${C}"
scripts/agent_audit.sh review $C
```

The handoff is written and on disk, so a re-run needs nothing rebuilt - but
`.audit/` artifacts are deleted after 48 hours, so after 2026-09-22 the handoff
has to be written again.

## Status of every audit on record

Nineteen audits have artifacts on disk today, all of them closed. The rest are
recorded from artifacts that have since expired, and twenty-two more markers
exist with nothing behind them at all; both groups are listed further down.

### Closed

**`b6ca0d9b` — trade progression, spellcaster Arcano, closed trades, boss
loot, one bulk commit.** Reviewed 2026-09-23 with `gpt-6-sol` at high
reasoning, verdict PASS, two advisories, both correct, both fixed in
`9ab52500`, closed. It carries everything left uncommitted on 2026-09-22 and
2026-09-23: the help formula, the 30% longer curve and its panel mirror, the XP
fall-off and top-tier rule, tier-4 DC relief, Arcano for spellcasters, closed
third trades, boss-chest loot marking, the extractor's identification check and
the Zalantar properties.

- **F-119.** `pb_tesoro_ccwea2.nss` tested `if (iTienda=TRUE)`, an assignment,
  just before the new marking branch, which therefore could never run. Dormant:
  nothing includes that library.
- **F-122.** The message after the roll blamed "far below your level" for any
  reduction, including the top-tier rule that halves a recipe one level below.

**`0ab80da1` — the same content, abandoned.** Its review ran on `gpt-5.6-sol`,
still configured in `.agents/config.json`, and was cancelled by the owner after
seventeen minutes to switch model. The attempt is consumed and it has no
verdict; its intermediate notes had found nothing. It was never pushed and was
recreated as `b6ca0d9b` on top of `1626f648`, which only changes the model. Both
trees differ only in that file.

**Still owed.** `40566c9a`, `7da40fca`, `fef4881b` and `300d85d3`, committed on
2026-09-22 while there was no reviewer quota, were never audited, and
`78724379` is still open as recorded above.

**`5e66c4f3` — the panel's Arcano tab.** Reviewed 2026-09-20, verdict BLOCKED,
two blockers and two advisories, all four correct, all four fixed in
`f20de159`, closed. The first audit of this repository where a finding was a
defect in the code rather than in the record.

- **F-001, the one that mattered.** `db-reset-players.sh` classifies every table
  of the database as wiped or kept and exits on one it does not recognise,
  before taking its backup. The new `cnr_arcane_revision` was in neither list,
  so the moment migration `0023` shipped, **every player reset would have
  refused to run**. The reviewer found it by reading a shell script two
  directories away from anything the commit touched.
- **F-002.** Arcane edits were written to their revision table and nothing could
  read them: the administrator audit workspace queries four revision models and
  this was a fifth. Recorded and invisible is not audited.
- **F-003.** The section filter is built from the distinct sections, the section
  is editable, and the save invalidated only the list.
- **F-004.** The accepted XP ceiling was `16777215`, copied from the recipe
  editor whose column is an `INT`. `cnr_arcane_step.xp` is a signed `MEDIUMINT`
  and stops at `8388607`.

**Worth keeping: a new table is a change to every script that enumerates
tables.** F-001 is the second time a reviewer has caught an integration this
repository states as an exhaustive contract and an implementer treated as a
local addition. Before adding a table, grep for the ones already there.

**`68b338c5` — the documentation checker, never audited.** It brought
`scripts/check_documentation.py` over from development and closed the gap that
blocked `8f344b46`. It has no marker and no review: by the time its turn came
it already had a child, and a candidate must be `HEAD` with no children when
its review starts, because the one child `finalize` accepts is reserved for the
remediation. Two commits were made before either was audited. Its id is
recorded in its changelog entry from the remediation commit of the audit that
followed it, which is the only place left that could carry it.

**`8f344b46` — diamond dust into the material store.** Reviewed 2026-09-20,
verdict BLOCKED, one blocker, correct, fixed, closed at `3dfc9278`. The
implementation and its structural invariants passed; the blocker was against the
handoff.

- **F-001.** The handoff said "the DEV `scripts/check_documentation.py`, rebound
  to this repository root, passes". `AGENTS.md` says, verbatim, that the script
  **does not exist in this repository yet** and that until it does the handoff
  must say the structural documentation check *could not be run*, rather than
  claiming it passed. The candidate changes a file under `documentation/`, so the
  rule applied. Corrected: the handoff now states the check could not be run,
  lists it under checks not performed, and mentions the DEV run only as an aside
  that is explicitly not offered as satisfying the gate.

**The same false claim is in the handoff of `dd84269d`, which closed earlier the
same day and cannot be reopened.** Both were written before anyone read that
paragraph of `AGENTS.md`. Borrowing a checker from the other checkout is useful
for catching real problems and it is not the gate; when a tracked check does not
exist, the handoff says so.

**Three audits in one day, three blockers, none of them in the code.** `dd84269d`
was blocked on an acceptance test that could fail against correct code and on a
compilation-coverage claim that was not true; this one on a validation claim the
contract forbids. The reviewer is reading the record at least as closely as the
diff, which is what the contract asks it to do, and the cheap defence is to
write only what a command printed and to check `AGENTS.md` for what the project
says about a check before claiming it.

**`dd84269d` — Artesania on the craft roll, and the store's names.** Reviewed
2026-09-20, verdict BLOCKED, two blockers, both correct, both fixed in
`11ed036c`, closed. Neither touched the implementation: both were about the
accuracy of the validation record, which is exactly what the contract means by
"a false verification claim is itself a blocker".

- **F-001.** The changelog's acceptance test said to add five ranks of Artesania
  and watch the help bonus rise. It need not rise. `nCraftBonus = ranks / 5` is
  then averaged with the ability modifier and floored, so five ranks move the
  inner figure by one and the outer halving can absorb it: at ability average 0,
  both 0 and 5 ranks display 0. A test that fails against a correct
  implementation cannot validate it. Replaced with 0 versus 10 ranks on two
  otherwise identical crafters.
- **F-002.** The entry claimed compilation of "the changed include and its direct
  consumers: 6 executables", and the handoff called them *every* direct
  executable consumer. The two changed includes have twenty between them; the
  run had covered five plus one indirect. The project rule - one representative
  direct consumer plus every executable changed in the slice - was satisfied, but
  the claim of completeness was not true. Re-run over the full set: 21
  executables, 4 includes skipped, 0 errors.

**The lesson worth keeping: do not write "every" into a handoff without
enumerating.** Both findings came from the record, not the code, and the reviewer
found them by counting what the sentence claimed. The cheap defence is to derive
the consumer list mechanically and paste the number the command actually printed.

**`72c8b96e9` — the NPC caster level marker.** Reviewed 2026-09-02 at the owner's
request, verdict BLOCKED, two blockers, both correct, both fixed, closed.

- **F-001.** `zep_cw_leveldown.nss` was never wired. The level-up path called
  `pbCLApplyModifiers` and the level-down path beside it in the same DM dialog did
  not, so a DM removing prestige levels from an NPC left the old modifier
  installed and `pbCLEnsureModifiers` skipped recomputation on the surviving mark.
  **This is the same omission as F-002 of the first S2 audit**, where the player
  hooks covered client enter and level up and not `event_leveldown`. Twice: the up
  path wired, the down path forgotten.
- **F-002.** The changelog entry's `Commits.` line named only `71bae51f9`, omitting
  `2089dc70d` which introduced the NPC behaviour it now describes, and carried no
  `<pending>` for the candidate.


**`71bae51f9` — one caster level instead of two.** Reviewed 2026-09-02, verdict
BLOCKED, four blockers, all correct, all fixed in `2089dc70d`, closed.

- **F-001, the one that mattered.** `pbCLApplyModifiers` runs only from the
  client-enter, level-up and level-down hooks, so no NPC ever had a caster level
  modifier installed and the new engine-first route answered them with their base
  class level. `pb_imnrayrayhiel.utc.json`, a Wizard 10 / Pale Master 11 with
  Haste memorised, fell from caster level 20 to 10. Fixed by installing the
  modifiers lazily on first ask, which also corrects the engine's own number for
  that NPC.
- **F-002.** `documentation/rules/caster-level.md`, the canonical current-state
  document, still described the two-implementation architecture the commit had
  just removed. Only the proposal and the changelog had been updated.
- **F-003.** `scripts/check_documentation.py` is mandatory whenever tracked
  documentation changes and the handoff had not recorded it.
- **F-004.** The call-shape inventory claimed 377 sites, summed to 373, and
  miscounted `OBJECT_SELF`. The real figure is 375 invocations across 328 files.

Two lessons worth keeping. **A slice that changes behaviour updates the canonical
current-state document in the same commit**, not only the proposal it came from -
F-002 happened because that document was created the same day and the author did
not know it existed. And **an inventory offered as validation is evidence and has
to be generated, not typed**: F-004 was a loose grep that counted the prototype
and the definition as call sites.


Findings dispositioned and `finalize` accepted. All dispositions are FIXED.

A closed audit's findings are not transcribed here one by one. What each one
found is what the change ended up doing, and that is written for the reader who
will notice it in `documentation/changelog/`; the resolution file carries the
rationale and the verification while it lasts. Only findings that were never
dispositioned are copied out below, because for those there is nowhere else.

| Commit | Date | Verdict | Findings |
|--------|------|---------|----------|
| `1e2b89b13` | 2026-08-25 | PASS | 0 |
| `17d01b9bd` | 2026-08-25 | PASS | 2 |
| `04a7c3ca7` | 2026-08-25 | BLOCKED | 1 |
| `3ea122f27` | 2026-08-26 | PASS | 0 |
| `3f62f39b3` | 2026-08-26 | BLOCKED | 1 |
| `8c1016bf9` | 2026-08-26 | BLOCKED | 2 |
| `2b8c2b5c3` | 2026-08-26 | BLOCKED | 4 |
| `77e84b9ea` | 2026-08-26 | BLOCKED | 5 |
| `7b7e02cb4` | 2026-08-26 | BLOCKED | 5 |
| `7131fd45d` | 2026-08-27 | BLOCKED | 4 |
| `b02809957` | 2026-08-27 | BLOCKED | 4 |
| `395a55f3a` | 2026-08-27 | BLOCKED | 4 |
| `1dc991700` | 2026-08-27 | BLOCKED | 1 |
| `ba6016764` | 2026-08-30 | PASS | 0 |
| `5d3d50706` | 2026-08-30 | BLOCKED | 1 |
| `9ffcfa26d` | 2026-08-30 | BLOCKED | 1 |
| `a65b8a2a6` | 2026-08-30 | BLOCKED | 1 |
| `f1453ba6b` | 2026-08-30 | BLOCKED | 1 |
| `795085337` | 2026-08-30 | BLOCKED | 2 |
| `7ebc0f831` | 2026-08-30 | BLOCKED | 2 |
| `ebcbf9d16` | 2026-08-30 | BLOCKED | 2 |
| `06d5a7721` | 2026-08-30 | BLOCKED | 3 |
| `a020e6636` | 2026-08-30 | BLOCKED | 3 |
| `b48d31c39` | 2026-08-30 | BLOCKED | 3 |
| `fe16d36fe` | 2026-08-30 | BLOCKED | 3 |
| `1087cf42e` | 2026-08-30 | BLOCKED | 4 |
| `4c955221a` | 2026-08-30 | BLOCKED | 4 |
| `4d3cf8210` | 2026-08-30 | BLOCKED | 4 |
| `7ca6296bc` | 2026-08-30 | BLOCKED | 4 |
| `c9f4d0964` | 2026-08-31 | BLOCKED | 1 |
| `87ac26c1a` | 2026-08-31 | BLOCKED | 2 |
| `842c9d643` | 2026-08-31 | BLOCKED | 3 |
| `1bc473c54` | 2026-08-31 | BLOCKED | 2 |

### Reviewed, findings fixed, never closed

**`2089dc70d` — the remediation for the first S3 audit, reviewed on the owner's
request.** Verdict BLOCKED, two blockers, both correct, both fixed in
`72c8b96e9`.

- **F-001.** `pbCLEnsureModifiers` marked a creature with `SetLocalInt` while
  installing its caster level modifiers with `bPersist = FALSE`. Those are
  different lifetimes. `chat_consoladm.nss:424` serialises a creature and
  `pb_mod_activate.nss:2224` restores it; serialisation carries object locals but
  not non-persistent NWNX variables, so a restored NPC came back **marked as done
  with nothing installed** and cast at its base class level permanently.
  `zep_cw_levelup.nss` was the second path: levelling an NPC at runtime left the
  mark set and the delta stale. The mark is now an NWNX variable with the same
  persistence flag, and the creature wizard re-applies.
- **F-002.** The NPC behaviour change carried no changelog entry; the candidate
  changed only the `Commits.` line.

**Why it did not close, and it is the same shape as `6d9521c00` from the other
direction.** HEAD was already one child past the candidate when `review` was
started, so the remediation lands two commits past it.

**The rule this produces: a candidate must be HEAD when its review starts.** Rule
8 said the branch has to stay still *between* review and remediation; that was
half of it. `6d9521c00` failed because someone else committed during the window.
This one failed because the window had already been spent before the review
began, by the author's own documentation commit.


**`6d9521c00` — prestige classes count towards the engine's caster level.**
Reviewed 2026-09-02, verdict BLOCKED, two blockers, both correct and both fixed
in `fb263a4c4`.

- **F-001.** The handoff and the changelog classified 198 `spells.2da` rows as
  base-game scripts when 198 was only the count of `ImpactScript` resrefs with no
  file under `src/`. 177 of them name `spell_crs`, which exists nowhere in the
  repository. The reviewer also found that 18 impact scripts that *do* live in
  `src/` call `GetCasterLevel()` directly, so the declared invariant that
  module-scripted spells do not move was false as written.
- **F-002.** The caster level modifier was recomputed on client enter and on
  level up but not on level down, while `wrap_on_mod_load.nss:97` already
  subscribes `NWNX_ON_LEVEL_DOWN_AFTER` to `event_leveldown`. A prestige caster
  who lost a level kept the higher caster level until his next login.

**Why it did not close, and it is a new reason.** The owner committed their own
unrelated work, `df31ee9f0`, between the candidate and the remediation. The chain
is `6d9521c00` -> `df31ee9f0` (owner) -> `fb263a4c4` (remediation), so the final
state is two commits past the candidate and `finalize` refuses it: *"final state
must be the candidate or one direct remediation commit"*.

Every previous instance of this was an agent stacking its own commits. This one
is not, and **no history was rewritten to force closure**, because the
intervening commit belongs to the owner. The resolution and final-verification
artifacts are complete on disk under `.audit/`; they will be deleted after 48
hours, which is why the findings are transcribed above.


The work was done and written into the resolution; `finalize` refused because the
final state had moved more than one commit past the candidate. They cannot be
closed now - the boundary check is against current history - and they are as
addressed as a closed audit.

| Commit | Date | Verdict | Findings | Dispositions |
|--------|------|---------|----------|--------------|
| `381932565` | 2026-08-26 | BLOCKED | 3 | 3 FIXED |
| `eea15842c` | 2026-08-27 | BLOCKED | 3 | 3 FIXED |
| `928c9e6a5` | 2026-08-31 | BLOCKED | 2 | 1 FIXED, 1 DEFERRED |
| `c4803bc40` | 2026-08-31 | BLOCKED | 2 | 2 FIXED |
| `9b3128194` | 2026-08-31 | BLOCKED | 3 | 3 FIXED, **and the commit is not on the branch** |

The three of 2026-08-31 failed the boundary check for the same reason: four
commits had been stacked on the first before any of them was audited, so no
remediation could be a direct child. `9b3128194` failed worse - see below.

**How the third was recovered.** The nine unaudited commits that followed
`c4803bc40` - the invocation-slot work, a feat-and-effects detour that was
reverted, two deletions and their documentation - were squashed into one
candidate, `1bc473c54`, and that was audited and closed normally. Its tree was
identical to the tree of the last of the nine apart from two commit-hash
references that the squash invalidated. The two audits that already pointed at
real commits, `928c9e6a5` and `c4803bc40`, were left alone; rewriting them would
have orphaned their reviews, which is the failure this section exists to record.

This is the remedy when work has already outrun its audits: rewrite only what is
unaudited and unpushed, review the net change once. It is not a licence to keep
stacking - the squash cost a full review cycle and two blockers that a
commit-by-commit rhythm would have surfaced one at a time.

### Reviewed, findings never dispositioned

Seven audits whose resolution file was never filled in. Their twenty-five
findings are transcribed below with what became of each, because the reviews
themselves expire.

| Commit | Date | Findings | Where they stand |
|--------|------|----------|------------------|
| `c786b443d` | 2026-08-25 | 3 | superseded |
| `fb4be8d55` | 2026-08-26 | 2 | addressed later |
| `2f434df41` | 2026-08-26 | 6 | mixed - one still open |
| `7871e3146` | 2026-08-26 | 5 | moot, work reverted |
| `2e42d8424` | 2026-08-26 | 3 | moot, work reverted |
| `608d041e7` | 2026-08-26 | 2 | superseded |
| `20062dce2` | 2026-08-26 | 4 | addressed or dismissed |

## The twenty-five undispositioned findings

Severity is the reviewer's. The verdict on each is this repository's, recorded
here rather than in a resolution file that no longer accepts one.

### `c786b443d` — self-review of the plan against the repository standards

- **F-001 BLOCKER** *Handoff requests a different review boundary.* The handoff
  described work outside the candidate. **Superseded**: the handoff format and the
  boundary rule are now understood and applied; this is the mistake this document
  exists to stop repeating.
- **F-002 BLOCKER** *Documentation fix leaves the required prototype
  undocumented*, at `inc_spells.nss:606`. **Moot**: `inc_spells.nss` was split
  three ways on 2026-08-26 and has no line 606. Every prototype in the three
  resulting includes carries its documentation block.
- **F-003 BLOCKER** *Mechanical validation claim uses a false changed-file
  count.* **Accepted, not re-run.** The claim was wrong when made. The files it
  concerned have since been rewritten or split.

### `fb4be8d55` — twelve identities agree in both directions

- **F-001 BLOCKER** *The dual-key implementation contradicts the canonical
  identity contract*, at `nw_s0_endele.nss:97`. **Addressed** by `4acc4f04f`,
  which rewrote the contract to say an identity has one key per kind of source.
- **F-002 BLOCKER** *The modified shared include lacks the modification marker*,
  at `inc_effect_ids.nss:4`. **Fixed**: the file carries its authorship line
  today, verified 2026-08-27.

### `2f434df41` — what COW, the natives and NWNX offer for saving throws

- **F-001 BLOCKER** *The remediation count omits one invalid `oSaveVersus`
  call.* **FIXED 2026-08-28.** The original review did
  not identify a sixteenth site: it caught prose that said four while its table
  already enumerated five. Recounted 2026-08-28, the five current calls are
  `nw_s0_weba` at 76 and 89, `nw_s0_webc` at 73 and 85, and
  `nw_s0_greasec` at 41. All now use `gsSPSavingThrow`, whose signature
  requires the area creator and spell id. Migrating the current wrapper
  consumers also found and fixed two more direct area-object calls in
  `nw_s0_cloudkilla` and `cls_ing_bomba`; they were outside the five-call
  inventory reviewed by this finding.
- **F-002 BLOCKER** *DC reduction presented as the only mechanism, without
  comparing a defender-side bonus.* **Vindicated and acted on.** The defender-side
  bonus is what `gsSPSavingThrow` does, on the owner's instruction of
  2026-08-27: the bonus is applied to the defender's roll, not subtracted from the
  DC.
- **F-003 BLOCKER** *The COW conclusion conflates PDB's DC hooks with the engine
  Spellcraft issue.* **Accepted and corrected** in the merged document.
- **F-004 ADVISORY** *`MySavingThrow` call-site count includes declarations.*
  Accepted; the counts were corrected repeatedly afterwards.
- **F-005 ADVISORY** *The COW evidence is not reproducible from the reviewed
  commit.* **Standing limitation.** `cow-scripts/` sits at the repository root,
  is ignored by Git, and is the owner's working copy. Every COW citation in this
  repository is dated and unverifiable from a checkout, by construction.
- **F-006 ADVISORY** *The divisor overlooks the authoritative ruleset row.*
  **Fixed**: `gsSPGetSpellcraftSaveBonus` reads `ruleset.2da` row 197 rather than
  hardcoding five.

### `7871e3146` — one wall-participation counter

Five findings, three BLOCKER. **All moot**: the wall of fire work was reverted in
full by `20062dce2` on the owner's instruction. F-002 (missing markers on six
files) and F-003 (changelog without a commit id) are the two failure modes that
kept recurring afterwards and are now habitual checks.

### `2e42d8424` — the warlock's wall of fire burns from a heartbeat too

Three BLOCKER findings about overlapping walls stacking damage and spell
resistance being rerolled every round. **Moot by the same revert**, and correct:
these are precisely the regressions the owner reported in play, in the words
*"NO VOY A PROBAR NADA, DEJALO COMO ESTABA TAL CUAL ESTABA"*. The reviewer found
them before the owner did.

### `608d041e7` — what to do with the wall-of-fire leftovers

- **F-001 BLOCKER** *The two alleged arithmetic variants are identical.*
  Accepted.
- **F-002 BLOCKER** *An explicit empty argument cannot override the 2da
  differently from an omitted default.* **Correct, and already retracted** in
  `c6e0b607a`. `EffectAreaOfEffect(id)` and `EffectAreaOfEffect(id,"","","")`
  compile to identical bytecode - NWScript fills defaults at the call site. This
  was the F20 claim and it was fabricated.

### `20062dce2` — revert the wall of fire work in full

- **F-001 BLOCKER** *Rewrites unrelated `baseitems.2da` line endings.*
  **Addressed** by `2266a6dfe`, which restored the owner's file. The line-ending
  question itself is settled as irrelevant by the owner.
- **F-002 BLOCKER** *Focused compilation omitted a changed executable script.*
  Accepted. The rule is now applied per changed file.
- **F-003 ADVISORY** *Helper removal left whitespace from the reverted work.*
  Accepted; the revert was not byte-exact.
- **F-004 ADVISORY** *The authorship-marker inventory is arithmetically
  incorrect.* Accepted. Counting errors were the recurring defect of that day.

## Markers without artifacts

Twenty-two commits carry an audit marker whose artifacts have expired. What they
found cannot be recovered.

`2026-08-23`, CNR work: `0bf3afbd5`, `00add7ac0`, `0731396ae`, `12d98dd0f`,
`33ea3aef1`, `438928f1c`, `5383a8bed`, `5ef745e23`, `6a2279558`, `6b7080871`,
`8ff5cd68b`, `a68f67b0f`, `d85863595`, `e8be040df`.

`2026-08-25`: `443a9a324`, `4350a9010`, `66ee65359`, `a55a0a23e`, `b3d9b7946`,
`dfdfe3c76`, `ec908f55c`, `8d03b405c`.

## What still owes an audit

A code commit with no marker was never reviewed. As of 2026-08-27 the unaudited
code commits are the remediations of the audits above - which the process never
reviews - plus the commits of multi-commit slices whose tip alone was audited.
`scripts/audit_status.sh` prints the current list; it is not reproduced here
because it changes with every commit.

## Rules this log exists to enforce

0. **Count after the last file goes in, never before.** Every count in a handoff
   is a claim the reviewer will check, and the arithmetic is where this
   repository fails most often. The artificer batch was counted at five files and
   reported at seven without recounting, and was blocked for it. Take every
   number from the committed diff, not from the working notes that preceded it:
   `git show <candidate> -- 'src/**/*.nss' | grep '^-' | grep -c '<symbol>('`.

1. **Copy a review into this file before it expires.** Forty-eight hours.
2. **Fill the resolution before moving on.** Seven audits here have findings that
   were read once and never dispositioned, and the only reason they are not lost
   is that this file was written on the last day they existed.
3. **Do not amend after `finalize`.** The closure record names a commit hash; an
   amend leaves it pointing at a commit that no longer exists.
4. **The `<pending>` convention is declared in `.agents/prompts/audit.md`**, which
   is sent to the reviewer on every audit. It was a handoff sentence first, and
   that failed the way anything depending on an author remembering fails: two
   audits that carried the sentence were not blocked on the placeholder and the
   one that omitted it was. A convention the reviewer cannot infer belongs in the
   prompt it always receives, not in a document written fresh each time.
5. **Take the hash after the amend, not before.** `9b3128194` was audited and does
   not exist on the branch: the commit was amended to add its documentation and
   the hash had been read from the pre-amend output. The reviewer duly reported
   the documentation as missing, because from the hash it was given it was. Three sound findings came out of it and two of
   them were real defects, so nothing was wasted - but the gate covered a commit
   that no longer exists. `git rev-parse HEAD` after every amend, before the hash
   is written into a handoff, a changelog or a resolution.

6. **Audit each code commit before making the next one.** Three audits on
   2026-08-31 could not close because four commits sat between the candidate and
   the fix. This is rule 7 seen from the other end: the boundary is not a
   formality to satisfy afterwards, it is a constraint on the order of work. A
   code commit that is not going to be audited immediately should not be made.

9. **A candidate must be HEAD when its review starts, with no children at all.**
   `2089dc70d` was reviewed while `7a40b6a9c` already sat on top of it, so its
   remediation could only ever land two commits past the candidate and
   `finalize` was unreachable from the moment the review began. The rule was then
   misread as "at most one child" and `72c8b96e9` was reviewed with `e9eab5c94`
   on top of it, which consumed the single direct-child slot **before the
   remediation existed**; that one was recovered only by folding the intervening
   commit into the remediation with `git reset --soft`, which is available only
   because it was the author's own unpushed commit. The one child `finalize`
   accepts is **reserved for the remediation**. Check `git rev-parse HEAD` against
   the candidate before calling `review`, and if they differ, do not call it.

8. **An audit is only closable while nobody else commits.** `6d9521c00` was
   reviewed and both blockers were fixed, and it still cannot close because the
   owner committed their own work between the candidate and the remediation. The
   window between `review` and the remediation commit is a window in which the
   branch has to stay still, and an agent does not control that. Say so before
   starting a review when the owner is working in parallel, and take the
   remediation commit as soon as the findings are understood.

7. **The candidate's own id goes in the single direct remediation child.** A
   commit cannot name itself. If no other remediation is required, that direct
   child may contain only the update from `<pending>` to the candidate id. Do
   not amend the reviewed candidate or add a second commit after remediation:
   `finalize` accepts only the candidate or one direct child. Nine audits ended
   up unclosed after their final state moved more than one commit past the
   candidate.
