# Spells, effects and their saving throws

Eight proposals that were separate documents until 2026-08-26 and were always one
subject. They share a cause, they share the scripts they touch, and each was
being read without the others.

**Nothing here is implemented** except where a section says so. Each keeps its own
status line.

## What is in here

| | Section | Status |
|--:|---|---|
| 1 | [Saving throws](#1-saving-throws) | In progress. Both saving-throw groups and the central roll core are implemented; public caller migration and Shadow Defence's darkness half remain pending. |
| 2 | [Potion effect stacking](#2-potion-effect-stacking) | Mostly closed. Thirteen identities fixed in both directions; in-game validation owed. |
| 3 | [Negative Energy Burst, and nostack_inc](#3-negative-energy-burst-and-nostack_inc) | Save-feedback delay fixed; undead Strength stacking, duration and the NWNX NoStack decision remain pending. |
| 4 | [Mind Fog: the repeated save](#4-mind-fog-the-repeated-save) | Diagnosed, not taken. An SRD deviation the module makes deliberately or by accident. |
| 5 | [Warlock errata](#5-warlock-errata) | Closed. Fourteen items on 2026-08-31; item 13 turned out to have been fixed on 2026-08-26 and item 4 is parked as future work on the shared dispel routine. |
| 6 | [Artificer infusion errata](#6-artificer-infusion-errata) | Worked through on 2026-09-01. Nine repairs shipped, the rest closed with no code change or parked; nothing waits on a decision. |
| 7 | [Archmage Arcane Fire](#7-archmage-arcane-fire) | Pending review. Nothing implemented. |
| 8 | [Archmage Spell-Like Ability: forbid Time Stop](#8-archmage-spell-like-ability-forbid-time-stop) | Deferred until the current plan is complete. Nothing implemented. |

## Why they were merged

They are not eight problems. They are one problem seen from eight doors:

- **A rule written in one place and not another.** The saving throw subtype, the
  school variable, the stacking guards, the removal lists. Every section below
  contains at least one list somebody has to remember to update, and every one of
  those lists has drifted.
- **A decision taken where the context is not.** A saving throw made outside an
  `ImpactScript`, a school read off an area object, an effect applied with no
  spell row because the engine records `-1` outside a spell script.
- **The same scripts.** `nw_i0_spells`, `x0_i0_spells`, `nostack_inc`,
  `pb_nivellanzador`, `war_utilities` and the `add_spell_*` hooks appear across
  sections 1, 2, 3, 5 and 6 - not all of them in each, and no single one in all
  five. The heaviest overlap is between **section 1 and sections 5 and 6**:
  saving throws, warlock and artificer share `war_utilities` and `x0_i0_spells`,
  so a change to either has to be read against all three. **Sections 7 and 8,
  the archmage work, share neither**; they are here because they are spell
  proposals, not because they are coupled to those systems.

## What was left out

`loot-weapon-distribution.md` stays separate. The completed
[CNR review](../oficios/cnr/history/cnr-review-2026-08-20.md) is retained under
the owning module's history; neither subject touches a spell.

## The plan, by section

Ordered so that each step's effect is attributable, and so that nothing is moved
before it is understood.

### Completed 2026-08-27 — section 1, the half that needed no measurement

The initial inventory held **27 calls across 19 scripts**, counted per call site
rather than per file. One root-bomb call turned out to be an acid save whose
numeric constant had the same value as the unrelated immunity constant written
there. It was renamed, not reclassified. The other 26 calls now pass
`SAVING_THROW_TYPE_SPELL`; they had no subtype to lose and gain the spell
modifiers.

| Script | Calls |
|---|--:|
| `war_utilities` | 4 |
| `nw_s0_weba`, `nw_s0_webc`, `cls_ing_bomb2a`, `cls_ing_bomba`, `cls_ing_humia` | 2 each |
| `nw_s0_greasec`, `nw_s0_evardsa`, `nw_s0_evardsc`, `nw_s0_bladebara`, `nw_s0_bladebarc`, `nw_s0_entanglec`, `nw_s0_cloudkilla`, `war_cono`, `war_invisiblem`, `war_maldicion`, `war_polymorph`, `war_rafaga`, `war_tentaculosa` | 1 each |

`war_utilities` is the highest-leverage single file: four calls in the shared
helper the invocations go through.

**`nw_s0_cloudkilla` belongs here for one of its two saves.** Line 82 passes
`SAVING_THROW_TYPE_NONE` while line 68 passes `DEATH`, so it is in both groups -
which is why this has to be counted per call and not per script.

**`war_dominar` is not here.** It passes `MIND_SPELLS`, which is awaiting the
measurement below, and putting it in group 2 would decide that question by
accident.

It shipped alone in `eea15842c`; `32d018e5c` corrected the root-bomb name after
the candidate audit.

### Decided and implemented 2026-08-27 — the Spellcraft input

The owner chose invested Spellcraft ranks, not the modified total. The runtime
comparison against the engine's own `SAVING_THROW_TYPE_SPELL` calculation is
still owed as validation; it no longer blocks the stated project rule.

### Completed 2026-08-27 — section 1, group 1, and the library function

Twelve calls keep their subtype and receive the defender's Spellcraft bonus
through `gsSPSavingThrow` in `inc_spells`. The bonus is applied to the defender
for the duration of the roll instead of reducing the DC. This shipped in
`b02809957`.

### Completed 2026-08-28 — retire the school hooks and wire area saves

`add_spell_penetr` has moved into `inc_spellschool.nss`, and the dead
`add_spell_dispel` path has been removed while the live Tenacious Magic rule was
repaired in `cerr_newdispel.nss`. The same include now owns the equivalent DC
and Mastery of Elements functions. `pb_nivellanzador.nss` keeps both public
wrappers while `add_spell_dc` and `set_damage_type` are removed.

The next slice made `gsSPSavingThrow` require the caster and spell id, assemble
the Shadow Weave DC adjustment centrally and supply the resolved school to the
legacy `MySavingThrow` Shadow Defence block for the duration of the roll.
Nineteen calls in fourteen area scripts use it. Pernicious Magic and the live
Tenacious Magic path are repaired; Shadow Defence's darkness half is still
unimplemented.

### Completed 2026-08-28 — retire the school local everywhere

The area migration first removed the hand-written school local only from
scripts whose saves carried explicit context. Commits `ca9592f57` and
`0871f9f20` then removed the repository-wide protocol mechanically.

- No NWScript file retains `X2_L_LAST_SPELLSCHOOL_VAR`: 1,121 operations were
  removed from 374 scripts and all 374 executables compiled.
- At the start of this slice only two runtime implementations still read that
  state:
  `MySavingThrow` in `nw_i0_spells.nss`, and the no-school fallback in
  `gsSPGetCastSpellSchool`.
- The live recount after removal finds 172 `MySavingThrow` calls across 131
  consumer files. 102 consumer files make 118 `GetChangesToSaveDC` calls.
- 352 of the 374 writers are named directly by a `spells.2da` `ImpactScript`
  row.
- Only six of those writer scripts serve rows whose `School` cell is blank:
  `conj_luz`, `nw_s0_daze`, `nw_s0_invisib`, `nw_s0_rayfrost`,
  `nw_s0_resis` and `x0_s0_flare`. They cover seven racial rows: high-elf or
  kobold ray of frost, daze, light, flare and resistance, plus duergar and oni
  invisibility.
- The remaining 22 writers are secondary or area scripts rather than direct
  impact scripts and require their invocation path to be traced.

Steps 1 and 2 are complete. `MySavingThrow` accepts spell id and school after
its legacy parameters, so existing callers remain source-compatible while
`gsSPSavingThrow` supplies exact context. Its fallback resolves `GetSpellId()`
through `inc_spellschool`, not through the local. The seven blank rows have
explicit overrides.

The 22 secondary writers were also traced. Only `nw_s0_delfirea` makes a save;
its originating delayed-blast-fireball row declares Evocation. The others make
no save or DC call, and any resistance call already receives the real creator
and spell id. None needs the local.

No runtime reader or writer of `X2_L_LAST_SPELLSCHOOL_VAR` remains. The order is
therefore now:

1. **Complete.** Remove the 374 writer/deleter pairs mechanically, add the
   required modification markers and compile every modified executable.
2. **Pending.** Migrate the remaining public save/DC callers in behavioral
   groups; this is
   still required for explicit caster context, but no longer blocks deleting
   the school state.

### Completed 2026-08-28 — central roll core and first direct callers

Commit `e7ef8057c` split `inc_spellsave.nss` behind the `inc_spells` facade.
`gsSPSavingThrow` and the source-compatible `MySavingThrow` adapter now share
one native-roll, DC-bound, immunity and feedback implementation. The core's 140
executable direct consumers compiled; the compiler skipped only the two
include-only files in the inventory.

Commit `68bf3d3b9` migrated the five simple direct Fortitude-versus-death spells:
Circle of Death, Finger of Death, Implosion, Slay Living and Wail of the Banshee.
They now pass caster, spell row, base DC and death subtype explicitly. The live
inventory after that first caller group is 166 `MySavingThrow` calls across 126
consumer files and 113 `GetChangesToSaveDC` calls across 97 consumer files.

### Resume point — updated 2026-08-30, late

The last implementation commit is `a020e6636`, and **its audit has not run**: the
reviewer hit its own usage quota. See `documentation/repository/audit-log.md` for
how to re-run it. Do that before starting another batch.

Live counts, measured rather than remembered, excluding `MySavingThrow`'s
prototype and definition rather than the file that holds them:

- **59 legacy `MySavingThrow` calls across 42 files.** Two of them are inside
  `nw_i0_spells.nss` itself, at lines 817 and 849.
- **21 legacy direct `GetReflexAdjustedDamage` calls across 15 files.**
- **79 direct calls to the save natives** - 36 `ReflexSave`, 18
  `FortitudeSave`, 26 `WillSave` - across about 50 files. Mostly traps and
  feats, both out of scope by decision, and none of them counted before
  2026-08-30.
- `GetChangesToSaveDC` and `ChangedElementalDamage` still have consumers and
  cannot be retired.

#### What is next, in order — rewritten 2026-08-31

Section 1, the saving throw work, is **done** except for one small item. The five
steps this list used to carry are all closed: the audit was re-run, the 46
policy-free files were migrated across two batches, the delayed family was
examined and hardened, the search it should have started with was done and found
`war_invisiblem`, and the darkness descriptor is parked.

**Section 1 is closed.** `x2_s0_glphwardx` was the last item and was done on
2026-08-31: it now reads the spell row the glyph already stored and measures
against the caster rather than the placeable.

Its base difficulty is still `GetSpellSaveDC()` in a placeable trigger, which is
the same unreliable call the delayed family was hardened against. It was left
alone deliberately - changing it means deciding what a glyph's difficulty should
be and storing that at planting time, which is a rules question rather than a
repair.

**What is left of the plan**

| Section | State |
|---------|-------|
| 1. Saving throws | **done**, glyph included, 2026-08-31 |
| 2. Potion stacking | fixed 2026-08-26; awaits play validation and three potions that share `nostack_inc`'s territory |
| 3. Negative Energy Burst and `nostack_inc` | **last of all**, by the owner's instruction, and only after everything else is validated in play |
| 4. Mind Fog's repeated save | taken and reversed 2026-08-31; the capability is in the library, unused |
| 5. Warlock errata | nine closed 2026-08-31 in `842c9d643`, `5037bcd5c` and `928c9e6a5`; see the status table at the head of the section |
| 6. Artificer infusion errata | none implemented. Its saving throws moved on 2026-08-30; the errata are separate |
| 7. Archmage Arcane Fire | none implemented |
| 8. Archmage Time Stop | deferred until every preceding section is complete |

Sections 5, 6 and 7 are the substance of what remains, and none of them is
saving-throw work. They are class rules measured against their published
versions, and each item in them changes live balance, so each needs the owner's
decision before it is written rather than after.

**Nothing in the plan is blocked on anything else.** The dependency that used to
exist - warlock and artificer had to be read together first - was discharged on
2026-08-30 and the reading found they barely touch.

#### Rules learned the hard way, all on 2026-08-30

- **Count after the last file goes in, from the committed diff.**
- **Search all three legacy shapes**, not two. The native calls are invisible to
  a grep for the two wrappers.
- **A script is an area script when something wires it into an area**, not when
  it assigns `GetAreaOfEffectCreator` to a local.
- **`MySavingThrow` is not a plain roll.** It applies Shadow Defence, so a
  migration off it must set `iShadowDefence`.
- **Moving a call to the spell route is never neutral.** It grants Spellcraft
  compensation wherever the subtype is not `SAVING_THROW_TYPE_SPELL`.
- **A `GetChangesToSaveDC(OBJECT_SELF)` inside an area script was reading zero.**
  Moving it makes the term real and the difficulty moves.
- **Check the row's school before writing a Shadow Defence expectation** into a
  test. It covers illusion, enchantment and necromancy only.
- **Take spell names from `spells.2da`, not from filenames.** `x2_s2_gwdrain`
  is the Shifter's spectre attack, not a wraith drain; `x2_s2_discbreath` is Red
  Dragon Disciple Breath, not a dracolich's; `nw_s0_conund` is Control Undead,
  not Confusion. Three wrong guesses from three filenames.
- **Check for an existing marker in every form before adding one.** Some files
  carry it as `//:: modified by: Dhraax` rather than `/// modified by: Dhraax`,
  and a check for the exact `///` string adds a second one. Search for the
  substring `modified by: Dhraax`.
- **Before calling an `oSaveVersus` correction player-visible, read every
  caller.** A parameter that every caller already fills with the same object the
  default resolved to changes nothing, and a helper whose callers never enable
  its save changes nothing either. Both were claimed as corrections in
  `x0_i0_spells` and both were unreachable.
- **`OBJECT_SELF` is not always the caster, even outside area scripts.**
  `pb_mod_activate` is executed by name from the module's item-activation event,
  so `OBJECT_SELF` there is the module while the activator sits in `oPC`. Trace
  how a script is invoked before asserting what `OBJECT_SELF` is; the area-script
  test is necessary and not sufficient.
- **The authorship marker goes inside the header, immediately before its closing
  separator** - not on line 1. Twenty files across four commits on 2026-08-30 got
  it wrong the same way, because the helper that added it prepended without
  looking for a header. Nothing in the compiler or the checkers sees this.
- **Match each file's own line endings.** This repository mixes them per file:
  of seventy-five scripts touched on 2026-08-30, `x2_s0_undeath.nss` was the only
  CRLF one, and inserting LF lines into it left it mixed. Check with
  `file <path>` before editing and write what it already uses. `git diff --check`
  will flag every added line in a CRLF file as trailing whitespace; that is the
  carriage return and is expected, not a defect.

#### Completed 2026-08-29: direct negative-energy spells

Eight direct spell callers that used the normal engine spell DC,
`GetChangesToSaveDC(OBJECT_SELF)` and the negative-energy subtype now call
`gsSPSavingThrow` with explicit context:

1. `nw_s0_circdoom` — Fortitude success halves damage; keep `fDelay`.
2. `nw_s0_enervat` — Fortitude failure applies negative levels.
3. `nw_s0_enedrain` — Fortitude failure applies permanent negative levels.
4. `nw_s0_ghoultch` — melee touch, then Fortitude to negate.
5. `nw_s0_negray` — Will success halves damage.
6. `nw_s0_negburst` — Will success halves damage; keep `fDelay`.
7. `nw_s0_rayenfeeb` — Fortitude failure applies the ability penalty.
8. `x2_s0_healstng` — Fortitude failure applies the hostile effect; its spell
   resistance block is commented out and must not be silently enabled in this
   mechanical migration.

All eight retain their Fortitude or Will save, negative-energy subtype, caster,
spell row and base DC. Existing delays remain unchanged except for
`nw_s0_negburst`, which now calculates the current target's distance before its
save feedback uses `fDelay`, closing the known previous-target delay defect. Its
separate undead Strength stacking and hardcoded duration are unchanged. Focused
compilation passed for all eight scripts with no skips or errors.

#### Completed 2026-08-29: Harm and mass cure/inflict spells

`nw_s0_harm` now centralizes only the living hostile branch's Will save against
negative energy. A successful save still halves the damage, while the undead
healing branch still has no save.

`conj_cihergrupo` is the direct `ImpactScript` for spell rows 1050 through 1057,
and it assigns `oCaster = OBJECT_SELF`. Its mass cure rows now use the central
Will save with the positive-energy subtype when damaging undead, and its mass
inflict rows use the negative-energy subtype when damaging living targets. Both
families pass their actual spell row and preserve their existing delay,
resistance, healing and damage branches. This also means the central policy
resolves Conjuration for mass cure and Necromancy for mass inflict from
`spells.2da` rather than sharing an assumed school.

Focused compilation passed for `nw_s0_harm.nss` and
`conj_cihergrupo.nss`: two successful, zero skipped and zero errored.

#### Completed 2026-08-29: direct poison and disease spell review

`x2_s0_infestmag` was the only remaining live standard-DC spell with a scripted
poison or disease save. Infestation of Maggots now captures the unmodified spell
DC at cast time and passes that base DC, the original caster, the actual spell
row and the disease subtype to `gsSPSavingThrow` for every periodic Fortitude
save. The redundant target local that stored the DC had no external consumer;
its only read assigned an unused variable, so the local and its cleanup are
removed.

The rest of the family needs no equivalent spell migration. Stinking Cloud and
Cloud of Bewilderment already use the central route in their area handlers.
Poison and Quillfire apply `EffectPoison`, whose own poison saves are engine
behavior rather than script calls. `spellsStinkingCloud` in `x0_i0_spells` has
no source consumer and belongs to later dead-code removal, not a behavioral
migration. `enc_boss` and `prc_to_carriona` use encounter or class-feature DCs
and must eventually use the generic `gsSPRollSavingThrow` route with explicit
save-versus context.

Focused compilation passed for `x2_s0_infestmag.nss`: one successful, zero
skipped and zero errored.

#### Completed 2026-08-29: first direct elemental damage batch

Burning Hands, Fireball, Lightning Bolt and Cone of Cold now resolve their
spell row, base DC, final Mastery of Elements damage type and matching save
subtype once per cast. Each target's Reflex and Evasion adjustment then goes
through `gsSPAdjustedDamage`, while the resulting `EffectDamage` uses that same
resolved type. This removes four copies of direct DC/save assembly and prevents
the old split where Mastery changed the damage after the save had already used
the spell's original fire, electrical or cold subtype.

The spells retain their shapes, targets, resistance, metamagic, damage dice,
delays and Mastery of Shaping decisions. Lightning Bolt and Cone of Cold also
retain their consumable amethyst and sapphire sand branches. Fireball continues
to serve both its normal and Shades rows. Focused compilation passed for all
four scripts with no skips or errors.

#### Completed 2026-08-29: second direct elemental damage batch

Flame Lash, Meteor Swarm, Call Lightning, Aganazzar's Scorcher, Mestil's Acid
Breath, Ice Dagger and Scintillating Sphere now follow the same one-resolution
contract. Each cast resolves its spell row, base DC, final Mastery of Elements
damage type and matching save subtype before visiting targets. Every target's
Reflex/Evasion adjustment uses `gsSPAdjustedDamage`, and its damage effect uses
the already resolved type.

The local mechanics remain in their scripts: Call Lightning's rain bonus,
Meteor Swarm's two-metre safe zone, Aganazzar's chained beam, the target shapes,
spell resistance, metamagic, damage caps, delays and Mastery of Shaping where
present. Focused compilation passed for all seven scripts with no skips or
errors.

Do not include these in the direct-spell batch:

- `f_vampirecoffinm` uses a custom `10 + caster level` DC inside another
  object's execution context.
- `war_area` uses the warlock's custom DC and needs a generic adjusted-damage
  route, not the spell-school policy by assumption.
- `x2_s2_undgraft1`, `x2_s2_undgraft4`, `x2_s2_undgraft5`,
  `x2_s2_gwdrain` and `x2_s2_dthmsttch` are special abilities with local
  `nDC` or `nSave`; they should eventually use `gsSPRollSavingThrow`, not
  `gsSPSavingThrow`, unless their spell context is established separately.

#### Completed 2026-08-30: Chain Lightning and the elemental area handlers

Chain Lightning, the Delayed Blast Fireball area handler and both Incendiary
Cloud handlers follow the same one-resolution contract as the two direct
batches. Chain Lightning keeps both of its damage sites, the halving on
secondary targets, its caster level cap, metamagic and beam chaining. The area
handlers keep their shapes, resistance, metamagic, delays and Incendiary Cloud's
door and placeable targeting.

Two corrections came with it, and both change the DC a defender rolls against:

- Both Incendiary Cloud handlers never called `GetChangesToSaveDC` at all, so
  the school modifier never reached them.
- `nw_s0_delfirea` called `GetChangesToSaveDC(OBJECT_SELF)`, and `OBJECT_SELF`
  in an area script is the area object, which holds no feats. The term was
  always zero.

Neither has been observed in play. **When migrating any other area handler,
check which of these two shapes it has**: an area script that reads a feat or a
modifier from `OBJECT_SELF` is reading the area, not the caster.

The two Incendiary Cloud handlers name spell row 89 explicitly. `spells.2da`
row 1259 `Blig_IncendiaryCloud` shares the same script chain, so an area it
creates reports its saves under row 89. Both rows are Evocation, so no policy
differs today. Carrying the originating row needs `nw_s0_inccloud` to create its
area through the library, which is area-conversion work rather than save work.
Delayed Blast Fireball has only row 39 and no alias.

Focused compilation passed for all four scripts with no skips or errors.

#### Completed 2026-08-30: scaled-DC mind spells and Electric Loop

The six all passed `GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF)` as the
DC. **That sum is wrong for the central route and this is the trap for every
remaining caller**: `gsSPSavingThrow` and `gsSPAdjustedDamage` take the DC
*before* school rules and add Shadow Weave and Shadow Defence themselves. A
caller that hands over the old sum applies the school modifier twice, and nothing
in the compiler or the checkers will say so. There are 51 consumer files of
`GetChangesToSaveDC` left, and each is one chance to make that mistake.

Electric Loop had to be read whole. Its Will save against stun runs only when the
Reflex save failed, and it detects that by comparing the adjusted damage with the
potential damage, so the two rolls are one decision that must share a
resolution.

Focused compilation passed for all six with no skips or errors.

#### A process note, from two audits in a row

Both the 2026-08-30 batches were blocked by the same finding: a code commit that
changed player-visible behaviour and carried no changelog entry. The rule that
prevents it is now in `AGENTS.md`, in the changelog bullet and in the audit
section, rather than here where it would be deleted with this plan. This
paragraph is a pointer, not a second copy.

#### The oSaveVersus inventory, recounted 2026-08-30

The audit of `2f434df41` said the count of fifteen missed at least one call. It
did, and the count was built the way every count in this plan was built before
today: by grepping two of the three legacy shapes. Recounted across all three,
restricted to scripts that assign `GetAreaOfEffectCreator`, and verified line by
line rather than by grep total:

**Confirmed area-script saves measuring against the area object**

| Script | Line | Shape |
|--------|------|-------|
| `nw_s0_bladebara` | 58 | omits the argument |
| `nw_s0_bladebarc` | 77 | omits the argument |
| `nw_s0_evardsa` | 157 | passes `OBJECT_SELF` explicitly |
| `nw_s0_evardsc` | 163 | passes `OBJECT_SELF` explicitly |
| `nw_s0_entanglec` | 60 | omits the argument |
| `x2_s1_bebweba` | 73 | omits the argument |
| `x2_s1_bebwebc` | 68 | omits the argument |
| `auradeath` | 33 | omits it while `oDragon` is in scope |
| `nw_s1_dragfeara` | 73 | omits the argument |
| `prc_to_pallora` | 35 | omits the argument |
| `prc_to_carriona` | 33 | omits the argument |

Eleven, all fixed on 2026-08-30. The two Evard's ones are worth noting: they pass
`OBJECT_SELF` **explicitly**, so somebody wrote it deliberately, and in an area
script it is the area.

**Not defects, previously miscounted**

- `f_vampireaura` passes `oOwner` at all four of its saves. Correct.
- `z217_behold` is a creature script, where `OBJECT_SELF` is the creature and is
  the right answer.
- `x0_i0_spells` has three sites inside helper functions where the answer depends
  on the caller, and one on `SAVING_THROW_TYPE_TRAP` which is out of scope.
- `inc_spellsave` and `nw_i0_spells` hold the implementations.

**Two rules, both learned by getting this wrong twice.**

A count that greps `MySavingThrow` and `GetReflexAdjustedDamage` misses the
direct native calls. That is what made fifteen wrong.

And **a script is an area script when something wires it into an area, not when
it assigns the creator.** `nw_s1_dragfeara` is the ONENTER of
`vfx_persistent.2da` row 36; `prc_to_pallora` and `prc_to_carriona` are named in
`EffectAreaOfEffect` calls in `prc_to_pallor` and `prc_to_carrion`. None of the
three assigns `GetAreaOfEffectCreator` to a local, so testing for that assignment
dismissed all three as creature scripts. That is what made eight wrong. Grep the
2DA and the `EffectAreaOfEffect` calls, not the script's own first lines.

**And exclude the prototype and the definition, not the file.** `nw_i0_spells`
holds `MySavingThrow`'s two declarations and also two genuine callers at lines
817 and 849. Dropping the whole file to skip the declarations hid them.

#### Moving a call from MySavingThrow to the spell route is never neutral — 2026-08-30

Two rules, and both were denied in a handoff before an audit produced them.

**`MySavingThrow` does not compensate Spellcraft; `gsSPSavingThrow` always
does.** The adapter delegates to `gsSPRollSavingThrow` with `iSpellcraft`
defaulting FALSE, while `gsSPSavingThrowResult` calls
`gsSPApplySpellcraftSave` unconditionally. So every call moved from the adapter
to the spell route gains the compensation wherever its subtype is not
`SAVING_THROW_TYPE_SPELL` - which is most of them. That is correct by this
project's own rule and it is a buff to defenders, and it must be declared rather
than described as a neutral conversion.

**A call whose old DC read `GetChangesToSaveDC(OBJECT_SELF)` inside an area
script was reading zero.** The area object holds no feats. Moving it to the spell
route makes the term real for the first time, so a Shadow Weave caster's
difficulty moves. `nw_s0_entanglec` and `x2_s0_vinementc` both had this.

The shape of the mistake in both cases is the same: I checked what the code now
does and not what it stopped doing.

#### Shadow Defence covers three schools, not every save — 2026-08-30

`gsSPGetShadowDefenceDCForSchool` returns 0 unless the school is illusion,
enchantment or necromancy. **A migration that sets `iShadowDefence` on a save
whose school is none of those changes nothing**, and a test written as if it did
will report correct behaviour as a failure. That is what an audit caught in the
warlock batch, where three of six invocations are transmutation, evocation and
conjuration.

Setting the flag anyway is right - it is what `MySavingThrow` did, and it costs a
lookup that returns zero. What is wrong is claiming the effect where the school
cannot produce it. **Check the row's school in `spells.2da` before writing a
Shadow Defence expectation into a test.**

One loose end from the same batch: `war_tentaculosa` is an area script and passes
`-1` for the spell row, so the school comes from `GetSpellId()` in a context
where that is not a cast. Its row 1349 is conjuration, which Shadow Defence does
not cover either way, so nothing currently depends on the answer. It would if the
row were ever an illusion, enchantment or necromancy one.

#### A third legacy shape the counts never included, found 2026-08-30

The inventory has always counted `MySavingThrow` and `GetReflexAdjustedDamage`.
There is a third: **scripts that call the engine's save natives directly.**

    ReflexSave      36 calls across 34 files
    FortitudeSave   18 calls across 12 files
    WillSave        26 calls across 16 files

Eighty calls, excluding `inc_spellsave` and `nw_i0_spells` which own the
implementations. `x0_s0_bombard` was migrated with one of them still in it - the
rubble paralysis - which would have left one roll in a spell compensating
Spellcraft and the other not. The audit caught it; the grep that built the batch
could not, because it searched for the two known shapes.

Most of the eighty are out of scope by decision: the `df_t*` family is traps, and
`dote_*` are feats which belong with the ability families. But the number is not
in any count quoted in this document, and **any migration that greps for the two
known shapes will keep missing the third**. Search a whole file before declaring
it converted, as the Electric Loop and Bombardment cases both showed.

#### Completed 2026-08-30: the loose damage scripts

Earthquake, Bombardment and Acid Splash to the spell route because they already
took the school modifier; Imbue Arrow to the policy-free route because it is an
Arcane Archer ability and never did. Acid Splash also stopped rolling against
acid while dealing a converted element.

The spell route grants those three defenders the Spellcraft compensation they
were losing to their specialised subtypes. That is intended and matches every
other spell on the route; the changelog first claimed nothing changed, which was
wrong.

`x2_s0_glphwardx` is not migrated. It reads its DC modifier from `OBJECT_SELF`,
which is the glyph placeable, so the term is always zero - the same fault
`nw_s0_delfirea` had. The spell route needs the row the glyph was created from,
and the glyph stores `X2_PLC_GLYPH_CASTER` and `X2_PLC_GLYPH_CASTER_LEVEL` but no
row. It is also next to the trap scripts, which are out of scope.

#### Order after the direct negative-energy and disease families

1. ~~Chain Lightning and the direct elemental area handlers.~~ Done
   2026-08-30 in `ebcbf9d16`; see the batch note below. Blade Barrier was
   excluded on inspection: it deals slashing damage, so Mastery of Elements has
   nothing to convert and the elemental resolution does not apply to it.
2. ~~Mind/fear spells with a scaled or situational DC, and Electric Loop as one
   whole damage-plus-stun spell.~~ Done 2026-08-30 in `a65b8a2a6`. Two of the
   five, `nw_s0_charmper` and `x2_s0_horiboom`, turned out to scale nothing;
   they were in the list for their mind subtype. `conj_suenyoprof`'s hit dice
   pool is a target filter, not a difficulty.
3. Abilities, feats, artificer, warlock and encounter scripts with custom DCs.
   Add a generic Reflex-adjusted-damage counterpart to
   `gsSPRollSavingThrow` before migrating custom-damage callers; do not apply
   Shadow Weave, Shadow Defence or spell-row policy by accident.
4. Retire `MySavingThrow`, `GetChangesToSaveDC` and
   `ChangedElementalDamage` only after their consumer counts reach zero.
5. Implement and validate Shadow Defence's still-missing darkness-descriptor
   half from a reviewed spell-row table.
6. Review `pb_nivellanzador`, spell resistance and dispelling as three separate
   high-coupling changes after caller migration. Do not mix their redesign into
   a spell-family commit.

All runtime checks in the August module changelog remain pending. No module
build, package, deployment or in-game validation was performed through
2026-08-29; only the focused compiler checks recorded beside each committed
slice ran.

### Then — sections 5, 6 and 7, which have never been read against each other

Warlock and artificer share `war_utilities`, `x0_i0_spells` and the damage-type
selection, and each was written as if it were alone. The archmage does not share
them. **The first
task is not to fix them but to read them together**, because the saving-throw
work will already have touched `war_utilities` and the answer may have changed.

### Held — sections 2 and 4

**Section 2** is closed except for validation and three potions that share
`nostack_inc`'s territory. It waits on nothing here.

**Section 3 is the last step of all, and only after everything above is
validated in play.** Whether to retire `nostack_inc` for the NWNX plugin is a
decision, not a task, and it coexists with everything this plan does. Nothing
above touches it and nothing above should be allowed to touch it.

It is placed last for a measured reason rather than caution. `nostack_inc` has
**40 public functions and only five have a caller outside the file**:

| Function | External calls |
|---|--:|
| `DoNoStackSkillBonus` | 31 |
| `DoNoStackAbilityBonus` | 27 |
| `RemovePropertyAndReturnModifier` | 7 |
| `DoNoStackSavingThrowBonus` | 1 |
| `RemoveMagicSkillBonus` | 1 |

The other 35 - the whole item half, `RestoreAllItems`, `HasItemAbilityBonus`,
every `Neutralize*` and every `GetHighestBonusItem*` - are called by nothing.

**That changes the comparison and it also changes the order.** Comparing 1231
lines against a plugin is not the comparison; comparing five functions against it
is. So when this is taken up:

1. **Delete the 35 unused functions first.** No plugin, no decision, no
   behaviour change - and what remains is small enough to reason about.
2. **Then compare.** The one real difference in rules is that `DoNoStack*`
   subtracts the target's highest matching item bonus before applying -
   `nModifier -= sItem.nScore`, so a `+20` spell over a `+20` item grants
   nothing. `NWNX_NOSTACK_ABILITY=1` says "only the highest effect is used" and
   does **not** subtract the item. Fifty-eight call sites depend on the
   subtraction.
3. **And `RemovePropertyAndReturnModifier` survives either way.** Its seven
   callers are item-property manipulation, not non-stacking, and it needs a home
   whatever is decided.

**None of that is this plan's business.** It is written here so the next person
starts from the five rather than from the 1231.

**Section 4** is a ruleset question about whether mind fog should roll every
round. It waits on somebody deciding, not on code.

### Last of all — section 3

See above. After everything else is implemented **and validated in play**, not
before.

### Two checks that could shrink the work before any of it

- `nw_s0_mindfoga` and `war_dominar` pass `MIND_SPELLS`, a spell subtype rather
  than an elemental one. If the engine already treats it as a spell save, both
  are correct as they stand.
- `x2_s0_combust` is the first known member of the delayed-save category, which
  has never been inventoried. **148 `.nss` files under `src/` contain both a save
  call and a `DelayCommand`** - the intersection of files matching
  `MySavingThrow|ReflexSave|WillSave|FortitudeSave|GetReflexAdjustedDamage` with
  files matching `DelayCommand`. That is a candidate list, not a defect list: it
  does not say whether the save is inside the delayed path, and most will not be.
  An earlier draft said fifty-four, which was wrong.

---

---

## 1. Saving throws

Status: **saving-throw groups implemented 2026-08-27; explicit area-caster and
school migration implemented 2026-08-28.** Calls that had no subtype now ask for
`SAVING_THROW_TYPE_SPELL`, and
twelve calls that must retain an elemental or other subtype receive the
defender's invested-rank Spellcraft bonus through `gsSPSavingThrow`. The school
lookup, penetration rule, live dispel path and nineteen current wrapper-area
saves are migrated. The five known invalid area-script `oSaveVersus` arguments
are fixed. Shadow Defence reaches the migrated school-based saves; its darkness
descriptor and the repository-wide direct-save migration remain pending.

### Scope

Perform a repository-wide review of spell saving throws, including
`DoMissileStorm`, direct spell impact scripts, persistent areas, secondary
scripts, and delayed effects. Damage types and saving throw types must be
treated as separate concepts.

### Current behavior

`DoMissileStorm` accepts a damage type and a Boolean that enables a Reflex
save. When the save is enabled, it currently selects the saving throw subtype
from the damage type using only two branches:

- `DAMAGE_TYPE_MAGICAL` selects `SAVING_THROW_TYPE_SPELL`.
- Every other damage type selects `SAVING_THROW_TYPE_FIRE`.

This produces the following results:

| Spell | Current damage input | Current Reflex behavior |
|-------|----------------------|-------------------------|
| Isaac's Lesser Missile Storm | `DAMAGE_TYPE_FUERZA` | Enabled, but classified as fire by `DoMissileStorm` |
| Isaac's Greater Missile Storm | `DAMAGE_TYPE_FUERZA` | Enabled, but classified as fire by `DoMissileStorm` |
| Firebrand | Result of `ChangedElementalDamage(..., DAMAGE_TYPE_FIRE)` | Enabled; every non-magical result is classified as fire |
| Ball Lightning | Result of `ChangedElementalDamage(..., DAMAGE_TYPE_ELECTRICAL)` | Disabled because the optional Reflex argument is omitted |

The four spells above run directly as `ImpactScript` entries with `UserType` 1
in `spells.2da`. In this context, the engine automatically adds the spell save
classification on top of the selected elemental subtype. Spellcraft and other
save-versus-spell modifiers therefore apply even when the visible subtype is
fire or electricity.

Incendiary Cloud is different. Its initial `ImpactScript` creates a persistent
area, and `NW_S0_IncCloudA` later runs from `vfx_persistent.2da` as the area's
`OnEnter` script. Passing `GetAreaOfEffectCreator()` identifies the source but
does not restore the original spell-script context. Its current fire save does
not automatically receive Spellcraft or other save-versus-spell modifiers.

### User-observed affected spells

The following spells have been observed in game to perform saving throws
without adding the expected Spellcraft save bonus:

- Grease (`NW_S0_GreaseA` and `NW_S0_GreaseC`).
- Web (`NW_S0_WebA` and `NW_S0_WebC`).
- Delayed Blast Fireball (`NW_S0_DelFireA`).
- Incendiary Cloud (`NW_S0_IncCloudA` and `NW_S0_IncCloudC`).
- Acid Fog (`NW_S0_AcidFogA` and `NW_S0_AcidFogC`).
- Combust (`X2_S0_Combust`, including delayed `RunCombustImpact` calls).

This is evidence of a general execution-context problem rather than an issue
limited to Incendiary Cloud. The list is not assumed to be exhaustive.

The future review must cross-reference every saving throw call with its actual
execution context. At minimum, it must cover:

- `OnEnter`, `OnHeartbeat`, and `OnExit` scripts referenced by
  `vfx_persistent.2da`.
- Saving throws inside functions scheduled with `DelayCommand` after the
  original spell impact has completed.
- Secondary scripts invoked with `ExecuteScript` or equivalent mechanisms.
- Any spell effect whose saving throw occurs after the initial `ImpactScript`.
- Direct `ReflexSave`, `FortitudeSave`, `WillSave`, `MySavingThrow`, and
  `GetReflexAdjustedDamage` calls.

### Damage names

The project defines these custom damage aliases in `pb_constantes.nss`:

- `DAMAGE_TYPE_FUERZA` maps to `DAMAGE_TYPE_CUSTOM2` and is displayed as
  `Fuerza`.
- `DAMAGE_TYPE_VENENO` maps to `DAMAGE_TYPE_CUSTOM3` and is displayed as
  `Veneno`.
- `DAMAGE_TYPE_PSIQUICO` maps to `DAMAGE_TYPE_CUSTOM4` and is displayed as
  `Psiquico`.

The standard NWScript name `DAMAGE_TYPE_ELECTRICAL` is displayed as
`Relampago`, and `DAMAGE_TYPE_SONIC` is displayed as `Trueno`. The corresponding
standard saving throw constants remain `SAVING_THROW_TYPE_ELECTRICITY` and
`SAVING_THROW_TYPE_SONIC`. No custom Force saving throw type currently exists.

### Revisited 2026-08-26: the same root cause reaches further than Spellcraft

This document describes saves made outside a spell's own `ImpactScript` losing
the classification the engine adds automatically. **The Spellcraft bonus is not
the only thing that context carries**, and the second one is in this module's own
code rather than the engine's.

#### Shadow Defence silently does nothing against three area spells

`MySavingThrow` in `nw_i0_spells.nss:456` lowers the DC for a character with the
Shadow Defence feats:

```nwscript
if(GetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION ||
   ... == SPELL_SCHOOL_ENCHANTMENT || ... == SPELL_SCHOOL_NECROMANCY)
{
   if(GetHasFeat(1360, oTarget)){ nDC -= 3;}
   else if (GetHasFeat(1359, oTarget)){ nDC -= 2;}
   else if (GetHasFeat(1358, oTarget)){ nDC -= 1;}
}
```

It reads the school off **`OBJECT_SELF`**, which a spell script sets at its start
and deletes at its end. In an area-of-effect script `OBJECT_SELF` is the area
object, and these never set it:

| Script | `MySavingThrow` calls | Sets the school |
|---|--:|---|
| `nw_s0_weba` | 2 | **no** |
| `nw_s0_webc` | 2 | **no** |
| `nw_s0_mindfoga` | 2 | **no** |
| `nw_s0_greasec` | 1 | **no** |
| `nw_s0_delfirea` | 0 | yes, three times |

So the DC reduction never fires for them. **Mind fog is Enchantment** - one of
the three schools the feat covers - and a character who took Shadow Defence gets
nothing from it there. Delayed Blast Fireball was already patched to set the
variable, by somebody who presumably hit this and fixed one case.

This is the same defect as the Spellcraft one, in the module's own code: a save
that depends on context, made where the context is not.

#### What is available now that was not when this was written

- **`GetSpellId()` works in area-of-effect scripts.** Every converted spell
  declares `int iSpellId = GetSpellId();` at the top of `main` and passes it
  down. The spell's identity is reachable from an area script.
- **`GetCasterLevel(oAoE)` returns the level the area was created with**, stated
  by the engine at `nwscript.nss:7173`. The caster's own level is reachable even
  when the caster is not.
- **`SetEffectSpellId` and `SetEffectCasterLevel` are natives**, and area effects
  now carry both, so the engine can already attribute an area's *effects*
  correctly. Its *saves* are the part still guessing.
- **`gsSPApplyEffect` proved the shape works.** Every effect application in the
  converted spells goes through one function that takes its context as arguments
  instead of reading it off `OBJECT_SELF`.

#### The shape this suggests

**One save path, for the same reason there is one apply path.** A
`gsSPSavingThrow` that takes the spell row and the area or caster explicitly,
rather than reading a local off whatever `OBJECT_SELF` happens to be, would fix
the Shadow Defence case by construction: the school comes from the row through
`Get2DAString("spells", "School", iSpellId)`, not from a variable somebody must
remember to set.

**It does not fix the Spellcraft case by itself**, and that is the honest limit.
The engine's vs-spell classification is applied by the engine, and no wrapper can
ask for it. Two routes exist and neither is free:

1. **Compensate in the DC.** Compute the target's Spellcraft-derived bonus and
   subtract it, keeping the elemental subtype. Reproduces the arithmetic and not
   the mechanism, so anything else that keys on "this was a spell save" still
   sees an elemental one.
2. **Pass `SAVING_THROW_TYPE_SPELL`.** Supported and simple, and it drops the
   elemental subtype - which is the tradeoff this document already records under
   proposal 6.

### The cause, found 2026-08-26: it is the elemental save type

**The eight spells lose the Spellcraft bonus because they ask for an elemental
saving throw subtype.** Not because of where they run, not because of the
`ImpactScript` context, and not because of `oSaveVersus`.

`nSaveType` is a single `SAVING_THROW_TYPE_*` and the engine applies the
modifiers of the subtype it is given, and only those. Ask for
`SAVING_THROW_TYPE_FIRE` and the defender gets fire modifiers. Ask for
`SAVING_THROW_TYPE_SPELL` and the defender gets spell modifiers - Spellcraft
among them - **wherever the call is made**. There is no `ImpactScript`
requirement.

#### Spells in this module that already get it, and how

They pass `SAVING_THROW_TYPE_SPELL`. That is the whole method.

| Script | Line | Call |
|---|--:|---|
| `x0_s0_sunburst` | 129, 144, 156 | `ReflexSave(oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF), SAVING_THROW_TYPE_SPELL)` |
| `nw_s0_sunbeam` | 83 | the same shape |
| `nw_s0_gate` | 263 | `MySavingThrow(SAVING_THROW_WILL, oCreature, nDC, SAVING_THROW_TYPE_SPELL)` |
| `nw_s0_grplanar` | 281 | the same |
| `nw_s0_lsplanar` | 282 | the same |
| `nw_s0_planar` | 279 | the same |
| `war_area` | 108 | `GetReflexAdjustedDamage(..., SAVING_THROW_TYPE_SPELL)` |
| `x0_i0_spells` | 775 | `DoMissileStorm`'s magical branch |
| `enc_boss` | 86 | `MySavingThrow(SAVING_THROW_WILL, oJugador, nDC, SAVING_THROW_TYPE_SPELL, oBoss)` |

`x0_s0_sunburst` is the complete example: spell subtype **and**
`GetChangesToSaveDC`.

**`x0_i0_spells:775` is the same choice made explicitly**: `DoMissileStorm` asks
for `SAVING_THROW_TYPE_SPELL` when the damage is magical and fire for everything
else. That is the two-branch selection this document opens by describing, and it
is also the proof that somebody understood the mechanism.

#### What was wrong in this document before

Three earlier explanations are withdrawn:

- **Not the `ImpactScript` context.** `nw_s0_gate` and the planar binding spells
  make their saves in `DelayCommand`ed helpers and get the bonus.
- **Not `oSaveVersus`.** `x0_s0_sunburst` passes `OBJECT_SELF` and gets it.
- **Not a missing compensation.** No script in the module compensates for this by
  hand, and none needs to.

`nw_s0_delfirea`, called "already repaired" here, repairs the **school** half -
it sets `X2_L_LAST_SPELLSCHOOL_VAR` and passes `GetChangesToSaveDC` - and does
nothing about Spellcraft, which is why it is on the list of affected spells
despite being the best-wired of the eight.

### The full inventory of area scripts that make a saving throw

Every script named by `haks-2da/vfx_persistent.2da` in its enter, heartbeat or
exit column, that calls `MySavingThrow`, `ReflexSave`, `WillSave`,
`FortitudeSave` or `GetReflexAdjustedDamage`. **Twenty-eight of them**, of which
the owner's original list named seven.

Traps are excluded by decision: `q1_t0_camopita`, `q1_t0_deeppita` and
`q1_t0_whirlbldc` pass `SAVING_THROW_TYPE_TRAP`, a trap is not a spell, and a
Spellcraft bonus against one would be wrong.

#### Group 1 — a specific subtype, so the spell modifiers are lost

| Script | Area | Line and subtype | On the original list |
|---|---|---|:--:|
| `nw_s0_acidfoga` | Acid Fog | 50 ACID | yes |
| `nw_s0_acidfogc` | Acid Fog | 60 ACID | yes |
| `nw_s0_delfirea` | Delayed Blast Fireball | 85 FIRE | yes |
| `nw_s0_incclouda` | Incendiary Cloud | 54 FIRE | yes |
| `nw_s0_inccloudc` | Incendiary Cloud | 65 FIRE | yes |
| `nw_s0_stinkclda` | Stinking Cloud | 43 POISON | **no** |
| `nw_s0_stinkcldc` | Stinking Cloud | 46 POISON | **no** |
| `x2_s0_cldbewlda` | Cloud of Bewilderment | 43 POISON | **no** |
| `x2_s0_cldbewldc` | Cloud of Bewilderment | 61 POISON | **no** |
| `nw_s0_cloudkilla` | Cloudkill | 68 DEATH, 82 NONE | **no** |
| `nw_s0_stormvenc` | Storm of Vengeance | 47 ELECTRICITY | **no** |
| `x2_s0_batttidea` | Battletide | 49 NEGATIVE | **no** |
| `nw_s1_dragfeara` | Dragon Fear | 73 FEAR | **no** |
| `cls_ing_bomb3a` | Alchemist's Fire | 13, 61 FIRE | **no** |
| `nw_s0_mindfoga` | Mind Fog | 58, 124 MIND_SPELLS | **no** |

`nw_s0_mindfoga` is the one to check first rather than convert: `MIND_SPELLS` is
a spell subtype, not an elemental one, and the engine may already treat it as a
spell save. If it does, it is the counter-example that tells us exactly where the
line is.

#### Group 2 — no subtype at all, so they lose twice

`SAVING_THROW_TYPE_NONE` or the argument omitted. These gain no specific
modifier in exchange for the spell modifiers they lose.

| Script | Area | Line | On the original list |
|---|---|---|:--:|
| `nw_s0_weba` | Web | 76, 89 | yes |
| `nw_s0_webc` | Web | 73, 85 | yes |
| `nw_s0_greasec` | Grease | 40 NONE | yes |
| `nw_s0_evardsa` | Evard's Black Tentacles | 156 NONE | **no** |
| `nw_s0_evardsc` | Evard's Black Tentacles | 162 NONE | **no** |
| `nw_s0_bladebara` | Blade Barrier | 57 | **no** |
| `nw_s0_bladebarc` | Blade Barrier | 76 | **no** |
| `nw_s0_entanglec` | Entangle | 59 | **no** |
| `cls_ing_bomb2a` | Gas bomb | 13, 78 | **no** |
| `cls_ing_bomba` | Root bomb | 13, 57 | **no** |
| `cls_ing_humia` | Humidifier | 13, 59 | **no** |

#### What the original list contained that is not here

`nw_s0_greasea` and `x2_s0_combust`. Grease's enter script makes no saving throw
at all. Combust is not an area script - it is an `ImpactScript` with delayed
`RunCombustImpact` calls, which is the second category this document asks to
inventory and which has not been walked yet.

#### Not walked yet

Saves inside functions reached by `DelayCommand` from a normal spell script.
A textual search for files containing both a save and a `DelayCommand` returns
fifty-four, which is a list of files and not of defects: it does not tell whether
the save is in the delayed path. `x2_s0_combust` is known to belong there; the
rest need reading. That is the inventory this document has asked for from the
beginning and it is still owed.

### The warlock scripts

`war_area.nss:108-112` is the module's own statement of the intended design, and
it is the same two-branch selection as `x0_i0_spells:776`:

```nwscript
if(nDAMAGETYPE == DAMAGE_TYPE_MAGICAL) ... SAVING_THROW_TYPE_SPELL);
else if(nDAMAGETYPE == DAMAGE_TYPE_FIRE) ... SAVING_THROW_TYPE_FIRE);
else if(nDAMAGETYPE == DAMAGE_TYPE_COLD) ... SAVING_THROW_TYPE_COLD);
else if(nDAMAGETYPE == DAMAGE_TYPE_ACID) ... SAVING_THROW_TYPE_ACID);
else if(nDAMAGETYPE == DAMAGE_TYPE_NEGATIVE) ... SAVING_THROW_TYPE_NEGATIVE);
```

**The subtype follows the damage.** That is deliberate and it is right, and it is
also exactly the trade this document is about: a warlock's fire blast keeps fire
modifiers and forgoes the spell ones.

The rest of the warlock scripts are not so considered:

| Script | Line | Subtype |
|---|--:|---|
| `war_utilities` | 337, 375, 387, 407 | **none**, four times |
| `war_cono` | 63 | NONE |
| `war_dominar` | 72 | MIND_SPELLS |
| `war_invisiblem` | 89 | none |
| `war_maldicion` | 59 | none |
| `war_polymorph` | 69 | none |
| `war_rafaga` | 86 | none |
| `war_tentaculosa` | 97 | none |

**`war_utilities` is the highest-leverage single file in this whole document.**
It is the shared helper the invocations call, its four saves carry no subtype,
and every invocation that goes through it inherits that.

### The school subsystem, and replacing it

`add_spell_dc.nss` is not alone. There are four scripts run through
`ExecuteScriptAndReturnInt`, all of them reading
`X2_L_LAST_SPELLSCHOOL_VAR` off whatever object they are handed, all of them
implementing the Shadow Weave feats:

| Script | Executed from | Line | What it decides |
|---|---|--:|---|
| `add_spell_dc` | `pb_nivellanzador.nss`, `GetChangesToSaveDC` | 380 | save DC |
| `add_spell_penetr` | `nw_i0_spells.nss`, inside `MyResistSpell` | 433 | spell penetration |
| `add_spell_dispel` | `x0_i0_spells.nss` | 1760 | dispel check |
| `set_damage_type` | `pb_nivellanzador.nss` | 386 | damage type |

**Each has exactly one execution site.** That is what makes this affordable: the
114 files that call `GetChangesToSaveDC` do not change at all. Four
`ExecuteScriptAndReturnInt` lines become four function calls, and the four
scripts are deleted.

The feats involved, counted in those files: 1354 Shadow Weave (ten checks), 1355
Tenacious Magic (three), 1356 Pernicious Magic (three), and 1358/1359/1360 Shadow
Defence (one each, currently living in `MySavingThrow` because the copy in
`add_spell_dc` is commented out).

#### `inc_spellschool.nss`

A new include, because these are ruleset rules about schools of magic and not
about effects or areas, and `inc_effects` already declined to absorb
`nostack_inc` for the same reason.

```nwscript
/// @brief The school of a spell, from spells.2da.
/// @param iSpellId A spells.2da row.
/// @returns A SPELL_SCHOOL_* constant, or -1 when the row names none.
///
/// This replaces X2_L_LAST_SPELLSCHOOL_VAR as the source of the answer. That
/// local is set and deleted by 382 files and read by four, and in an area script
/// it is read off the area object, which never had it set - which is why grease
/// and web get nothing from the Shadow Weave adjustment today.
int gsSPGetSpellSchool(int iSpellId);

/// @brief The saving throw DC change the schools rules make.
/// Shadow Weave gives the caster +1 in Illusion, Enchantment and Necromancy and
/// -1 in Evocation and Transmutation. Shadow Defence gives the target -1, -2 or
/// -3 against those same three schools.
int gsSPGetSchoolSaveDC(object oCaster, object oTarget, int iSchool);

/// @brief The spell penetration change. Pernicious Magic, +4 against a Shadow
/// Weave user, outside Evocation and Transmutation.
int gsSPGetSchoolPenetration(object oCaster, object oTarget, int iSchool);

/// @brief The dispel check change. Tenacious Magic.
int gsSPGetSchoolDispel(object oCaster, object oTarget, int iSchool);

/// @brief The damage type a caster's school rules impose, or the one given.
int gsSPGetSchoolDamageType(object oCaster, int iDamageType, int iSchool);
```

**Shadow Defence moves here from `MySavingThrow`.** It is a school rule and it is
currently in a save wrapper with 190 callers, where it reads the school off
`OBJECT_SELF` and therefore never fires for any area spell.

**The four wrappers keep their names and signatures.** `GetChangesToSaveDC`
stays in `pb_nivellanzador.nss` and calls `gsSPGetSchoolSaveDC` instead of
executing a script; `MyResistSpell` and the dispel site likewise. Nothing that
calls them changes.

#### What this buys beyond tidiness

- **The school stops depending on a local that nobody sets in area scripts.** It
  comes from the spells.2da row, which is always right and never forgotten.
- **Four script executions per save, per resist and per dispel become four
  function calls.** `ExecuteScriptAndReturnInt` loads and runs a compiled script;
  in an area heartbeat that is once per creature per six seconds.
- **`X2_L_LAST_SPELLSCHOOL_VAR` becomes dead.** 382 files set and delete it. They
  are not touched by this change and the pairs can be removed later, or never.

#### Related, and deliberately not merged with this

`nostack_inc.nss` owns numeric magnitudes and is out of scope here - see slice 6
step 3b in `documentation/rules/spell-effect-library.md`. It has its own open
  question, in
  [section 3 below](#3-negative-energy-burst-and-nostack_inc): NWNX's
NoStack plugin is pinned, switched off, and would replace 61 hand-maintained
spell ids with a default of "nothing stacks" plus a list of exceptions.

**The two share a shape and not a solution.** Both are membership lists somebody
has to remember to update. Whatever is decided about the school rules here does
not decide anything about that, and the two should not be moved in the same
change.

#### A file of its own, and the reason is arithmetic

**A separate include, `inc_spellschool.nss`, not conditionals inside each check.**

The school rules are consulted from **four** different places - the save DC,
spell penetration, the dispel check and the damage type. Written as conditionals
they are the same five feat tests written four times, which is how
`add_spell_dc`, `add_spell_penetr` and `add_spell_dispel` came to disagree with
each other in the first place: one writes its answer on the wrong object, one
puts two feats in an `else if`, one has its Shadow Defence block commented out
while a copy of it lives in `MySavingThrow`.

Four copies of a rule is the disease this whole plan is about. The precedent is
already in the repository: `nostack_inc` was left alone because it answers a
different question, and `inc_effects` was split from `inc_spellaoe` because
areas are not effects. Schools are not saves.

**And the module has already written half of it.** `cerr_newdispel.nss:356`:

```nwscript
string getSpellShool(int nSpellId){
    return Get2DAString("spells", "School", nSpellId);
}
```

The school read from the row rather than from a local, exactly as proposed - as a
private helper, in the dispel library, with a typo in its name. That is the
function `inc_spellschool` should expose, spelled correctly, so the four hooks
stop reading `X2_L_LAST_SPELLSCHOOL_VAR`.

### Dispelling: `cerr_newdispel` is the main road, and there are three side ones

Asked directly: is it the only thing that handles dispelling? **Almost.**

**It is the road.** `pbDispelMagic` and `pbDispelAoE` are called from eight
scripts and nothing else implements that logic:

    nw_s0_dismagic, nw_s0_grdispel, nw_s0_lsdispel, nw_s0_morddisj,
    mmf_s3_skills, war_devorar, war_disipar, spell_espasacri2

All four dispel spells, the shifter, both warlock forms and the sacred sword go
through it. It is 522 lines and it owns the sorting, the per-spell roll, the
summon handling and the area case.

**Three places bypass it** with a raw engine dispel effect:

| Script | Line | Call |
|---|--:|---|
| `x0_i0_spells` | 1683, 1694 | `EffectDispelMagicAll(nCasterLevel)` / `EffectDispelMagicBest(nCasterLevel)` |
| `ib_viltrans_sin` | 27 | `EffectDispelMagicAll(20)` |
| `vorticenigro1` | 15 | `EffectDispelMagicAll(20)` |

The engine's own dispel, which knows nothing about Tenacious Magic, about the
per-spell rolls in `cerr_newdispel`, or about the summon rules. The two with a
hardcoded `20` do not even use a caster level.

**Whether that is wrong is not established here.** `x0_i0_spells:1683` may be a
path nothing reaches; the other two are single-purpose scripts that may be meant
to be absolute. What is established is that **`cerr_newdispel` is not the only
answer to "how does this module dispel"**, so a plan that only fixes it will
leave three behaviours it does not govern.

**One thing it does own that this document already touched.** `pbDispelAoE` is
the function whose first-effect subtype check made every non-stacking area
undispellable until 2026-08-26 - see F18 in
`documentation/rules/spell-effect-library.md`. That was a bug in the caller, not
in this file, and it is fixed.

#### The Shadow Weave rules are not right either — read 2026-08-26

Reviewed before moving them, because moving a defect is worse than leaving it.

##### Tenacious Magic writes its answer on the wrong object

`x2_inc_switches.nss:584` reads the return value **from the object the script was
run on**:

```nwscript
int ExecuteScriptAndReturnInt(string sScript, object oTarget)
{
    ExecuteScript(sScript, oTarget);
    int nRet = GetLocalInt(oTarget, "X2_L_LAST_RETVAR");
```

`add_spell_dispel.nss` writes it somewhere else:

```nwscript
object oCaster = OBJECT_SELF;                    // the object it was run on
object oTarget = GetSpellTargetObject();
...
SetLocalInt(oTarget, "X2_L_LAST_RETVAR", nDP);   // written here, read from oCaster
```

The other two hooks write it on `OBJECT_SELF` and are correct.

**It works only when `GetSpellTargetObject()` happens to be the same object.**
`x0_i0_spells.nss:1760` calls it once per creature while computing that
creature's dispel resistance, and the area dispels - `nw_s0_grdispel`,
`nw_s0_lsdispel`, `nw_s0_dismagic` - walk every object in a shape. So Tenacious
Magic applies to at most the one creature that is also the spell's target and is
silently absent for everyone else in the area.

**And the message fires regardless.** `SendMessageToPC(oTarget, "Magia Tenaz: ...")`
runs whether or not the bonus is read, so a player can be told their dispel
resistance changed while it did not.

##### Shadow Defence was in the wrong file — fixed 2026-08-28

The school rule now lives in `inc_spellschool.nss` as
`gsSPGetShadowDefenceDCForSchool`. Both `gsSPSavingThrow` and the legacy
`MySavingThrow` adapter call it, and area consumers supply their creator and
spell row explicitly. Runtime validation remains owed.

##### Pernicious and Shadow Weave are mutually exclusive, perhaps by accident

`add_spell_penetr.nss` joins them with `else if`, so a caster holding both feats
gets `+4` and not `+5`. That may be intended. Nothing says.

##### Not read yet

`set_damage_type.nss` was counted and never opened. It is the fourth hook and it
is run from `pb_nivellanzador.nss:386`.

These are historical findings. The school hooks and the mutable school local
are retired; the intentional Pernicious/Shadow Weave exclusivity remains, and
the darkness half of Shadow Defence is still owed.

#### What must be settled before writing it

- **`set_damage_type` was not read** for this proposal, only counted. Whatever it
  does has to be understood before it is moved.
- **`add_spell_dispel` and `add_spell_penetr` were read only in their opening
  lines.** The full rules have to be transcribed, not summarised.
- **The three hooks are extension points by design** - each opens with a comment
  inviting new modifications to be added there. Replacing them with functions
  keeps that, but the comment has to move with the code so the next person adding
  a feat still finds the place.

### The function — implemented form, 2026-08-28

The early design used a damage type to choose the saving throw subtype and made
both the caster and DC optional. That was rejected during implementation:
poison, death, fear and mind saves are not derivable from a damage type, special
abilities carry custom base DCs, and an optional caster is exactly how an area
object reached `oSaveVersus`.

```nwscript
int gsSPSavingThrow(int iSave, object oTarget, object oCaster, int iSpellId,
                    int iBaseDC, int iSaveType, float fDelay = 0.0);
```

**The caller chooses the subtype explicitly.** An elemental save therefore
keeps its elemental resistances, while poison, death and mind saves keep their
own rules. The function adds the invested-rank Spellcraft bonus only when the
subtype is not already `SAVING_THROW_TYPE_SPELL`.

**The DC and school context are assembled in one place:**

```
iBaseDC
  + gsSPGetShadowWeaveDCForSchool(oCaster, iSchool)
  + gsSPGetShadowDefenceDCForSchool(oTarget, iSchool)
```

`iSchool` is resolved once from the spell row and its seven explicit blank-row
overrides. Since 2026-08-28, `inc_spellsave.nss` owns this policy and the one
low-level roll implementation. `MySavingThrow` retains its public signature but
is only a compatibility adapter into that core. No cache, local-variable handoff
or long-lived save state is introduced.

**The matching form for Reflex-adjusted damage is now implemented:**

```nwscript
int gsSPAdjustedDamage(int iDamage, object oTarget, object oCaster,
                       int iSpellId, int iBaseDC, int iSaveType);
```

It wraps `GetReflexAdjustedDamage` without replacing the engine's damage,
Reflex, Evasion or Improved Evasion decisions. The caster, spell row, base DC
and subtype are mandatory. `gsSPGetSavingThrowDC` is now the one DC assembly
used by both save entry points and adjusted damage; specialised subtypes receive
the same temporary Spellcraft compensation around the native call.

The damage type is deliberately not inferred inside this function. The caller
resolves its final damage type once, then `gsSPGetSaveTypeForDamage` maps acid,
cold, divine, electrical, fire, negative, positive and sonic damage to the
matching save subtype. Types without a direct mapping use the caller's explicit
fallback.

#### What each caller then looks like

    nw_s0_incclouda:54
      was  MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator(), fDelay)
      now  gsSPSavingThrow(SAVING_THROW_REFLEX, oTarget, GetAreaOfEffectCreator(), iSpellId, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, fDelay)

    nw_s0_weba:89
      was  MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF))
      now  gsSPSavingThrow(SAVING_THROW_REFLEX, oTarget, GetAreaOfEffectCreator(), iSpellId, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL)

The second also fixes the `oSaveVersus` defect for free, because the function's
signature makes the caster an argument instead of a default.

#### What it replaced

- `add_spell_dc.nss` is deleted; `inc_spellschool.nss` owns the rule.
- Area consumers no longer call `GetChangesToSaveDC(OBJECT_SELF)`.
- The hand-written school-local setup in acid fog and stinking cloud is
  deleted; the wrapper passes the exact current school with each save.
- The subtype selection in `war_area` and `DoMissileStorm` remains a later
  review; neither is a current consumer of this function.

### Composite death spells — current boundary, 2026-08-28

`nw_s0_weird` now sends both halves of its sequence through
`gsSPSavingThrow`: Will versus mind-affecting first, then Fortitude versus
death. Its existing mind and fear immunity gates remain before the first roll,
and the spell still applies damage only when the second save succeeds and death
only when it fails. This removes two compatibility-adapter calls without
changing the spell's control flow.

`nw_s0_phankill` exposed the remaining contract: its first save must distinguish
failure, success and immunity because only failure may continue to the
Fortitude save. `inc_spellsave` now owns that native three-state result as
`gsSPRollSavingThrowResult` and its spell-aware form
`gsSPSavingThrowResult`. The existing boolean entry points delegate to the same
roll and still map immunity to failure for ordinary effect application, so
their callers do not change behavior.

Phantasmal Killer uses the spell-aware result for its Will gate and the normal
boolean form for its Fortitude save. Its private 85-line `MySavingThrow2` copy
is deleted. Mind immunity still returns the distinct immune result and stops
the sequence; a failed Will save still proceeds through the separate fear
immunity check before Fortitude.

`nw_s0_prisspray` migrated only after the adjusted-damage route existed. Its
fire, acid and electricity outcomes now resolve the final Mastery of Elements
damage type once, derive the matching save subtype and call
`gsSPAdjustedDamage`. Its paralysis, confusion and death outcomes use
`gsSPSavingThrow`; poison remains the engine poison effect it already was.

This also closes two local inconsistencies. Paralysis used to omit a subtype and
now asks for a save against a spell, so there is no specific resistance to lose.
The outer impact delay is now calculated after each target is assigned instead
of once from an invalid object before the loop.

### Direct mind and fear spells — first homogeneous batch, 2026-08-28

Thirteen direct spells with the same contract now call `gsSPSavingThrow`:
Charm Animal, Charm Monster, Color Spray, Confusion, Daze, Dominate Animal,
Dominate Monster, Dominate Person, Fear, Mass Charm, Scare, Sleep and War Cry.
Each already used the engine spell DC plus `GetChangesToSaveDC(OBJECT_SELF)` and
made a Will save with either the mind-affecting or fear subtype. Their targets,
delays, Hit Die restrictions, spell-resistance checks, immunity checks and
spell-specific effects remain local to the spell.

This batch deliberately excludes similarly named calls in auras, feats,
artificer items, warlock invocations, encounters and persistent scripts because
they use custom DCs or non-spell execution context. It also excludes spells that
add their own scaling or situational DC modifier; those must pass their complete
base DC intentionally instead of being changed by a textual pattern.

### The plan

The engine gives the modifiers of one subtype. That forces a choice per save, and
the choice is not the same for both groups.

#### Group 2 first, because there is nothing to trade

Eleven area scripts and eight warlock ones pass `SAVING_THROW_TYPE_NONE` or omit
the argument. **They have no subtype to lose.** Passing
`SAVING_THROW_TYPE_SPELL` gains the spell modifiers, including Spellcraft, and
costs nothing at all.

No measurement, no compensation, no arithmetic of ours. One argument per call.

    web, grease, Evard's tentacles, blade barrier, entangle,
    the gas, root and alchemical bombs, the humidifier,
    war_utilities (four), war_cono, war_invisiblem, war_maldicion,
    war_polymorph, war_rafaga, war_tentaculosa

**This is the whole of the easy half and it should ship on its own**, so that
whatever it changes is attributable to it and not to the harder half.

#### Group 1 second, and it needs the measurement

Fifteen scripts pass a subtype that is worth keeping - fire, acid, poison,
electricity, negative, death, fear. Switching them to `SAVING_THROW_TYPE_SPELL`
would take away a defender's fire resistance items to give them Spellcraft, which
is not an improvement, it is a different game.

For these the subtype stays and the DC is reduced by the defender's own bonus:

```nwscript
GetSpellSaveDC() - (GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5)
```

in one library helper, not copied fifteen times. Lowering the DC by N is
identical to raising the save by N, so the fire save stays a fire save and the
Spellcraft arrives anyway.

**It cannot ship until the number is confirmed** against the nine scripts that
already ask for `SAVING_THROW_TYPE_SPELL` - see the validation section. If our
figure and the engine's differ, the same spell would grant different bonuses
depending on which script rolled it.

#### Before either: two checks that could shrink the work

- **`nw_s0_mindfoga` and `war_dominar` pass `MIND_SPELLS`.** That is a spell
  subtype, not an elemental one. If the engine already treats it as a spell save,
  both are correct as they stand and the boundary of this problem is narrower
  than it looks.
- **`x2_s0_combust`** is on the owner's list and is not an area script. It is the
  first known member of the delayed category, which is still not inventoried.

#### What is deliberately not changed

`war_area` and `x0_i0_spells`' `DoMissileStorm` already select by damage type and
are the pattern, not the problem. Traps keep `SAVING_THROW_TYPE_TRAP`.

### The rule, decided 2026-08-27

**One point of saving throw per five ranks the defender has actually invested in
Spellcraft. Intelligence and items do not raise it.**

In NWScript that is the third argument TRUE:

```nwscript
GetSkillRank(SKILL_SPELLCRAFT, oTarget, TRUE)  // invested ranks only
```

not

```nwscript
GetSkillRank(SKILL_SPELLCRAFT, oTarget)        // modified: ranks + Int + items
```

**This supersedes the rule decided on 2026-08-26**, which said the total, ranks
plus Intelligence plus items, and named the modified form as the one to use. The
reversal is the user's, taken on 2026-08-27 and implemented the same day in
`gsSPGetSpellcraftSaveBonus`. The earlier rule is recorded here only so that a
reader who finds it quoted elsewhere knows it was replaced and not merely
ignored.

It also puts this module's two other per-five-ranks counters and this one in
agreement: `x2_pc_umdcheck:691` and `guia_tasar:53` both pass TRUE.

The cost is an inconsistency that is accepted knowingly. The nine scripts that
already grant Spellcraft do it by asking the engine for
`SAVING_THROW_TYPE_SPELL`, and whatever the engine counts there is the engine's
business; if it counts the modified skill, a defender with Spellcraft from
Intelligence or from an item gets more against those nine than against the
twelve converted here. The engine's figure has still never been observed. When
it is, these twelve are what comes into line.

The divisor is `haks-2da/ruleset.2da:201`,
`SPELLCRAFT_NUM_RANKS_PER_SAVE_BONUS = 5`.

**This is not a 3.5 rule.** Spellcraft in 3.5 identifies spells, potions and
scrolls and gives no saving throw bonus at all. The bonus is NWN's own, so the
only authority for it is the engine, and the only way to read the engine is to
watch it.

**How it is validated: against the spells that already get it.** `x0_s0_sunburst`,
`nw_s0_sunbeam` and the planar bindings ask for `SAVING_THROW_TYPE_SPELL` and are
therefore given the engine's own figure. A defender whose ranks and total differ
widely - ten invested, twenty total through Intelligence and items - takes a save
against one of those, and the combat log's modifier says which the engine used.
Whatever the eight are changed to must produce the same number as those, because
the alternative is one spell granting different bonuses depending on which script
rolled the dice.

### The listed spells: keep the subtype, add the bonus

The requirement, stated plainly: **each of these keeps the saving throw it makes
today and gains the Spellcraft bonus a spell save would have given the
defender.** Not a swap to `SAVING_THROW_TYPE_SPELL` - that is proposal 6's
tradeoff and it is not what is wanted here.

#### The exact call sites

| Script | Line | Call as written | Subtype |
|---|--:|---|---|
| `nw_s0_greasec` | 40 | `MySavingThrow(REFLEX, oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay)` | none |
| `nw_s0_weba` | 76 | `MySavingThrow(REFLEX, oTarget, iCD)` | none |
| `nw_s0_weba` | 89 | `MySavingThrow(REFLEX, oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF))` | none |
| `nw_s0_webc` | 73 | `MySavingThrow(REFLEX, oTarget, iCD)` | none |
| `nw_s0_webc` | 85 | `MySavingThrow(REFLEX, oTarget, GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF))` | none |
| `nw_s0_delfirea` | 85 | `GetReflexAdjustedDamage(...)` | — |
| `nw_s0_inccloudc` | 65 | `GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator())` | fire |
| `nw_s0_acidfoga` | 50 | `MySavingThrow(FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay)` | acid |
| `nw_s0_acidfogc` | 60 | the same | acid |
| `x2_s0_combust` | 155 | `MySavingThrow(REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE)` | fire |

**`nw_s0_greasea` makes no saving throw at all.** The document lists it; the
enter script has none to correct. Whether it should have one is a separate
question.

#### The bonus, and where the module already states it

**The divisor is in this repository and is authoritative.**
`haks-2da/ruleset.2da:201` declares:

```
197  SPELLCRAFT_NUM_RANKS_PER_SAVE_BONUS              5
```

Five ranks to a point, set by the ruleset the server runs, not inferred.
`add_spell_dc.nss` also carries the figure in a commented line, but that one is
about the **caster's** Spellcraft raising the DC, which is a different rule.

**Confirmed 2026-09-02 to be the engine's own default, not a project setting.**
`Content/2da/vanilla/ruleset.2da` carries the same `5`. The project's
`ruleset.2da` differs from vanilla 8193.37 in fifteen rows and **none of them is
about spellcasting**: haste dodge AC 4→1, item max charges 50→250, turn
resistance affecting PCs 0→1, seven skill durations 4.5→8.5, hide-in-plain-sight
cooldown 0→6, epic weapon focus 2→1, flurry of blows to-hit −2→0, and three
appended character-generation colour rows. Nothing in `ruleset.2da` bears on
caster level either; recorded so nobody searches it again.

**What is still unresolved is the input, not the divisor.** `nwscript.nss:8411`
says `GetSkillRank` returns the modified rank unless `nBaseSkillRank` is TRUE -
"not including any bonuses from ability scores, feats, etc". Whether the engine
counts base ranks or modified ranks for this bonus decides between
`GetSkillRank(SKILL_SPELLCRAFT, oTarget)` and
`GetSkillRank(SKILL_SPELLCRAFT, oTarget, TRUE)`, and a character with high
Intelligence makes those differ. That needs a probe.

#### The correction

For each call above, subtract the target's bonus from the DC and leave everything
else alone:

```nwscript
nDC -= GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5;
```

Lowering the DC by N is arithmetically identical to raising the save by N, so a
fire save stays a fire save - Evasion still applies, fire-specific save
modifiers still apply - and a defender with fifteen ranks of Spellcraft is three
points better off, exactly as against a spell save.

**One place, not ten.** A helper in the library rather than the same division
copied into nine scripts, for the reason the effect identities are declared once:
the copies drift, and this document exists because a rule written in one place
and not another produced six spells that behave differently from the rest.

**What it reproduces and what it does not.** It reproduces the number. It does
not make the save *be* a spell save, so anything else keying on that
classification still sees a fire or acid save. Nothing in this module is known to
key on it, and that is worth confirming rather than assuming.

### A third symptom of the same cause: the caster-side hook runs on the area

Five of the calls above read `GetChangesToSaveDC(OBJECT_SELF)`. In an area of
effect script `OBJECT_SELF` is the **area object**, and that function is
`ExecuteScriptAndReturnInt("add_spell_dc", oCharacter)` - which asks
`GetHasFeat(1354, oCaster)` of whatever it was handed.

An area object has no feats, so the Shadow Weave adjustment - `+1` for Illusion,
Enchantment and Necromancy, `-1` for Evocation and Transmutation - **is always
zero** in `nw_s0_greasec`, `nw_s0_weba` and `nw_s0_webc`. It also reads
`X2_L_LAST_SPELLSCHOOL_VAR` off the same area object, which those scripts never
set.

So the same root cause has now produced three symptoms: the defender loses
Spellcraft, the defender loses Shadow Defence, and the caster loses Shadow Weave.
`GetAreaOfEffectCreator()` is the object those calls should be passing, and it is
already passed correctly two lines away in `nw_s0_acidfoga` and
`nw_s0_inccloudc`.

**`GetChangesToSaveDC(OBJECT_SELF)` appears in far more than these five scripts.**
An inventory of which of them run outside an `ImpactScript` belongs with the one
this document already asks for.

### What COW, the natives and NWNX offer — checked 2026-08-26

#### COW: nothing. It is not a reference here.

**Provenance.** `cow-scripts/` is the reference module's source, placed at the
repository root by the owner and ignored by `.gitattributes`/`.gitignore`, so
nothing below can be re-derived from a checkout of this repository. Line numbers
are from that working copy on 2026-08-26 and are recorded as such.

`cow-scripts/nw_i0_spells.nss:421` is the **stock BioWare `MySavingThrow`** - the
sanity clamp on the DC and three branches, and no project additions. No Shadow
Defence block, no Shadow Weave, no Spellcraft. Its area spells call it plainly:

    cow-scripts/nw_s0_weba.nss:86     MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC)
    cow-scripts/nw_s0_webc.nss:75     the same
    cow-scripts/nw_s0_greasec.nss:35  MySavingThrow(..., SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay)

**COW offers no solution.** What it does not have is PDB's Shadow Defence and
Shadow Weave symptoms, because it never added the DC layer those depend on. The
defender's Spellcraft loss is a different thing - it is engine behaviour, and if
the premise of this document holds, COW's plain area calls lose it exactly as
PDB's do. An earlier draft said COW "does not have this problem", which conflated
the two.

#### The natives: one hard rule PDB is breaking, and no way to ask for two subtypes

**The rule.** `FortitudeSave`, `ReflexSave` and `WillSave` carry the same note,
verbatim, at `nwscript.nss:7276`, `7288` and `7300`:

> *"If used within an Area of Effect Object Script (On Enter, OnExit,
> OnHeartbeat), you MUST pass `GetAreaOfEffectCreator()` into `oSaveVersus`!!"*

Five of the ten call sites listed above do not:

| Script | Line | What it passes as `oSaveVersus` |
|---|--:|---|
| `nw_s0_weba` | 76, 89 | nothing, so `OBJECT_SELF` - the **area** |
| `nw_s0_webc` | 73, 85 | nothing, so `OBJECT_SELF` - the **area** |
| `nw_s0_greasec` | 40 | `OBJECT_SELF` explicitly - the **area** |

`nw_s0_acidfoga`, `nw_s0_acidfogc` and `nw_s0_inccloudc` pass
`GetAreaOfEffectCreator()` and are correct. **The engine says this matters and
does not say what it costs**, which is the first thing to measure - it may be the
whole of the Spellcraft symptom for web and grease, or none of it.

**No native reports what Spellcraft contributes**, and none accepts two saving
throw subtypes: `nSaveType` is one `SAVING_THROW_TYPE_*` and there is no
combining form. Proposal 6's tradeoff is real and the engine offers no way round
it.

**One native worth knowing about before adding anything.**
`GetSavingThrowBonusLimit()` returns the cap on saving throw bonuses, default
**20**, and `SetSavingThrowBonusLimit` changes it for the running module. A
compensation applied as a DC reduction is not subject to that cap; the same
compensation applied as a bonus to the defender would be. That is an argument for
adjusting the DC rather than the save, beyond the arithmetic being identical.

#### NWNX: it can measure the tradeoff, and it cannot reclassify a save

**There is no saving throw event.** `NWNX_Events` exposes nothing for a save, so
there is nothing to intercept, adjust or reclassify. The plugin set cannot make a
save be two subtypes any more than the engine can.

**`NWNX_Creature_GetTotalEffectBonus` can price the tradeoff.**

```nwscript
int NWNX_Creature_GetTotalEffectBonus(object creature,
        int bonusType = NWNX_CREATURE_BONUS_TYPE_ATTACK, object target,
        int isElemental, int isForceMax, int savetype, int saveSpecificType, ...);
```

Its own remark: *"exposes the actual bonus value beyond a player's base scores to
attack, damage bonus, saves, skills, ability scores"*. Called twice on the same
target with `NWNX_CREATURE_BONUS_TYPE_SAVING_THROW` and two different
`saveSpecificType` values, it answers what proposal 6 currently has to guess:
**how much a defender loses by having a fire save turned into a spell save**, per
character, from their actual equipment and effects.

**It reports effect-derived bonuses, not skill-derived ones**, so it will not
report Spellcraft. That is a measurement tool for the decision, not a fix.

#### There are two mechanisms, not one

An earlier draft of this section said DC compensation was the only route. It is
not. `nwscript.nss:7348`:

```nwscript
effect EffectSavingThrowIncrease(int nSave, int nValue,
                                 int nSaveType=SAVING_THROW_TYPE_ALL);
```

A defender-side bonus can be applied as an effect, the save made, and the effect
removed - the save calls are synchronous, so the window is one statement wide.
That gives the defender a real bonus rather than a cheaper DC.

**Neither is obviously right and the differences are not cosmetic.**

| | DC reduction | `EffectSavingThrowIncrease` |
|---|---|---|
| Subject to `GetSavingThrowBonusLimit()`, default 20 | no | **yes** |
| Shows in the combat log as the defender's modifier | no | yes |
| Needs applying and removing around every save | no | yes, and a failure to remove leaves a permanent bonus |
| Interacts with `MySavingThrow`'s `fDelay` parameter | no | **yes, and badly** - the effect must survive the delay |
| Reproduces the engine's own arithmetic | yes | yes |

The `fDelay` row is the one that decides it for the calls that use it -
`nw_s0_greasec`, `nw_s0_acidfoga` and `nw_s0_acidfogc` all pass a delay, and an
effect applied now for a save that happens later has to be removed later still,
by something that cannot fail.

**Choose after probing both**, at and near the bonus cap, and record why. Not
before.

#### The `oSaveVersus` calls — fixed 2026-08-28

**Five** call sites - not four, as an earlier draft said - pass the area object
where all three save natives say `GetAreaOfEffectCreator()` must be passed:
`nw_s0_weba` at 76 and 89, `nw_s0_webc` at 73 and 85, and `nw_s0_greasec` at 40.

All five now use `gsSPSavingThrow`, whose caster and spell-id parameters have
no defaults. Migrating every current consumer found two additional direct area
calls in `nw_s0_cloudkilla` and `cls_ing_bomba`; those are fixed too. This does
not claim to explain the separate Spellcraft symptom: acid fog already passed
the correct creator and still reproduced that.

#### What must be measured before any of it

- **That the vs-spell classification really is absent outside an `ImpactScript`.**
  It is the premise of this whole document and it rests on play observation of
  six spells, which is evidence and not proof.
- **What passing the area instead of `GetAreaOfEffectCreator()` as `oSaveVersus`
  used to cost.** The invalid calls are fixed, but the engine does not document
  the symptom and the difference has not been measured in play.
- **What Spellcraft actually contributes** on this build. The module's own
  commented line says one point per five full ranks and that is the figure the
  correction above uses, but it was written for the caster side and nothing here
  confirms the engine gives a defender the same.
- **That the Shadow Defence reduction fires in play** for direct and migrated
  area saves. Source inspection proves the school-based block is live inside
  `MySavingThrow`; runtime validation is still owed.

**138 `MySavingThrow` call sites across 101 consumer files** - a raw search finds
140 occurrences in 101 files, two of which are the prototype and the definition
in `nw_i0_spells.nss` - plus 36 legacy direct `ReflexSave`, 26 `WillSave`, 18
`FortitudeSave` and 50 legacy direct `GetReflexAdjustedDamage` calls. Each native
save total excludes the one call owned by `inc_spellsave`. Whatever is decided,
it is not a small change, and the inventory this document already asks for is
the right first step.

### Proposed changes for later review

1. Separate the saving throw subtype from `nDAMAGETYPE` in `DoMissileStorm`.
2. Keep the two Isaac's missile storms as Force damage and classify their
   required Reflex saves as spell saves rather than fire saves.
3. Enable the required Reflex save for Ball Lightning.
4. Select the elemental saving throw subtype from the actual result returned by
   `ChangedElementalDamage`, so Elemental Mastery cannot leave a mismatched fire
   save on electrical, cold, acid, or sonic damage.
5. Audit all persistent, secondary, and delayed spell saves, starting with the
   six user-observed spells above. Do not limit the correction to Incendiary
   Cloud.
6. Decide how persistent and delayed spell effects should combine their
   original save subtype with save-versus-spell modifiers:
   - Using `SAVING_THROW_TYPE_SPELL` is the supported simple correction for
     Spellcraft and save-versus-spell modifiers, but it drops fire-specific save
     modifiers when the original subtype was fire. The same tradeoff applies to
     acid, electricity, cold, sonic, and other subtypes.
   - Exactly reproducing a direct spell save requires a separately reviewed
     solution that combines spell and subtype modifiers outside an
     `ImpactScript`. A single standard saving throw call cannot request both
     types.
7. Review whether `DoMissileStorm` should include the project's
   `GetChangesToSaveDC()` adjustment. Fireball currently includes it, while the
   shared missile-storm helper currently uses only `GetSpellSaveDC()`. This is a
   caster DC concern and is separate from the defender's Spellcraft bonus.

### Required validation

- Compare a target immediately below and above a five-point modified
  Spellcraft threshold while keeping its Reflex save unchanged.
- Confirm Firebrand reports a fire save and gains the expected Spellcraft bonus.
- Confirm Ball Lightning reports an electricity save, performs half-damage and
  Evasion processing, and gains the expected Spellcraft bonus.
- Confirm both Isaac's missile storms apply Force damage, require Reflex saves,
  and do not apply fire-specific save modifiers.
- Test Incendiary Cloud separately because its save runs from a persistent-area
  event rather than a spell `ImpactScript`.
- Reproduce and verify Grease, Web, Delayed Blast Fireball, Acid Fog, and every
  delayed Combust save using the same controlled Spellcraft thresholds.
- Produce a complete inventory of affected scripts before implementing fixes,
  so equivalent execution paths receive the same treatment.

### References

- [NWN Lexicon: saving throw types](https://nwnlexicon.com/SAVING_THROW_TYPE)
- [NWN Lexicon: GetReflexAdjustedDamage](https://nwnlexicon.com/GetReflexAdjustedDamage)
- [NWN Wiki: saving throws](https://nwn.fandom.com/wiki/Saving_throw)

---

## 2. Potion effect stacking

**Status:** the stacking is **fixed** as of 2026-08-26 - thirteen identities, both
directions. What remains open is three potions that share territory with
`nostack_inc`, fifty-six with no identity at all, twelve thrown poisons, and one
ruleset question about dispellability. Each is marked below.

### Why this is written down

`nw_s0_haste.nss` tags its effect link `"SPELL_ACELERAR"` and removes that tag
before applying a new one. The tag is not decoration: the trade potion system
grants the same benefit from a different script, and the tag is the only thing
the two have in common.

That mattered while deciding whether `gsSPApplyEffect` should tag with the spell
id by default. It must not. Two sources deliberately share one identity, and one
of them is not a spell.

### Closed 2026-08-26: thirteen identities, both directions

The stacking this document was opened for is fixed. Every one of the groups below
now works in **both** orders - drink then cast, and cast then drink - where before
only the movement-speed group did, and only by accident of somebody having
written its tag on both ends.

| Identity | Potion | Spell |
|---|---|---|
| Movement speed | Volátil (98), Agitada (45), Sidra de Pera | haste, mass haste |
| Acid shield | Corrosiva (97) | Mestil's Acid Sheath |
| Fire shield | Calorífica (100) | Elemental Shield |
| Magic shield | Oscura (94) | Death Armor |
| Sonic shield | Aullante (109) | Wounding Whispers |
| Poison saves | Férrea (4) | Ironguts |
| Damage resistance | de Aislamiento (9) | Endure Elements |
| Natural AC | Blanquecina (21) | Stone Bones |
| Regeneration | Reparadora (55) | Monstrous Regeneration |
| Deflection AC | de Barrera (61) | Shield, row 417 |
| Armour AC | de Desvío (67) | Mage Armor |
| Damage reduction | Polvorienta (72) | Stoneskin |
| Elemental resistance | Disipadora (74) | Protection from Elements |

**The rule that closed them.** An identity has one key per kind of source, and
every source removes the key it does not own: the spell owns its `spells.2da`
row and removes the potion's tag, the potion owns its tag and removes the spell's
row. Movement speed is the exception where no source has a usable row - three of
its five apply from an item activation, which the engine records as `-1` - so
there the tag is the only key and every source carries it.

**The specific defect this document was opened for is gone.** Sidra de Pera
consulted four spell rows and declined to apply, which could not see the potions
at all because they carry no row; it now replaces the whole identity like every
other source. Agitada, which had a one-direction refusal guard and no shared identity tag,
does too - it declined to apply while `SPELL_HASTE` was running and was blind to
the other four sources in either direction.

**Kept out on instruction:** `mmf_s3_skills.nss`, the shifter, which grants rows
1540, 1541 and 1542 - the same three benefits as three of the identities above -
and `sw_inc_vfx.nss`, a third effect-by-tag library under `src/nui`. Both are
recorded as absent in `src/shared/nss/inc_effect_ids.nss` so that nobody adds
them by accident.

**Enforced, not asserted.** `scripts/check_effect_identity.py` fails when a
source of a declared identity stops removing one of its keys, counted per call
site rather than per file - a file-level check passes on this exact defect,
because one `case` in `pb_potion_inc.nss` that does both would cover for every
other that only writes.

The full account is in `documentation/rules/spell-effect-library.md`, slice 6,
and the player-facing summary is in
`documentation/changelog/modulo/2026-08.md`.

### Still open

**Three potions.** Acústica (10), Consciente (70) and de Verdad (89). They share
territory with `nostack_inc.nss`, which owns numeric bonuses and is not being
touched: it already removes every other spell granting the same skill, from a
table of 61 rows across 17 skills, and 37 files go through it. What those three
still lack is an identity for what it does not cover - de Verdad's ultravision,
see-invisible and spell immunity, and Consciente's magical sight.

**Two defects found while reading them, not fixed.** `pb_potion_inc.nss` case 10
applies an `eLink` it never assigns in that branch - the two lines that would
build it are commented out - so its only real work is the `DoNoStackSkillBonus`
call beside it. Case 70 reads `eLink` inside its own construction. Changing what
either applies is a ruleset decision.

### The rest of the file has no identity at all

Counted again after the conversions of 2026-08-26: `pb_potion_inc.nss` makes
**118** raw `ApplyEffectToObject` calls and **15** through `gsSPApplyEffect`. The
fifteen are the identities closed above; the hundred and eighteen carry nothing.

Before that work the file made 133 raw calls, four of which were tagged by hand.

The remaining applications can be repeated, and can overlap any spell granting
the same bonus. Some of that is intended - a potion of healing has nothing to
avoid stacking with - and some is not. **Which is which has not been
established.** Nothing here claims the other potions are broken; it claims
nobody has looked.

Two smaller observations from the same read, neither acted on:

- `pb_mod_activate.nss:1038` builds `effect eLink = EffectLinkEffects(eLink,
  eSpeed);` - `eLink` is read inside its own declaration, before it holds
  anything.
- Several potion cases call `RemoveEffectsFromSpell` rather than the library,
  which is the same "remove by spell row" filter F4 describes.

### What is left to do, in order

1. **The three potions above**, once it is decided what identity their
   non-numeric effects should carry.
2. **The fifty-six with no identity.** Per potion, whether it has one worth
   naming. Most will not: a potion of healing has nothing to avoid stacking with.
3. **The twelve thrown poisons**, cases 129 to 140, which apply
   `DURATION_TYPE_PERMANENT` from a shared tail outside the switch with no
   identity and no owner. Not a stacking question - nothing else grants those -
   but the checker has to say whether they are in scope rather than omitting
   them, which is how the first survey reported 82 of 94 cases.

### The spell id can be written, and that is a later question

The reason the potions cannot be identified by spell row is that they apply
outside a spell script, so the engine records `-1`. That field is not read-only.

`NWNX_Effect_UnpackEffect` returns a `struct NWNX_EffectUnpacked` whose members
include `nSpellId`, alongside `oCreator`, `nCasterLevel` and `sID`
(`nwnxee/Plugins/Effect/NWScript/nwnx_effect.nss:78` and the struct above it).
Setting the field and calling `NWNX_Effect_PackEffect` produces an effect the
engine will report under whatever row was written. `NWNX_Effect_ReplaceEffect`
says the same thing from the other side: "Only duration, subtype, tag and spell
related fields can be overwritten" (line 89).

The plugin is available. `NWNX_EFFECT_SKIP=n` in both `config/nwserver.env` and
`config/nwserver-dev.env`, and `src/shared/nss/nwnx_effect.nss` is present. No
script in `src/` calls it today.

**Two things to settle before that route is taken, and one that settled itself.**

- ~~**A link is a tree.**~~ **Settled 2026-08-26, and in favour.** The native
  `SetEffectSpellId` propagates through a link: measured in play on darkness,
  web and the humidifier, where every member of every applied link came back
  carrying the row. See F15. This is no longer an obstacle, and it removes the
  NWNX unpack/pack route from the question entirely - the native is enough.
- **It is a different mechanism from the tag, not a replacement for it.** A spell
  row says "which spell". The movement-speed identity spans four sources and one
  of them is a potion, so the group would still need a row of its own to borrow -
  and borrowing `SPELL_HASTE` makes the potion dispellable and countable as haste
  everywhere else in the module, which is a ruleset decision, not a plumbing one.
- ~~**It puts NWNX on the path of every potion application.**~~ **Historical.**
  It was an argument against the unpack-and-repack route, and that route is gone:
  the native `SetEffectSpellId` does the same thing with no plugin involved. The
  library still takes no NWNX dependency and this question no longer asks it to.

**And it is no longer needed for the thirteen closed above**, which are solved by
tags and spell rows without NWNX and without making anything newly dispellable.
It remains a live question only for a potion that should genuinely count as its
spell everywhere - dispellable, visible to `GetHasSpellEffect`, countable by
anything that looks for that row. That is a ruleset decision and nobody has taken
it.

### Validation

**Owed, for the thirteen already closed.** Nothing has been played, and the
changelog entry says so under *Still owed*. For any pair
in the table: drink the potion, cast the spell, and confirm one set of bonuses
rather than two - then the other order. Sidra de Pera over the Volátil is the
clearest, because it used to give both. The test is also written in
`documentation/changelog/modulo/2026-08.md`, which is where it will be ticked off.

**Done.** Focused compilation of every script changed, per `AGENTS.md`, and both
static checkers on every commit.

### Related

- `documentation/rules/spell-effect-library.md`, F4 and Slice 6.
- [Negative Energy Burst stacking](#3-negative-energy-burst-and-nostack_inc), the same
  class of question for a different spell.

---

## 3. Negative Energy Burst, and nostack_inc

Reported from testing. **Investigated, not fixed.**

> The system this spell is one symptom of is described in
> [`../rules/bonus-stacking.md`](../rules/bonus-stacking.md) — how the two
> halves of `nostack_inc.nss` work, every place stacking is currently
> allowed, and what the disabled NWNX plugin would offer instead. Read that
> first if the question is the policy rather than this spell.

> Spell: Explosión de Energía Negativa.
> Al emplear el conjuro de varita, pergamino o caster, sigue stackeando hasta el
> infinito la fuerza a los personajes no-muertos.

---

### What the spell does to an undead target

`src/shared/nss/nw_s0_negburst.nss:91-103`. An undead caught in the burst is
healed instead of damaged, and then given Strength:

```nwscript
if (PB_Race_GetIsUndead(oTarget))
{
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST, FALSE));
    eHeal = EffectHeal(nDamage);
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget));
    DelayCommand(fDelay, DoNoStackAbilityBonus(OBJECT_SELF, oTarget, nStr, ABILITY_STRENGTH, 999999.9));
}
```

`nStr` is `casterLevel / 4`, minimum 1.

### Why it stacks

`DoNoStackAbilityBonus` (`src/shared/nss/nostack_inc.nss`) is supposed to make
this self-cancelling. It clears the previous bonus before applying the new one:

```nwscript
RemoveMagicAbilityBonus(oTarget, nAbility);
```

which for Strength calls, among others:

```nwscript
RemoveEffectsFromSpell(oPC, 370);  // Explosion de energia negativa
```

and `RemoveEffectsFromSpell` (`src/shared/nss/nw_i0_spells.nss`) matches on the
effect's spell id:

```nwscript
if (GetEffectSpellId(eLook) == SpellID)
    RemoveEffect(oTarget, eLook);
```

**The bonus never carries spell id 370, so nothing ever matches it.** The
installed `nwscript.nss` says of `GetEffectSpellId`:

> *Get the spell (SPELL_*) that applied eSpellEffect.*
> *Returns **-1** if eSpellEffect was applied **outside a spell script**.*

The bonus is applied from inside `DelayCommand(fDelay, DoNoStackAbilityBonus(…))`.
A delayed command runs later, off the object's queue, outside the spell script
that scheduled it — so the effect is tagged `-1` and the removal pass, which
looks for `370`, walks straight past it. Every cast adds one more.

#### The differential evidence

`DoNoStackAbilityBonus` has **25 call sites**, and only **two** wrap it in a
`DelayCommand`:

| Script | Spell | Delayed? |
|---|---|:-:|
| `nw_s0_negburst.nss` | Explosión de Energía Negativa | **yes** |
| `nw_s0_auravital.nss` | Aura de Vitalidad | **yes** |
| the other 23 — bull's strength, cat's grace, divine power, blood frenzy, the ioun stones… | | no |

One of the two delayed ones is the spell being reported. That is what makes the
diagnosis more than a reading of the manual.

#### The falsifiable prediction

**Aura de Vitalidad should stack in exactly the same way**, on Strength,
Dexterity and Constitution at once, since it is the other delayed caller
(`nw_s0_auravital.nss:63-65`). If it does not, this diagnosis is wrong and the
cause is elsewhere. It is the cheapest test available and it should be run
before anything is changed.

### Two other things found in the same file

**The duration is 11.6 days.** `999999.9` seconds, and this is the only one of
the 25 call sites with a hardcoded number rather than a real spell duration:

| Call site | Duration |
|---|---|
| `nw_s0_negburst.nss` | `999999.9` |
| everything else | `fDuration`, `RoundsToSeconds(…)`, `TurnsToSeconds(…)`, `HoursToSeconds(…)`, `3600.0` |

Even with the stacking fixed, one burst would buff an undead for a week and a
half. Whether that is intended is a design question, not a defect — but it is
almost certainly why the report says *"hasta el infinito"* rather than
*"durante un rato"*.

**The `fDelay` ordering was fixed on 2026-08-29.** It was declared
uninitialised, used by the saving throw, and assigned only afterwards:

```nwscript
if(MySavingThrow(SAVING_THROW_WILL, oTarget, …, fDelay))   // line 83
…
fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;   // line 88
```

The first target therefore used `0.0`, and every later target reused the
previous target's distance. Commit `1b3368a2e` moved the distance calculation
before the central save, so feedback now uses the current target. This was
cosmetic and did not alter the still-pending stacking or duration decisions.

### The decision, taken 2026-08-23

> *"si tu eres un vampiro por ejemplo, o un tumulario o no muerto en general, te
> spamean el hechizo y tu fuerza sube y sube y sube… esto deberia anular el bono
> anterior siempre, tomar el mas alto."*

**Required behaviour: never add, always replace, and keep the larger of the
two.** A second cast must not raise the total, and a weaker cast must not lower
what a stronger one already gave.

That second half is not what the code does today, and it is not covered by
simply removing the `DelayCommand`. `DoNoStackAbilityBonus` already takes the
higher of spell-and-item — `nModifier -= sItem.nScore` — but between two
*spells* it wipes and replaces unconditionally:

```nwscript
RemoveMagicAbilityBonus(oTarget, nAbility);   // removes whatever was there
… ApplyEffectToObject(… EffectAbilityIncrease(nAbility, nModifier) …);
```

So once the stacking is fixed, a level-8 caster spamming the burst at a vampire
would **drop** the Strength a level-20 caster had given it, from +5 to +2. Right
now the delay bug hides that, because nothing is ever removed.

#### What makes "the highest" possible

Reading the magnitude of an ability bonus already on the target needs
`GetEffectInteger(effect, nIndex)`, which the installed `nwscript.nss` does
carry:

> *Get the integer parameter of eEffect at nIndex. nIndex bounds: 0 >= nIndex < 8.*
> ***Some experimentation will be needed to find the right index.***

So the comparison is implementable, but **the index is not documented and has to
be probed in game** before anything is written against it. For
`EffectAbilityIncrease` the ability and the amount are expected at indices 0 and
1; that is the guess to confirm, not a fact to build on.

Where it belongs is `DoNoStackAbilityBonus` itself, so all 25 spells gain it at
once — which is also why it is high risk: bull's strength, cat's grace, divine
power, blood frenzy and the six ioun stones all run through that one function.

### The bigger question: NWNX already does this

`nostack_inc.nss` was written before NWNX:EE had a NoStack plugin. The plugin is
pinned in this repository at `nwnxee/Plugins/NoStack/` and it is **switched
off**: `NWNX_NOSTACK_SKIP=y` in both `config/nwserver.env` and
`config/nwserver-dev.env`. Nothing in `src/` calls it; only its header sits
there unused.

Its modes, from `nwnxee/Plugins/NoStack/README.md`, set per bonus family through
`NWNX_NOSTACK_ABILITY`, `_SKILL`, `_SAVINGTHROW` and `_ATTACKBONUS`:

| Value | Behaviour |
|---:|---|
| 0 | vanilla, everything stacks |
| 1 | nothing stacks at all — **only the highest effect is used** |
| 2 | the highest item effect **and** the highest spell effect, one of each |
| 3 | only item effects are stopped from stacking; spells stack as usual |
| 4 | per-type, with the type set per spell by `NWNX_NoStack_SetSpellBonusType()` |

**Mode 1 is, in one environment variable, the behaviour asked for in this
report**, and it applies to every spell on the server rather than the 61 spell
ids somebody remembered to type.

#### The plugin's own README confirms the diagnosis

Independently of anything reasoned above:

> *This is needed because scripted effects, unless created from a spellscript,
> **always have an INVALID_OBJECT creator and a spellId of -1**.*

That is the same mechanism this document blames for the stacking, written by the
people who wrote the plugin.

#### What the hand-rolled version actually costs

`src/shared/nss/nostack_inc.nss` is **1231 lines and 45 public functions**, and
the whole no-stacking behaviour rests on **61 hardcoded spell ids** across 85
`RemoveEffectsFromSpell` calls. A list like that is only ever as good as the last
person to remember it, and it is already behind:

**Eleven spells apply `EffectAbilityIncrease` and appear in none of the lists**,
so nothing ever cancels them and nothing they touch is cancelled by them:

| Id | Spell |
|---:|---|
| 63, 69, 96, 128 | Gate and the three planar bindings |
| 307 | Barbarian Rage |
| 363 | Awaken |
| 380 | Battle Mastery |
| 562 | AuraOfGlory_X2 — while its sibling at 429 *is* listed |
| 1329 | Frenzy |
| 1333 | Defensive Stance |
| 1418 | Infusion Elixir, the Artificer's |

And the labels have drifted from the ids they sit on: the entry for `429` is
commented *"Aura de virtud"*, but 429 is `AuraOfGlory` in `spells.2da`.

This is the shape of the problem the report is one symptom of. Fixing the burst
fixes the burst.

#### The choice, and why it is mode 4

**Mode 1 is wrong for this server.** Plenty of things are *meant* to stack:
heroism and greater heroism, listen and spot, the potions the alchemy trade
makes and their extra bonuses, and the burst itself once. Mode 1 would flatten
all of that.

**Mode 4 is the one that fits.** Types are assigned per spell with
`NWNX_NoStack_SetSpellBonusType(spellId, type)`, and the rule is:

> *Effects of different types stack with each other, but only circumstance
> bonuses stack with effects of the same type.*

So the burst gets a non-circumstance type and stops stacking with itself, while
heroism keeps a type of its own and goes on stacking with everything else. It is
the plugin's version of what `nostack_inc.nss` was hand-built to do — except
maintained by the engine instead of by a list of 61 numbers.

#### The trap in mode 4, and it is ours

The plugin classifies **by spell id**. An effect that carries `-1` — every effect
applied from a script that is not a spell script — cannot be classified at all.
It falls into one bucket governed by a single switch:

> `NWNX_NOSTACK_SEPARATE_INVALID_OID_EFFECTS`: *set this to true if you are
> adding effects through scripts that you want to stack with each other.*

Two consequences, and both matter here:

**The potions live in that bucket.** `pb_potion_inc.nss` applies its effects from
an item-activation script, so all 58 of them carry `-1`. With the switch off
they would stop stacking with each other; with it on they all stack freely.
There is no middle ground without the harder route the README describes:

> *if you want to control each of the scripted effect types you will need to
> unpack the effect, set a valid spellId and use `SetSpellBonusType()`. The
> spellId has to be a valid spell, so either reuse one of the existing spells
> that don't give a bonus effect or add a dummy spell to your spells.2da.*

**The burst is in that bucket too, and this is the important part.** Its Strength
bonus is applied from inside a `DelayCommand`, so it carries `-1` as well.
**Turning the plugin on would not fix it.** The plugin would see an unclassified
scripted effect, not spell 370, and with the switch on — which the potions need
— it would stack exactly as it does today.

So **option 1 below is a prerequisite of route B, not an alternative to it**.
The bonus has to leave the `DelayCommand` before anything, plugin or include, can
recognise it as spell 370.

#### One more thing to check before enabling

`NWNX_NOSTACK_IGNORE_SUPERNATURAL_INNATE` governs the effect type used by the
Race, SkillRanks and Feat plugins. All three are enabled here
(`NWNX_RACE_SKIP=n`, `NWNX_SKILLRANKS_SKIP=n`, `NWNX_FEAT_SKIP=n`) and all three
are called from `src/`. Whatever they grant would come under the new stacking
rules unless that switch says otherwise.

#### The shape of it: the list inverts

`nostack_inc.nss` is a **list of what must not stack** - 61 spell ids across 85
`RemoveEffectsFromSpell` calls, maintained by hand, and only ever as complete as
the last person to add a spell remembered to make it.

The plugin is the other way round. `NWNX_NOSTACK_ABILITY=1` says **nothing
stacks**, for every spell on the server, including the ones nobody has written
yet. What is then needed is not a list of what must not stack; it is a list of
**exceptions** - the cases that genuinely should, declared through
`NWNX_NoStack_SetSpellBonusType` in mode 4.

That inversion is the argument, more than the line count. A default-deny list is
wrong when it is incomplete in the direction of *permitting* something, and an
exception list is wrong when it is incomplete in the direction of *forbidding*
something. The second failure is visible the moment somebody notices a spell no
longer stacking; the first is invisible until somebody exploits it, which is how
the negative energy burst came to be reported.

**It is the same defect this repository keeps finding in a different costume.**
A membership list somebody has to remember to update: the seven removals copied
into three guards for the movement-speed identity, `X2_L_LAST_SPELLSCHOOL_VAR`
set and deleted in 382 files and read off the wrong object in area scripts, the
`@sources` lines in `inc_effect_ids.nss` that a new source is never added to.
Each one was written correctly and each one drifted.

**Nothing changes today.** `NWNX_NOSTACK_SKIP=y` stays, `nostack_inc` stays, and
this is recorded so that the decision, when it is taken, is taken as a whole and
not one spell at a time.

#### What route B actually involves

Not one variable. In order:

1. Take the bonus out of the `DelayCommand`, or nothing else works.
2. Decide `NWNX_NOSTACK_ABILITY`, and whether `_SKILL`, `_SAVINGTHROW` and
   `_ATTACKBONUS` follow.
3. Decide the two defaults, `_SPELL_DEFAULT_TYPE` and `_ITEM_DEFAULT_TYPE`.
4. **Classify the spells that must not take the default.** A module-load script
   calling `NWNX_NoStack_SetSpellBonusType` once per spell — which does not
   exist yet, and is where the design work is.
5. Decide the two switches above.
6. Retire `nostack_inc.nss` gradually — its equip and unequip half cannot keep
   running alongside the plugin.

**A. Patch the custom include** stays the small, contained, reversible answer to
the report in front of us. **B is a project**, and the burst is one symptom of
why it might be worth doing.

### Options for the fix

Not chosen; this document does not implement anything.

Two of the three are now required rather than optional, given the decision
above.

1. **Apply the bonus outside the delay** — `nw_s0_negburst.nss`, and
   `nw_s0_auravital.nss` with it. Call `DoNoStackAbilityBonus` directly, as the
   other 23 call sites do, and keep only the heal and the visuals delayed. This
   is what stops the stacking. Smallest possible change and it makes the spell
   match the pattern that demonstrably works.
2. **Keep the larger of the two bonuses**, inside `DoNoStackAbilityBonus`. Read
   what is already on the target with `GetEffectInteger`, and if it is bigger
   than what this cast would give, leave it alone and tell the caster. This is
   what stops a weak cast undoing a strong one. Touches a file 25 spells depend
   on, and needs the index probed first.
3. **Give it a real duration.** `999999.9` is indefensible whichever route is
   taken.

Order matters: 1 alone leaves the downgrade, 2 alone leaves the stacking. Both
are needed for the behaviour asked for.

### Validation required before implementing

- Cast the burst on an undead character twice and read the Strength score
  between casts.
- Do the same with Aura de Vitalidad, to confirm or refute the diagnosis.
- Confirm from wand, from scroll and from a caster, since the report names all
  three and the caster level, and therefore `nStr`, differs between them.
- **Probe the `GetEffectInteger` index** on a live ability bonus before writing
  option 2 against it. The engine's own comment says it has to be found by
  experiment.
- After any fix: cast twice and confirm the bonus replaces rather than adds,
  that a single cast still buffs at all, and that a **weaker** caster following a
  stronger one leaves the higher bonus standing.

---

## 4. Mind Fog: the repeated save

Status: **taken and reversed on 2026-08-31.** It was implemented as this section
proposed and the owner reversed it the same day: in a persistent world a single
successful save ends the spell's usefulness for the rest of a fight, and the fog
should behave like every other area in this module. Mind Fog rolls every tick.

What survives is the capability, not the change. `gsSPAoEMarkSaved` and
`gsSPGetAoEHasSaved` in `inc_spellaoe` record a once-per-area saving throw on the
area object, keyed by object rather than by name. Nothing uses them. They are
there for a spell that genuinely wants that rule.

The "why it is not taken" reasoning below was right and is restored as current
policy.

### What the SRD says

> *"Creatures in the mind fog take a -10 competence penalty on Wisdom checks and
> Will saves. (A creature that successfully saves against the fog is not affected
> and need not make further saves even if it remains in the fog.) Affected
> creatures take the penalty as long as they remain in the fog and for 2d6 rounds
> thereafter."*
>
> — <https://www.d20srd.org/srd/spells/mindFog.htm>, checked 2026-08-25

### What the module does

`nw_s0_mindfoga.nss` carries an internal `HeartBeat` re-armed every six seconds.
When the creature has no current penalty it calls `MySavingThrow` again. A
creature that saves is therefore rolled again next round, and the round after,
until it fails.

*Save or be affected* becomes *you will be affected, eventually*. Against players
standing in a fog for a fight, that is a materially stronger spell than the one
the SRD describes.

The lingering `2d6` rounds after leaving is **not** part of this: the SRD
confirms it, and the implementation matches.

### If it is taken

The mark for "this creature already saved" belongs on the **area object**, which
already tracks its occupants with
`SetLocalObject(OBJECT_SELF, GetName(oTarget), oTarget)`. State owned by the area
dies with the area. Putting it on the creature would repeat the wall of fire
counter, which is documented in
[`../rules/spell-effect-library.md`](../rules/spell-effect-library.md) as the
mistake this project keeps making.

Roughly two lines in `HeartBeat`.

### Why it is not taken

The owner's standing position: not every 3.5 spell survives literal translation
into a persistent world, and a spell keeps the behaviour it has unless changing
it is the task. Changing it is not the task.

---

## 5b. Warlock and artificer, read against each other — 2026-08-30

The plan required these two be read together before either was touched, because
they share `war_utilities`, `x0_i0_spells` and the damage-type selection, and
each section was written as if its class were alone. That reading is done and
**the premise is mostly wrong**. What is genuinely shared is small; what is
genuinely coupled is something else entirely.

### What they actually share

**One function.** The artificer uses exactly `ActionRepel` from `war_utilities`,
at three call sites: two in `cls_ing_item1`, one in `cls_ing_item2`. It is a
knockback helper that moves a creature. It touches no DC, no save, no essence and
no damage type.

`cls_ing_item4` includes `war_utilities` and calls nothing from it at all.

**Not the damage-type selection.** Neither family calls
`ChangedElementalDamage`: zero `war_*` files and zero `cls_ing_*` files. That
selection is Mastery of Elements, which belongs to the archmage, and the plan
already says the archmage shares nothing with these two.

**Not `x0_i0_spells` in any meaningful sense.** Most of the module includes it.
Sharing it does not couple two classes any more than sharing `nwscript.nss` does.

So the two can be worked separately, and in fact already were: the artificer
family was migrated on 2026-08-30 without `war_utilities` being touched.

### What is actually coupled, and it is not the two classes

`war_area` matches its save subtype to its damage type by hand, in five branches:
magical to `SAVING_THROW_TYPE_SPELL`, and fire, cold, acid and negative each to
their own. That is the pattern this whole plan calls correct, arrived at
independently.

It is also the thing that leaves the warlock without a route. The four elemental
branches take the defender's Spellcraft away, exactly as every other elemental
save did before this work, and the warlock cannot use either existing route to
get it back:

- `gsSPAdjustedDamage` restores Spellcraft but adds Shadow Weave and Shadow
  Defence, which a warlock invocation must not have. Its difficulty is
  `GetWarlockSpellDC`, not a spell DC.
- `gsSPRollAdjustedDamage` correctly adds no school policy, and correctly adds no
  Spellcraft either, because it was built for things that are not spells at all.

**The gap is a third shape: a caller-owned difficulty that still deserves the
Spellcraft compensation.** An invocation is a spell-like ability, so a defender's
Spellcraft arguably should count against it; a trap's or an encounter's DC
arguably should not. Deciding that is the first task of section 5, ahead of any
of its errata, because it determines what `war_area`, `war_cono` and the four
`AplicarDoT` saves migrate to.

Nothing needs building before that decision. If the answer is yes, the shape is a
Spellcraft flag on `gsSPRollAdjustedDamage` and `gsSPRollSavingThrow`; if no, the
warlock uses them as they stand.

### Two defects in the warlock DC path, found by this reading — FIXED 2026-08-30

Both were in `war_utilities` and neither was in section 5's existing list. Both
are repaired; the descriptions below are kept because they say what to look for
elsewhere. `GetWarlockSpellDC` now takes Charisma from the creature it is given,
and `AplicarDoT` now receives the warlock and passes it through its ticks. No
caller's behaviour changes, since every current one passes the same creature both
ways.

**`GetWarlockSpellDC` ignores its own parameter for Charisma.** The function takes
`oCreature`, uses it for the essence local and the feat check, and then finishes:

```nwscript
return 10 + nSpellLevelBonus + nAptitudeBonus + GetAbilityModifier(ABILITY_CHARISMA);
```

with no object, so the Charisma modifier comes from `OBJECT_SELF`. Every current
caller happens to pass `OBJECT_SELF` or nothing, so no live path is known to
differ. It is a parameter that lies rather than a bug that fires, and the next
caller that passes a different creature gets a silently wrong DC.

**`AplicarDoT` never receives the caster.** It declares `object oPC =
OBJECT_SELF;` and calls `GetWarlockSpellDC(OBJECT_SELF, ...)`, while its only
caller `AjusteEsencia` does take an `oPC` parameter and honours it for the
essence lookup. So the essence is read from one creature and the difficulty from
another whenever those differ. `x2_s3_onhitcast:84` passes `oSpellOrigin`, which
is `OBJECT_SELF` at line 55, so again no live divergence is known - and again the
inconsistency is one caller away from mattering.

### What this changes about the order of work

- Sections 5 and 6 do not block each other and never did. Section 6's artificer
  work is largely done.
- Section 5's first task is the Spellcraft decision above, not its errata list.
- The two `war_utilities` defects belong in section 5's Implementation Defects
  and are recorded here because that list was written before this reading.
- `cls_ing_item4`'s unused include is harmless and worth removing whenever that
  file is next opened for another reason.

## 5. Warlock errata

Status: pending review. None of the changes described here are currently
implemented.

### Scope

This document lists differences between the published Warlock class rules and
the behavior implemented in `src/shared/nss/war_*.nss`, plus implementation
defects found during the same review. The implemented behavior is described in
[the Warlock review in this document](#5-warlock-errata).

Each item states the published rule, the implemented behavior with its
evidence, and the decision required. No item should be implemented before the
intended rule is confirmed, because several of them change live class balance.

### Published Rule Versus Implementation

#### 1. Dark Wall of Fire damage does not match the published 8d6

Published rule: "causing 8d6 but half of the wall damage comes from the
supernatural power (magical damage)".

Implemented (`war_wallfirea.nss:82-83` on entry, `:24-25` per tick):

```
Entry:  2d6 + (Warlock level / 2) fire  +  2d6 + (Warlock level / 2) magical
Tick:   1d6 + (Warlock level / 2) fire  +  1d6 + (Warlock level / 2) magical
```

| Warlock level | Entry average | Per-round average | Published average |
|---------------|---------------|-------------------|-------------------|
| 12 | 26 | 19 | 28 |
| 16 | 30 | 23 | 28 |

The 8d6 value appears nowhere in the script. The entry only reaches the
published average from roughly level 14; the sustained damage never reaches it.
For comparison, the generic Wall of Fire (`nw_s0_wallfirea.nss:20`, `:80`)
applies `4d6 + caster level` on entry and on every tick.

Decision required: is the published 8d6 the intended value, is the current
level-scaling formula the intended value, or should the tick be raised to match
the entry dice?

#### 2. Hellrime Blast applies -4 Dexterity, not -2

Published rule: "-2 Dexterity / Reflex during 10 turns".

Implemented (`war_utilities.nss:371`): `EffectAbilityDecrease(ABILITY_DEXTERITY, 4)`
with a **Fortitude** save, not Reflex.

Two separate mismatches: the magnitude and the saving throw category.

Decision required: correct the script, or correct the published text.

#### 3. Essence replaces the invocation DC instead of capping it

`GetWarlockSpellDC()` (`war_utilities.nss:173-181`) replaces the default
`Innate + 1` bonus with a fixed per-essence value for spells 1335, 1337, 1344,
1346, 1347 and for Hideous Blow:

| Essence | Bonus | Effect on Eldritch Cone (default 7) | Effect on Eldritch Doom (default 9) |
|---------|-------|-------------------------------------|-------------------------------------|
| Brimstone / Hellrime | 5 | **-2 DC** | **-4 DC** |
| Caustic / Repelling | 7 | no change | -2 DC |
| Utterdark | 9 | +2 DC | no change |

A player who activates a lesser-tier essence therefore weakens their
higher-tier shapes. `war_area.nss:108-112` already works around this by passing
`bIgnorarEsencia = TRUE` for its Reflex damage save, which suggests the
replacement was not intended as a downgrade.

Decision required: should the essence value act as a floor
(`max(Innate + 1, essence value)`) rather than a replacement?

#### 4. Devour Magic and Voracious Dispelling are nearly identical below level 20

Published rules present Devour Magic as the stronger effect, and it costs a
greater invocation slot while Voracious Dispelling costs a lesser one.

Implemented:

| | Voracious Dispelling (`war_disipar.nss`) | Devour Magic (`war_devorar.nss`) |
|---|---|---|
| Tier | Lesser | Greater |
| Dispel level cap | 15 (`:48`) | 20 (`:62`) |
| Effective check at Warlock 16 | 15 | 16 |
| Extra effect | `EffectDamage(caster level, DAMAGE_TYPE_MAGICAL)` | `EffectTemporaryHitpoints(caster level)` for 60s |
| Dispel routine | `pbDispelMagic` | `pbDispelMagic`, identical arguments |

At the practical level ceiling the greater invocation buys `+1` on the dispel
check. The published Devour Magic text also says the temporary hit points are
granted "per dispelled target"; the script applies one
`EffectTemporaryHitpoints` per target that carried magic, and multiple
temporary hit point effects do not accumulate.

Decision required: differentiate the two invocations, or move Devour Magic to
the lesser tier.

#### 5. Voracious Dispelling damage ignores its own caster-level cap

`war_disipar.nss:43` builds the damage effect from `nCasterLevel` **before**
the clamp at `:48` reduces it to 15. The dispel check is capped at 15 while the
damage keeps the uncapped caster level.

Decision required: confirm whether the damage was meant to be capped as well.

#### 6. Path of Shadow does not restore hit points

Published rule: "as Greater Teleport, without failure chance, and it restores
half of your hit points when travelling".

`war_teleport.nss` sets `TELEPORTAR`, `NIVEL_LANZADOR_TELEPORTAR` and
`RUTASOMBRAS`, then opens the `conj_teleport` conversation. No healing occurs
in this script.

Decision required: confirm whether the healing exists in the `conj_teleport`
conversation or its destination script. If it does not, the effect is missing.

#### 7. Walk Unseen duration is level-based, not 24 hours

Published rule: "the invoker becomes invisible for 24h".

Implemented (`war_invi.nss:68`): `HoursToSeconds(GetTotalCasterLevel())`,
doubled at `:63` when the caster has feat 1357 (Insidious Magic). A Warlock 16
gets 16 hours, or 32 with the feat.

Decision required: align the text or the script. The same applies to
Darkness / Aliento de la noche (`war_niebla.nss:53`), whose in-file comment
states "1 turn per level" while the code applies hours per level.

#### 8. Retributive Invisibility concealment outlives its invisibility

`war_invisiblem.nss:161-162` applies the 50% concealment and the invisibility
as two independent effects with the same duration. Breaking invisibility by
attacking removes only the invisibility; the concealment continues for the full
`TurnsToSeconds(caster level)`.

The detonation at `:64` and `:105` fires only once per cast and only while the
6-second polling chain is alive. If invisibility is never lost, the explosion
never triggers.

Decision required: confirm that persistent concealment after the first attack
is intended, since it converts a stealth invocation into a sustained defensive
buff.

### Found while closing these, not yet acted on

`src/nui/t_invocaciones.nss` calls `NWNX_Creature_AddFeatByLevel(oPC,
nInvocacion, GetHitDice(oPC))` unconditionally after its switch, so any value the
switch does not match is still granted as a feat. `nInvocacion` comes from a
local that `0e_invocaciones.nss` writes on click, and feat row 0 is Alertness, so
pressing Apply with nothing validly selected adds Alertness. Reaching it needs
the local to be absent or out of range while the window is open.

The fix belongs to the invocation window, not to the reset: reject a selection
the switch did not match before granting anything. Recorded here rather than done
because the reset has no business editing the window's grant path.

### Where each of the sixteen items stands

As of 2026-08-31. The nine closed ones are described for the reader who will
notice them in `documentation/changelog/modulo/2026-08.md`; the rest are listed
here with what they are waiting for.

| # | Item | State |
|---|------|-------|
| 1 | Dark Wall of Fire damage below the published 8d6 | **Closed by decision.** The owner accepts a wall that starts under the full figure and grows; the code stands and the published text is what it is |
| 2 | Hellrime Blast applies -4 Dexterity, not -2 | **Closed.** Repaired to what the code should do. The TLK was not touched, on the owner's instruction |
| 3 | Essence replaced the invocation DC instead of raising it | **Closed.** The essence is a floor now |
| 4 | Devour Magic and Voracious Dispelling nearly identical | **Parked as future work**, by the owner's decision on 2026-09-01. Below caster level 16 the two dispel identically: they share `pbDispelMagic` and `pbDispelAoE`, and differ only in their rider - damage to the target against temporary hit points for the caster - and in their cap, 15 against 20. So a major invocation taken at level 10 duplicates a lesser one taken at level 5. Deciding what to do about that means touching `cerr_newdispel.nss`, which seven other spells share, so it belongs to a dispel pass of its own and not to the warlock |
| 5 | Voracious Dispelling damage ignored its own cap | **Closed**, and its twin in `war_devorar` with it: the temporary hit points were built before the cap of 20 |
| 6 | Path of Shadow does not restore hit points | **Closed as a false alarm.** It restores them, just not in `war_teleport`, which only sets `RUTASOMBRAS`. `mti_libreria.nss:41-48` reads that flag on arrival and applies `EffectHeal(GetMaxHitPoints(oPC)/2)`, then clears it. The published half-heal is there. What the flag *also* did - survive a DM reset and pay out on the next teleport of any kind - is item 14 |
| 7 | Walk Unseen duration is level-based, not 24 hours | **Closed.** Left as the code has it, on the owner's instruction; the TLK was not touched |
| 8 | Retributive Invisibility concealment outlived its invisibility | **Closed.** One linked effect now |
| 9 | Eldritch Chain gave more targets at low level than at mid | **Closed.** The floor is 1 |
| 10 | Chilling Burst damage ignored spell resistance | **Closed.** The damage moved inside the resistance guard |
| 11 | Eldritch Cone could hit its own caster | **Closed.** Parenthesised |
| 12 | `war_normal.nss` writes `esencia_ajuste` and nothing reads it | **Deleted.** No `ImpactScript` in `spells.2da` named it, nothing in `src/` included or executed it, and the essence toggle it duplicated already lives in `CambiarEsencia`: casting the essence you already have takes the equality branch, which clears `esencia_sobrenatural` and `esencia_ajustes` with the same VFX 460 and the same message. The dead copy wrote `esencia_ajuste`, so a row would have cleared the damage type and kept the difficulty bonus |
| 13 | Undead double damage discarded in the generic Wall of Fire | **Fixed 2026-08-26 in `7871e3146`**, and this document did not catch up until 2026-09-01. The line read `nDamage * 2;`, which computes a value and throws it away, so an undead took double damage on every tick of the wall and normal damage on entry. It assigns now |
| 14 | `dm_resetbrujo` cleared no warlock state | **Closed.** Sixteen warlock state variables, the thirteen invocation-slot variables the window writes, the module-parked essence throttle, and the Horrid Blow property an invocation armed on the equipment. The feat list is unchanged - it was already the thirty the `inv_*` scripts grant. Witch Sight (1515) is offered by the window and deliberately stays, keeping the dark slot it occupies: its three permanent effects carry no tag, and both ways of dropping them - by effect type, or by wiping every supernatural effect and reapplying - reach things the reset does not own. Feats 1499, 1500, 1501 and 1516-1519 are epic bonus feats the window never offers and were never in question |
| 15 | Four unused `WARLOCK_MOLDEADO_*` constants | **Deleted.** They named a shape selector that does not exist: the four shapes are four `spells.2da` rows with four scripts - 1335 `war_explosion`, 1344 `war_cadena`, 1346 `war_cono`, 1347 `war_area` - and none stores which shape is active, so nothing was replaced |
| 16 | Damage-over-time guard could stay set for ever | **Closed.** A target-side backstop, and a per-chain token so an old backstop cannot release a newer chain's guard |

Found while closing the above and not in the original sixteen: Horrid Blow
refused to arm for anyone holding a ranged weapon, without ever looking at the
gloves an unarmed strike would land with. Closed in `928c9e6a5`. Whether an OnHit
property on bracers fires on the wearer's own attacks the way it does on gloves
is unestablished and needs a probe; it belongs with the general OnHit review.

### Implementation Defects

#### 9. Eldritch Chain grants more targets at low level than at mid level

`war_cadena.nss:83-84`:

```nwscript
int nMaxCnt = nLevel/5;
if (nMaxCnt < 1) nMaxCnt = 2;
```

A Warlock below level 5 receives 2 additional targets; a Warlock between 5 and
9 receives 1. The floor was almost certainly meant to be `1`.

Note that the invocation is gated at class level 6 by
`CheckWarlockSpellCharisma()`, so the branch is only reachable through an
alternative cast path. It should still be corrected.

#### 10. Chilling Burst applies damage regardless of spell resistance and save

`war_rafaga.nss:86` gates only the knockdown behind
`!MyResistSpell(...) && !MySavingThrow(SAVING_THROW_FORT, ...)`. The damage at
`:99` is applied unconditionally, outside that branch.

Decision required: confirm whether the flat damage equal to the Warlock level
is intended to ignore spell resistance.

#### 11. Operator precedence in Eldritch Cone skips the self-exclusion check

`war_cono.nss:60`:

```nwscript
if(nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
```

`&&` binds tighter than `||`, so the condition evaluates as
`A || (B && C)`. With the Caustic essence active the `oTarget != OBJECT_SELF`
guard is bypassed. The earlier `spellsIsTarget(..., SPELL_TARGET_STANDARDHOSTILE, ...)`
filter normally excludes the caster, so the defect is currently masked rather
than harmless.

Fix: parenthesise the intended grouping.

#### 12. `war_normal.nss` writes the wrong variable name and is unreferenced

`war_normal.nss:12` sets `esencia_ajuste`, while every consumer reads
`esencia_ajustes`. The script would therefore clear the damage type without
clearing the essence adjustment.

No `ImpactScript` entry in `haks-2da/spells.2da` references `war_normal`;
essence deactivation goes through `CambiarEsencia()`. The file appears to be
dead code.

Decision required: delete the file, or fix the variable name if a spell is
expected to use it.

#### 13. Undead double damage is a no-op in the generic Wall of Fire

**FIXED 2026-08-26 in `7871e3146`.** The repair shipped inside the wall-fire
counter work and this document was not updated for it, so the item was carried as
open for six days and reported as such twice. Both call sites assign now.

Adjacent finding outside the Warlock scripts. `nw_s0_wallfirea.nss:91`:

```nwscript
if(PB_Race_GetIsUndead(oTarget)) nDamage * 2;
```

The result is discarded. The equivalent line in the same file's `MuroFuego()`
tick function (`:25`) assigns correctly, so undead take double damage per round
but normal damage on entry. `war_wallfirea.nss` does not have this defect.

#### 14. `dm_resetbrujo` does not clear Warlock state variables

Reported in game: after a DM uses the invocation reset, an essence left active
before the reset stays active and survives relog, death, and server restart.

`chat_consoladm.nss:356-395` removes feats 1470-1497, 1502 and 1514, then
resets the persistent `INVOCACIONES` counter. It clears no state variable.

The following state survives the reset:

| Variable | Owner | Written by | Consumed by |
|----------|-------|------------|-------------|
| `esencia_ajustes` | PC | `CambiarEsencia()` (`war_utilities.nss:277`) | `GetWarlockSpellDC()`, `GetWarlockExplosionDamage()`, every blast shape, `AjusteEsencia()` |
| `esencia_sobrenatural` | PC | `CambiarEsencia()` | damage type in every blast shape and in `x2_s3_onhitcast.nss` |
| `war_mod_aptitud` | PC | `CambiarModAptitud()` (`war_utilities.nss:224`) | Empower and Maximize multipliers |
| `GOLPEHORRIBLE` | PC | `war_golpe.nss` | `x2_s3_onhitcast.nss:74` |

Consequences:

- A reset character keeps the essence damage bonus (`+1` or `+2` dice), the
  essence damage type, the full essence rider, and the essence branch of
  `GetWarlockSpellDC()` — up to a bonus of 9 with Utterdark. None of that
  requires an invocation feat, only `Explosión Sobrenatural` (feat 1465), which
  is granted at class level 1 and is **not** in the removal list.
- Local variables stored on a player object are written to the character's
  `VarTable` when the character file is exported, which is why the state
  survives logout, death, and restart.
- Feats 1499 (`Soltura Aptitud Sortilega`), 1500 (Empower), 1501 (Maximize)
  and the epic blast feats 1516-1519 are also absent from the removal list.
  The first three are published as invocations.

Note that essences are mutually exclusive by construction: `esencia_ajustes`
and `esencia_sobrenatural` are single-valued, so activating one essence
replaces the previous one and re-activating the same one clears it. The defect
is only that the reset never clears them.

Proposed fix, to be confirmed before implementation: add a public cleanup
function to `war_utilities.nss` that deletes `esencia_ajustes`,
`esencia_sobrenatural`, `war_mod_aptitud` and `GOLPEHORRIBLE`, removes the
`Golpe_Horrible_CastSpell` item property from the equipped weapon, and call it
from the `dm_resetbrujo` branch. Decide separately whether feats 1499, 1500,
1501 and 1516-1519 belong in the removal list.

#### 15. Unused shape constants

`WARLOCK_MOLDEADO_NORMAL`, `WARLOCK_MOLDEADO_CADENA`, `WARLOCK_MOLDEADO_CONO`
and `WARLOCK_MOLDEADO_AREA` (`war_utilities.nss:17-20`) are declared and never
referenced anywhere in the repository. Blast shapes are separate spells and
keep no stored state.

Decision required: delete the constants, or implement the shape toggle they
were written for.

#### 16. Damage-over-time guard can remain permanently set

`AplicarDoT()` (`war_utilities.nss:324`) marks the target with
`esencia_dot_<damage type>` and clears it when the chain ends. The chain is
continued with `DelayCommand` in the caster's context. If the caster logs out
or is destroyed before the chain completes, the pending call is dropped and the
guard is never cleared.

`AjusteEsencia()` (`war_utilities.nss:355-366`) refuses to start a new
Brimstone or Caustic damage-over-time while the guard is set, so an affected
creature can become permanently immune to that essence rider.

Decision required: clear the guard from a scheduled cleanup with an absolute
timeout, or store an expiry timestamp instead of a Boolean.

### Validation Required Before Implementation

- Recompile every touched script with the bundled compiler.
- Confirm blast damage, DC, and duration values in game at Warlock levels 12,
  16, and 20 for each essence.
- Verify each blast shape against a target with spell resistance and against an
  undead target with the Utterdark essence active.
- Re-check saving throw categories against the published class page after the
  rule decisions above are resolved.

---

## 6. Artificer infusion errata

Status: in progress. The published class page at
`puertadebaldur.com/inicio/artifice-2/` is the specification wherever it and the
code disagree; that was settled on 2026-09-01 and it closes several items this
document had recorded as open questions.

Implemented so far: findings 1, 9, 10, 11 and 20 in `49411ca9d`. Findings 2, 3,
4, 8, 17 and 21 are closed with no code change - see their entries. The rest are
pending.

A difference between the page and the code is a **question, not a defect**.
Findings 2, 3 and 8 were each implemented against the page and reverted the same
day; what made the five in `49411ca9d` defects is that the code contradicted
itself, not the page.

### Scope

This document records defects and description-to-implementation mismatches
found during a static review of the Artillerist, Alchemist, and Armorer
Artificer specializations. The primary implementation is in:

- `src/shared/nss/cls_ing_lib.nss`
- `src/shared/nss/cls_ing_item1.nss` (Artillerist)
- `src/shared/nss/cls_ing_item2.nss` (Armorer)
- `src/shared/nss/cls_ing_item4.nss` (Alchemist)
- `src/shared/nss/cls_ing_humia.nss` and `cls_ing_humib.nss`
- `src/shared/nss/cls_ing_bomba*.nss`
- `src/shared/nss/event_castspell.nss`
- `src/shared/nss/event_feat.nss`
- `src/shared/nss/pb_nivellanzador.nss`
- `haks-2da/feat.2da`, `skills.2da`, `spells.2da`, and
  `vfx_persistent.2da`

The findings are pending fixes, but published descriptions are not assumed to
be authoritative when they conflict with the implementation. Each behavioral
mismatch requires a balance decision before changing either the script or its
text.

### Shared Defects

#### 1. Non-Artillerist damage uses the wrong improvement feats

`iDANOING()` in `cls_ing_lib.nss:237-244` calculates `d6(Artificer level / 2)`
for every specialization other than Artillerist. Its three additional dice are
then granted by feats `1771`, `1772`, and `1773`.

Those identifiers are:

| Feat | ID | Current result |
|------|----|----------------|
| Born in Lantan | `1771` | Incorrectly adds `1d6` damage |
| Improve Artifact I | `1772` | Adds `1d6` |
| Improve Artifact II | `1773` | Adds `1d6` |
| Improve Artifact III | `1774` | Adds no damage |

The Artillerist branch correctly checks `1772`, `1773`, and `1774` for its
three additional `d8` dice. The non-Artillerist branch should be reviewed for
the same sequence. This affects both Alchemist and Armorer damage.

#### 2. Secondary burning can apply six damage ticks

**CLOSED 2026-09-01 with the count unchanged.** Six ticks stay. Five is what the
three infusions publish, and the count was changed to five and reverted the same
day: the owner decided the page is what needs correcting. The dead `iDano`
parameter is left in place; removing it is a signature change with no behavioural
effect.

`ImpactosSecundarios()` in `cls_ing_lib.nss:176-197` applies `2d6`, increments
`CLS_ING_IMPACTOS`, and schedules another call while the counter is below six.
Starting from zero, a target that fails every save can take six ticks, not the
five rounds stated by the infusion descriptions.

The function also overwrites its `iDano` argument with `d6(2)`, so callers
cannot alter the secondary damage through that parameter.

Decision required: retain six ticks and correct the descriptions, or stop the
chain after five ticks. If the damage parameter is intentionally fixed, remove
it from the public contract during the fix; otherwise use the supplied value.

#### 3. Infusion exclusivity is only partially enforced

**CLOSED 2026-09-01 with the number unchanged.** The lock between one infusion
and a different one stays at eight seconds. It was raised to the twenty the page
publishes and reverted the same day: twenty is long enough that an artificer can
do nothing while it runs, and the owner wants eight played. The page and the
stale comments that say twenty are what need correcting.

Repeating the *same* infusion stays ungated by this, on the owner's decision:
each infusion carries its own cooldown and those are correct. The inconsistency
this finding described - a shared eight-second gate plus per-infusion locks of
differing lengths - is therefore the intended shape, not a defect.

`event_castspell.nss:134-191` prevents selecting a different infusion for
eight seconds, but allows immediate repetition of the same infusion. Individual
scripts then implement additional duration locks inconsistently.

The scripts and comments still contain obsolete references to a 20-second
restriction. The intended policy must be stated once and applied consistently,
especially to effects that can be recast before their previous instance ends.

### Artillerist Findings

#### 4. Humidifier does not stun

**CLOSED 2026-09-01 with no code change.** The published page says the cloud
"otorga ocultacion 50% y ciega al enemigo (Fortaleza)" - no stun, and the
concealment is advertised. The in-game conversation is what disagrees with the
code. The owner has accepted the mechanics as they are and wants the presentation
reworked later.

The conversation says the cloud blinds and stuns. `cls_ing_humia.nss:48-65`
creates `EffectBlindness()` and uses `VFX_IMP_STUN` only as a visual effect. No
`EffectStunned()` is applied.

Eligible creatures inside the cloud also receive 50% concealment and a
duration visual until they exit (`cls_ing_humia.nss:68-78`). This beneficial
effect is not mentioned in the description.

Decision required: add the advertised stun, or correct the description and
confirm that granting concealment to affected occupants is intentional.

#### 5. Bazooka is missing its advertised `2d6`

The normal Bazooka implementation in `cls_ing_item1.nss:132-169` applies only
`iDANOING()` as fire damage. Unlike Flamethrower, Electrocutor, Force Bazooka,
and TNT Bomb, it never adds `d6(2)` despite the conversation advertising that
bonus.

#### 6. Bazooka and Force Bazooka can hit allies and the caster

Both area loops have their `spellsIsTarget()` hostile filters commented out:

- Bazooka: `cls_ing_item1.nss:137-168`
- Force Bazooka: `cls_ing_item1.nss:346-379`

They iterate creatures, doors, and placeables without excluding friendly
targets or the caster. Confirm whether these are deliberately indiscriminate
explosions before restoring the hostile filter.

#### 7. Force Bazooka classifies its save as fire

`cls_ing_item1.nss:361-367` calls `GetReflexAdjustedDamage()` with
`SAVING_THROW_TYPE_FIRE`, then applies `DAMAGE_TYPE_FUERZA`. The save subtype
does not match the custom Force damage.

This overlaps the broader [spell saving throw review](#1-saving-throws).
The fix must choose the project's intended save classification for Force
damage rather than assuming that the fire subtype is correct.

#### 8. Protector duration differs from its description

**CLOSED 2026-09-01 with the duration unchanged.** Caster-level rounds stay. A
round is six seconds, so this is two minutes at artificer 20 against the thirty
seconds the page describes; cutting it to five rounds is a four-fold nerf at high
level and the owner declined it. Changed and reverted the same day. The page is
what needs correcting.

The conversation says temporary hit points last five rounds.
`cls_ing_item1.nss:386-407` applies them for `iCasterLevel` rounds and blocks
reuse for the same duration, even if the effect is dispelled.

Decision required: use a fixed five-round duration or correct the published
description to the level-scaled duration.

### Alchemist Findings

#### 9. Elixir of Knowledge never enables its caster-level benefit or lock

`cls_ing_item4.nss:69-90` checks `CLS_ING_ELIXIRCON`, but the line that sets
the variable is commented out. Consequently:

- The intended reuse lock never activates.
- The `+4` caster-level adjustment in `pb_nivellanzador.nss:300-305` never
  activates.
- Only the `+4` Intelligence effect is currently applied.

The delayed deletion remains active but only deletes a variable that was never
set. Restore a Boolean or timestamp-based state consistently; do not mix the
two representations.

#### 10. Gas Bomb rewards a successful Fortitude save with more damage

On entry and on every heartbeat, `cls_ing_bomb2a.nss` currently behaves as
follows:

| Fortitude result | Poison | Acid damage |
|------------------|--------|-------------|
| Failed | Applied when not immune | Half `iDano` |
| Successful | Not applied | Full `iDano` |

The relevant branches are at `cls_ing_bomb2a.nss:77-90` and `:12-23`. This is
the reverse of the conventional full-on-failure, half-on-success damage model
and is probably unintended.

#### 11. Gas Bomb poison scaling checks class 60

The poison selection at `cls_ing_bomb2a.nss:58-68` combines Artificer-level
checks with `GetLevelByClass(60, oCaster)`. Class 60 is not the Artificer;
Artificer is class 64. This can leave `eVeneno` invalid or select the wrong
poison tier depending on multiclass levels.

Replace the numeric class checks with `CLASS_TYPE_INGENIERO` after confirming
the intended thresholds: up to 12, 13-16, and 17 or higher.

#### 12. Alchemist's Fire ignores its adjusted Reflex damage — FIXED 2026-08-30

Fixed in `06d5a7721` on the owner's instruction that the mechanic be correct
first and the numbers reviewed afterwards. The effect is now built after the roll
and from its result, so a successful save halves the bomb's damage and Evasion
negates it. **This is a live damage reduction for the artificer and is not
validated in play.**

Two things this item had wrong, recorded because they changed what the repair had
to be:

- A second fault was tangled with it. The adjusted damage was written back over
  `iDano`, which the heartbeat carries to the next tick, so each tick rolled
  against the previous tick's reduced number. Repairing only the effect ordering
  would have made the damage halve every six seconds. Both were fixed together
  and `HeartBeat` lost its `eFuego` parameter, since the effect must be built per
  tick.
- The adjusted value was described here and in the changelog as reaching the
  secondary impacts. It reached nothing. `ImpactosSecundarios` in
  `cls_ing_lib.nss:181` overwrites the damage it is handed with a fresh `d6(2)`
  on its first line, so that argument has never been read by anything.

Still open around it, and not repaired: the bomb takes two Reflex saves per tick
against the same DC, one inside the damage adjustment and one deciding whether
the secondary impacts start, and `ImpactosSecundarios` then takes a third on each
of its own hits. Whether the follow-up hits should roll at all is a design
question. The dead damage parameter of `ImpactosSecundarios` is left in place;
removing it is a signature change with no behavioural effect.

#### 13. Empowerment Bomb can buff hostile targets

`cls_ing_item4.nss:281-290` iterates the colossal sphere without a faction or
reaction filter and applies `+2` attack and `+25%` movement speed to each
target, up to the caster-level count. The conversation says it benefits the
caster and allies.

Add an explicit friendly-target filter if the published behavior is intended.

#### 14. TNT Bomb can damage allies and the caster

The hostile filter in `cls_ing_item4.nss:305-339` is commented out. The loop
processes creatures, doors, and placeables without excluding friendlies or the
caster, then applies fire damage and a possible knockdown.

Confirm whether friendly fire is intended before restoring the filter.

#### 15. Berserker Elixir does not exchange Strength and Intelligence

The conversation describes converting Strength into Intelligence and
Intelligence into Strength. `cls_ing_item4.nss:157-180` instead raises the
lower ability to equal the higher one; neither score is lowered after both
cached comparisons complete. It also applies 100% spell failure, which the
conversation does not disclose.

Decision required: preserve the equalization mechanic and correct the text, or
implement an actual exchange. The spell-failure penalty must be documented if
it is intentional.

#### 16. Love Sprayer applies domination, not charm

`cls_ing_item4.nss:226-255` uses `EffectDominated()` for three rounds after
spell resistance and a Will save. The conversation describes the target as
charmed. Domination grants materially stronger control than charm.

Decision required: retain domination and describe it accurately, or replace it
with the intended charm effect.

### Armorer Findings

#### 17. Cyborg grants bonuses to the wrong skills

**CLOSED 2026-09-01 with no code change, and this finding was wrong.** It was
written against a `skills.2da` that is not the deployed one. In production, rows
25, 26 and 37 are Nadar, Saltar and Trepar - exactly the three the page
advertises. The script was correct all along.

`cls_ing_item2.nss:125-127` uses hard-coded skill IDs `37`, `25`, and `26`.
The current `skills.2da` maps them to:

| ID | Current skill |
|----|---------------|
| `25` | Alchemist's tools |
| `26` | Athletics |
| `37` | String instrument |

The conversation advertises Climb, Jump, and Swim. The hard-coded IDs appear
to predate the current skills table. Replace them with the correct reviewed
constants or current IDs; do not preserve numeric assumptions in the script.

#### 18. Thunder Gauntlets have no Reflex save

The conversation advertises a ranged touch attack plus a Reflex save.
`cls_ing_item2.nss:67-100` performs `TouchAttackRanged()` and applies base
damage plus `2d6` electrical damage on a hit. It makes no saving throw and no
explicit spell-resistance check.

Decision required: determine whether the touch attack replaces the save or
whether both defenses are intended.

#### 19. Rockbreaker does not implement its published behavior

The conversation describes sonic damage plus `2d6` and a Reflex-based repel.
`cls_ing_item2.nss:181-224` instead:

- Performs a melee touch attack.
- Adds no `2d6` damage.
- Uses a Will save against stun for `caster level / 2` rounds.
- Never calls `ActionRepel()`.
- Applies sonic damage on a normal hit but magical damage on a critical hit.

This needs a balance decision, not a mechanical one-line correction. Either
the implementation or the description represents a different ability.

#### 20. Sticky Goo's reapplication lock uses turns instead of rounds

The movement and attack penalties last `RoundsToSeconds(iCasterLevel / 2)`,
but `CLS_ING_GOMA` is deleted after `TurnsToSeconds(iCasterLevel / 2)` at
`cls_ing_item2.nss:251-280`.

The target is therefore protected from reapplication ten times longer than the
penalties last. Use the same duration unit for the effects and their lock.

The ability also applies sonic damage on a normal hit and magical damage on a
critical hit. Confirm the intended damage type and make both branches match.

#### 21. Antimagic Field and Antidamage Field are not fields

**CLOSED 2026-09-01 with no code change.** The owner reads "field" as a personal
force field around the wearer, so a self-only effect is the intended behaviour
and no aura was ever meant.

Despite their names and descriptions, neither ability creates an area:

- Antimagic Field applies personal spell resistance equal to
  `15 + Artificer level` for `caster level` rounds
  (`cls_ing_item2.nss:288-310`).
- Antidamage Field applies personal damage reduction `20/+6` for
  `caster level` rounds (`cls_ing_item2.nss:315-336`).

They do not affect nearby allies or enemies. Decide whether "field" is merely
presentation or whether an actual aura was intended.

#### 22. Repel classifies sonic damage as fire

`cls_ing_item2.nss:361-369` adjusts its sonic damage using
`SAVING_THROW_TYPE_FIRE`. This has the same damage/save classification problem
as Force Bazooka and belongs in the broader saving-throw review.

#### 23. Armorer persistent-effect replacement is inconsistent

Most Armorer branches remove Cyborg (`1410`) and Antimagic Field (`1415`)
before applying their own effect. However:

- Repel does not remove either effect.
- Antidamage Field is not removed when another infusion is selected.
- Detection Field is not removed when another infusion is selected.
- Removing Cyborg early does not clear `CLS_ING_CIBORG`; the player remains
  unable to reactivate it until its original duration expires.

Define which Armorer modes are mutually exclusive, then centralize their
cleanup rather than maintaining a different removal list in every branch.

### Required Verification

Before implementation, confirm the intended behavior of every item marked as a
description decision. Then validate fixes in focused slices.

#### Static and compilation checks

1. Inspect every changed script and its corresponding `feat.2da`, `spells.2da`,
   dialogue, and persistent-area entry.
2. For each changed executable `.nss`, run:

   ```bash
   ./linux_build-dev.sh --check <explicit-changed-script.nss>
   ```

3. When `cls_ing_lib.nss` changes, compile representative direct consumers
   from all affected specializations in addition to any executable scripts
   changed in the same slice.
4. Do not run a bare repository-wide `--check` for these focused fixes.

#### Manual validation matrix

- Test each specialization at the first level of every infusion tier: 5, 10,
  and 15.
- Repeat scaling checks at levels 17, 19, and 20.
- Test normal hits, critical hits, spell resistance, successful saves, failed
  saves, immunity, allies, enemies, and the caster where applicable.
- Measure persistent-area entry, heartbeat, exit, and replacement behavior.
- Verify switching to a different infusion at 0, 7, 8, and 9 seconds.
- Verify repeated use of the same infusion while its previous effect remains.
- Test Improve Artifact I, II, and III independently, with and without Born in
  Lantan.
- Test Cyborg bonuses against the names and IDs in the deployed `skills.2da`.
- Test Propellers indoors, outdoors, in restricted areas, and with light and
  heavy armor.
- Confirm relog and effect-dispel cleanup for every local-state lock.

No runtime behavior was validated during the review that produced this
document.

## 7. Archmage Arcane Fire

Status: pending review. None of the changes described here are currently
implemented.

### Scope

Arcane Fire (feat 1431 `FEAT_ARCANE_FIRE`, spell 1322) is implemented as a
two-stage module spell hook. This document records its current behavior and the
defects found while auditing it. Item 1 can disable the module-wide spell hook
for every player and should be triaged first.

Audited files:

- `src/shared/nss/spl_arcane_fire.nss` — activation, `ImpactScript` of spell 1322
- `src/shared/nss/archmage_fire.nss` — the intercepting hook
- `src/shared/nss/archmage_spelllk.nss` — Spell-Like Ability, same pattern
- `src/shared/nss/x2_inc_switches.nss` — hook plumbing
- `src/shared/nss/q_mod_def_load.nss` — default hook assignment

### Current Behavior

Activation (`spl_arcane_fire.nss`) casts nothing. It:

1. Sets `arcane_fire_active` to 1 on the caster.
2. Copies the current module override spellscript into the module string
   `archmage_save_overridespellscript`.
3. Replaces the module override spellscript with `archmage_fire`.
4. Stores the selected target in the local object `arcane_fire_target`.

The next spell cast then runs `archmage_fire` instead of its own script. That
script blocks the original spell, restores the previous hook, clears
`arcane_fire_active`, validates that the spell is a memorized wizard or
sorcerer spell, makes a ranged touch attack against the stored target, and
applies `d6(Archmage level + spell level)` magical damage.

The default module override spellscript is `q_spellhook`
(`q_mod_def_load.nss:158`), which implements spell components and other custom
rules.

### Defects

#### 1. The hook is module-wide, so any player can trigger and break it

`SetModuleOverrideSpellscript()` stores its value on the module object
(`x2_inc_switches.nss:461`), not on the caster. While an Archmage has Arcane
Fire armed:

- `q_spellhook` is disabled for every player in the module.
- The next spell cast by **any** player runs `archmage_fire` in that player's
  context. `SetModuleOverrideSpellScriptFinished()` is called at
  `archmage_fire.nss:41`, before the `FEAT_ARCANE_FIRE` check at `:47`, so a
  character without the feat loses the spell entirely: the slot is spent, no
  effect is produced and no message is shown.
- `arcane_fire_active` is cleared on that other player, not on the Archmage,
  who stays flagged as armed and cannot re-arm until rest or relog.

#### 2. Concurrent activations permanently destroy the saved hook

`archmage_save_overridespellscript` is a single module-wide string, written
only by `spl_arcane_fire.nss:18`. With two Archmages:

| Step | `archmage_save_overridespellscript` | Module override spellscript |
|------|-------------------------------------|-----------------------------|
| Initial | — | `q_spellhook` |
| Archmage A arms | `q_spellhook` | `archmage_fire` |
| Archmage B arms | `archmage_fire` | `archmage_fire` |
| Any spell is cast | `archmage_fire` | `archmage_fire` |

From that point every restore re-installs `archmage_fire`. `q_spellhook` is
never recovered and every spell cast by every player is intercepted, until the
module is reloaded.

`archmage_spelllk.nss` uses the same pattern with its own saved slot
`spelllike_save_overridespellscript`. Both systems compete for the same module
variable and can clobber each other in the same way.

#### 3. State resets do not restore the hook

`hc_on_play_rest.nss:437` and `wrap_on_clnt_ent.nss:272` clear
`arcane_fire_active` on rest and on client enter. Neither restores the module
override spellscript. An Archmage who logs out while armed leaves the module
hooked.

#### 4. Damage uses the Archmage class level, not the caster level

`archmage_fire.nss:15`:

```nwscript
int nCasterLvl = GetLevelByClass(53, OBJECT_SELF);   // CLASS_TYPE_ARCHMAGE
```

Spell Power feats add up to 5 more, then damage is
`d6(nCasterLvl + spell level)`. The Archmage prestige class contributes at most
5 levels, so a Wizard 25 / Archmage 5 with Spell Power V casting a 9th level
spell rolls 19d6. Every comparable script in the repository uses
`GetTotalCasterLevel()`.

Decision required: confirm whether restricting the dice to prestige levels is
the intended balance or a defect.

#### 5. Consumed spell with no effect in several paths

The spell slot is spent by the engine before `archmage_fire` runs, and the
script blocks the original spell unconditionally at `:41`. The spell is
therefore lost with no compensation when:

- the target is friendly (`:66`, the whole damage block is skipped);
- the stored target is no longer valid;
- the spell is not a wizard or sorcerer spell, or was cast from an item;
- the caster does not have the feat, per defect 1.

#### 6. Minor issues

- The ranged touch attack critical result is discarded. `TouchAttackRanged()`
  returns 2 on a critical hit and the script only tests for truthiness, so a
  critical deals normal damage.
- `nMetaMagic` is read at `:18` and never used. Empower and Maximize do not
  affect Arcane Fire.
- `fDist` is computed at `:27` and never used.
- No spell resistance check and no saving throw are applied.
- The target is captured at activation and never revalidated for distance,
  line of sight, or validity.
- The 18 second expiry is commented out (`spl_arcane_fire.nss:15`), so an
  activation stays armed indefinitely.

### Suggested Direction

To be confirmed before implementation:

1. Move the armed state and the saved hook name from the module to the caster,
   or gate `archmage_fire` on `GetLocalInt(OBJECT_SELF, "arcane_fire_active")`
   before calling `SetModuleOverrideSpellScriptFinished()`, so a character who
   did not arm the ability never loses a spell.
2. Never store the current hook when it already equals `archmage_fire`; restore
   the module default instead.
3. Restore the module override spellscript in the rest and client-enter
   cleanups, and on a timeout.
4. Decide the intended caster level source for the damage dice.

### Validation Required Before Implementation

- Two Archmages arming Arcane Fire in the same session, verifying that
  `q_spellhook` is still installed afterwards.
- A non-Archmage casting a spell while an Archmage is armed, verifying the
  spell resolves normally.
- Logout and rest while armed, verifying the module hook is restored.
- Spell component consumption from `q_spellhook` still working after several
  Arcane Fire cycles.

---

## 8. Archmage Spell-Like Ability: forbid Time Stop

Status: deferred until every preceding section in this plan is complete. Nothing
described here is currently implemented.

The Archmage's Spell-Like Ability must never accept `SPELL_TIME_STOP` (spell ID
185) as its stored spell. The existing capture check in `cwa_enforcer.nss` is
not a sufficient final invariant because the activation path trusts the
`SPELL_ID` already stored on the focus.

When this final roadmap item is implemented:

1. Reject `SPELL_TIME_STOP` before writing `SPELL_ID` to the Archmage focus.
2. Validate the stored spell again before activation, so an old or manually
   altered focus containing ID 185 cannot cast it.
3. Clear or invalidate an existing stored ID 185 when its owner next enters,
   without resetting the focus's uses per day.
4. Keep ordinary ninth-level spells eligible; this restriction is specifically
   for Time Stop, not for the ninth spell sphere.

Required in-game validation:

- Attempt to store Time Stop and confirm that the focus remains unchanged.
- Store and activate a different ninth-level spell successfully.
- Present a legacy focus with `SPELL_ID` 185 and confirm that activation is
  refused and the stored spell is cleared.
