# Pending tests

Everything committed and not yet validated in play. **Nothing on this page has
been observed running**; every item is a claim about code.

The sheet has two parts, and they need different testers.

**Part A is the machinery** - saving throws, spell schools, areas, resistances,
dispelling, elemental damage. It touches **504 scripts and 728 rows of
`spells.2da`**, which is most of the spellbook. Almost none of it is supposed to
look different: the work moved a hundred-odd scripts onto one shared route, and
the test is that they still behave as they did. This part is best done by
somebody with a high-level caster who knows what a spell normally does.

**Part B is the classes** - warlock, artificer, archmage. Here things *are*
supposed to look different, item by item, and each one says what changed and
what must not have. This part needs a character of the class, and two of them in
places.

**Start with B6, Arcane Fire.** It is the only item on the sheet that was
reachable by every player in the module rather than by the class that owns it.

---

## How to read a test

Each one says what to do, what should happen, and what a failure looks like.
Where a test says **nothing should change**, that is the whole test: any
difference at all is the finding, and it is the hardest kind to run because
there is no positive result to look for.

Bring a character you can respec. Several of these need Spellcraft at zero and
again at fifteen invested ranks, and several need the Shadow Defence feats.

Report with: the spell or ability, your class and level, the target, what you
expected and what happened. A screenshot of the combat log is worth more than a
description of it.

---

# PART A - The machinery

Saving throws, schools, areas, resistances, dispelling, elemental damage. Test
these with any caster; the spells named in each are examples, not the whole set.

## A0. One route for every saving throw, which everything else sits on

A hundred-odd spells stopped rolling their own saving throws and now go through
one shared library. This sits underneath almost everything else in Part A, and
**it is not supposed to be visible at all**.

The work is dull and it is the most important on the sheet: cast spells with
Fortitude, Reflex and Will saves at targets with high and low saves, and confirm
the difficulty lands where it always did.

Any of them will do. The families that cover the most ground:

| Family | Spells to try |
|---|---|
| Death and negative energy | Circle of Death, Finger of Death, Implosion, Slay Living, Harm, Negative Energy Burst, Wail of the Banshee |
| Mind and fear | Charm Person, Fear, Scare, Hold Person, Hold Monster, Dominate, Mind Fog, Confusion |
| Elemental | Fireball, Ice Storm, Lightning Bolt, Chain Lightning, Flame Strike, Sound Burst, Firebrand, Ball Lightning |
| Disease and poison | Infestation, Plague, Cloudkill |

If a single one of these comes out with a difficulty it did not have before,
that is a fault in the shared route and it affects every other spell on it.

## A1. Shadow Defence, which must not have moved

Committed 2026-08-30 across `7ebc0f831`, `b418918f5`, `5d3d50706`.

Twenty-eight saving throws moved to a shared route. The route they left applied
the defender's Shadow Defence quietly; the new one has to be told to. If any call
was missed, that effect became 1 to 3 points harder to resist and nothing in the
build would have said so.

Take Shadow Defence I, then II, then III, and confirm the difficulty drops by
one, two and three respectively against:

- The warlock's **Dominate Monster**, **mass invisibility** and **polymorph**
  invocations.
- The artificer's **gas bomb**, **alchemist fire bomb** and **humidifier**, and
  the three infusion item scripts.

And confirm it drops by **nothing at all** against the warlock's **curse**,
**ray** and **tentacles**. Those are transmutation, evocation and conjuration,
and Shadow Defence has never covered them. A reduction appearing there is the
failure, not its absence.

---

## A2. Shadow Weave difficulty, one point either way

Committed 2026-08-30 in `ebcbf9d16`.

**Incendiary Cloud** and the **Delayed Blast Fireball** area never applied the
school modifier at all - one never asked for it, the other asked the area object
which holds no feats.

Cast both with a Shadow Weave caster and compare the difficulty a defender rolls
against, before and after. Both are evocation, so the difficulty should now be
**one lower** than it was. Cast them with a caster who has no Shadow Weave feat
and confirm nothing moved.

---

## A3. Spellcraft, which is new in three places

The engine only grants the Spellcraft saving throw bonus when a spell asks for
the plain spell save. Several effects ask for an elemental or a mind save
instead, so their defenders were losing it. They now get it back: one point per
five **invested** ranks, so fifteen ranks is three points.

Test each with a defender at zero invested ranks and again at fifteen. The second
must resist three points better; before these changes both resisted the same.

- **Warlock area invocations with an elemental essence** - sulphur, caustic, cold.
  Committed in `b48d31c39`.
- **Dominate Monster.** Committed in `5d3d50706`. The warlock's other five
  invocations should show no difference, because they already had it.
- **Earthquake, Bombardment and Acid Splash.** Committed in `fe16d36fe`.
  Bombardment twice: once watching the damage, once watching whether the rubble
  pins you. Those are two separate rolls and both should show it.

---

## A4. Area effects that were asking the wrong creature

Committed 2026-08-30 in `7ebc0f831` and `5d3d50706`.

A saving throw names who is responsible for the effect. Four area scripts named
nobody, so it fell to the invisible area object instead of the caster. Anything a
defender has that depends on **who is attacking them** was being measured against
a thing with no race and no alignment.

Bring a defender carrying a bonus or penalty **versus a race** or **versus an
alignment** that would apply to the caster, and confirm it now counts against:

- The artificer's **gas bomb**, **alchemist fire bomb** and **humidifier**.
- The warlock's **tentacles**.

Before these changes it did not count. This changes how hard those four are to
resist, in whichever direction the defender's own modifiers point.

---

## A5. Scaled difficulties that must still scale

Committed 2026-08-30 in `a65b8a2a6`.

Six spells moved route and each keeps its own arithmetic on top. The difficulty
must not move for any of them; then the scaling itself:

- **Tasha's Hideous Laughter** against a target of your own race and of another
  race. The second must be 4 easier to resist.
- **Agarre Electrico** at caster levels 7, 8, 12, 16 and 20. The difficulty must
  step up in line with its damage dice.
- **Deep Slumber** against a group whose hit dice sit either side of its pool. It
  must still pick the same targets.
- **Charm Person** and **Horizikaul's Boom**: nothing should change.

---

## A6. Mastery of Elements and the save that follows it

Committed 2026-08-30 in `ebcbf9d16`, `a65b8a2a6` and `fe16d36fe`.

An archmage converting a spell's element left the saving throw asking for the
original one, so a fireball converted to cold still asked the target to resist
fire.

With Mastery of Elements active, cast and confirm the defender resists with the
**converted** element's modifiers and not the original's:

- Chain Lightning, the Delayed Blast Fireball area, Incendiary Cloud.
- Electric Loop.
- Acid Splash.

Without Mastery active, all of them must behave exactly as before.

---

## A7. Electric Loop, which is one spell and two rolls

Committed 2026-08-30 in `a65b8a2a6`.

Its Will save against stun only happens when the Reflex save was failed.

- A target that **fails** Reflex must then roll Will against the stun.
- A target that **makes** Reflex must not roll it at all.
- A target with **Improved Evasion** must still get the half-damage branch, and
  the stun chain must still follow it correctly.

---

## A8. Dispelling, where only the area version changed

Committed 2026-08-30 in `1dc991700`.

Tenacious Magic was protecting evocation and transmutation spells, which its own
text excludes. Only the **area** version of each dispel was affected; aiming at a
creature directly exercises a path that was already correct.

**Aim at the ground, not at the character.**

- A Shadow Adept with Tenacious Magic casts an **evocation**. Someone without the
  Shadow Weave feat drops an area **Dispel Magic** on them. It must be no harder
  to dispel than any other evocation; before this it was 4 harder. Repeat with
  Greater Dispelling, Mordenkainen's Disjunction and Lesser Dispel.
- The same with a **transmutation**: 4 easier than before.
- The same with an **enchantment, illusion or necromancy** spell: still 4 harder,
  unchanged. This is the case that proves the exclusion reads the school instead
  of having switched itself off.
- The single-target version of all of the above: unchanged in every case.

---

## A9. Three delayed effects, hardened but unchanged

Committed 2026-08-30. Storm of Vengeance, Combust and Bigby's Clenched Fist take
their saving throw seconds after the spell was cast, when the engine no longer
knows which spell is running. They now say which spell they are instead of asking
it.

**Nothing about them changes.** The only thing the spell's identity feeds is the
Shadow Defence reduction, and that covers illusion, enchantment and necromancy
only. These three are conjuration and evocation, so the answer was zero before
and is zero now. The change matters if one of them is ever reclassified, or if
something else starts reading the spell identity, and not before.

- Use all three and confirm they behave exactly as they did: the same difficulty,
  the same damage, the same number of ticks.
- A Shadow Adept should see **no** reduction against any of them, and should not
  have seen one before either.

An earlier version of this section said the reduction was being lost and had to
come back. That was wrong for these three: it was never there to lose.

**But one spell was losing it.** The warlock's mass invisibility invocation is
illusion, and its saving throw happens after a wait.

It works like this: the targets go invisible, and a check runs every six seconds
until that invisibility ends. Then it explodes **once**, rolling a save for
everybody nearby at that moment. There is no repeated explosion and no sequence
of hits to compare - one blast, one round of saves, always at least six seconds
after the cast.

Take Shadow Defence I, II or III, stand near a warlock who casts it, wait for the
invisibility to run out, and confirm the difficulty you roll against is reduced
by one, two or three. Before this, nobody in that blast got the reduction.

If it turns out the reduction was already applying, the change was harmless
rather than wrong - the reason it was thought to be missing is that the engine
loses track of which spell is running across a delay, and that was reasoned from
BioWare's own comment about the same problem elsewhere, not measured.

---

## A10. The Glyph of Warding, which never asked the caster anything

A glyph is an object sitting on the floor, and when somebody stepped on it the
difficulty was worked out by asking *the glyph* about the caster's feats. A floor
tile has no feats, so the answer was always no.

Plant a glyph as a caster **with** Shadow Weave Magic and step on it: the
difficulty should now be one different from what it always was. Plant one as a
caster **without** the feat and confirm nothing moved.

Then Spellcraft, which the glyph was skipping entirely because it asks for a
sonic save rather than a plain spell save: two characters with zero and with
fifteen invested ranks stepping on the same glyph. The second should resist three
points better. Before this they resisted identically.

A Shadow Adept should see **no** reduction here, and should not have seen one
before either - the default glyph is an evocation and Shadow Defence covers
illusion, enchantment and necromancy only.

---

## A11. Mind Fog, which is back to how it was

Briefly it rolled once per creature and then stopped. It rolls every tick again,
like every other lingering cloud. Walk in and out of one and confirm you get a
save each time the cloud reaches you, and that the penalty applies while you are
inside and lifts when you leave.

This is a test that something was **put back**, so a tester who never saw the
in-between version should find nothing unusual. That is the pass.

---

## A12. Changes that should be invisible

These are the ones where any difference is the finding.

- **The warlock's difficulty** after `ba6016764`. Cast the supernatural blast
  with each essence, land Horrid Blast through a weapon, and confirm the
  difficulty is what it was. Let a damage-over-time essence run its full five
  ticks and confirm it holds steady across them rather than changing after the
  first.
- **The three artificer infusion item scripts** after `7ebc0f831`.
- **The balor, summoned balor and astral deva death throes** after `f1453ba6b`.
  Kill each next to a character: same damage, same Reflex save, same element.
- **Imbue Arrow** after `fe16d36fe`.
- **Single-target Dispel Magic** after `1dc991700`.

---

# PART B - Class changes

Aqui las cosas si cambian, y cada apartado dice exactamente que. Necesitas un
personaje de la clase; el B4 necesita dos jugadores y en un caso tres.

---

## B1. Warlock - eight repairs and a reset that now cleans up

The reset first, because it is the one that was reported from play. Give a
warlock an essence, have a DM reset them, and confirm the essence is gone: the
damage type, the difficulty bonus, the rider it applies. Then relog and confirm
it is still gone. Before this, a reset warlock kept the essence difficulty bonus
- up to nine points with Utterdark - with no invocation feat left to justify it.

Then the parts of the reset that were found afterwards:

- Arm Horrid Blow on **gauntlets** rather than on a weapon, reset, and confirm it
  is gone. Then arm it on a weapon, swap weapons, reset, and confirm the same.
  Only the right hand was being cleared.
- Spend every slot of one grade, reset, then open the invocation window. The
  grade must read as empty and be selectable again. Before, the feats went and
  the window still counted those slots as spent, so the character could not
  re-pick them.
- Witch Sight is the exception and needs its own pass. Take it from the window,
  fill the other dark slot too, then reset. Witch Sight must still be there, its
  dark slot must still show as occupied, and only **one** dark slot may be free.
  It is the one invocation the reset does not remove, so it has to keep paying
  for its slot.
- Open the invocation window, click an invocation but **do not press Apply**,
  have a DM reset you, and then press Apply. Nothing should happen beyond a
  refused or repeated selection. What must not happen is gaining the Alertness
  feat.
- Not the reset, but the same invocation: a monk with **gloves on and a ranged
  weapon in hand** should now be able to arm Horrid Blow and land it on the next
  unarmed strike. Before, the right hand was checked, the bow was seen, and the
  request was refused without ever looking at the gloves. With nothing in either
  the right hand or the arms slot it should still refuse, with the same message.
- Teleport by shadow, reset, then teleport again by any means at all. You should
  **not** be healed. A leftover marker was giving a free half of maximum hit
  points on the next trip anywhere.
- Reset while in undead shape and confirm nothing of the shape survives it.

The essence must no longer weaken a bigger invocation. Compare the difficulty of
the cone and of doom with no essence active and with Brimstone active. Brimstone
must never make it lower - it was replacing the invocation's own bonus instead of
raising it, so Brimstone made the cone two points easier and doom four.

Chilling Burst against a target with spell resistance high enough to resist:
neither knockdown nor damage. Against one that fails resistance but makes the
save: damage lands, knockdown does not. The damage used to land on a target that
had resisted the invocation outright.

Voracious Dispelling at warlock 16 and above: the damage should be 15, matching
the caster level it actually checks, not the character's real level. Devour Magic
at warlock 21 and above: the temporary hit points should be 20, for the same
reason - the cap was being applied after the effect was already built.

Retributive Invisibility: attack while invisible and confirm the concealment ends
with the invisibility. They used to come apart, leaving fifty percent concealment
running for the rest of the duration.

Eldritch Chain below level 5 and again between 5 and 9: one extra target in both
cases. Below five it used to grant two, so a novice reached further than a
veteran.

Eldritch Cone with the caustic essence: confirm it cannot hit the warlock who
cast it.

The essence rider, twice over. First: apply Brimstone or Caustic to a creature,
log the warlock out mid-effect, and confirm that creature can be affected again
afterwards - it used to become permanently immune to that essence. Second: burn a
creature, have it save on the second tick so the chain stops early, burn it again
straight away, and confirm the second chain runs its full length rather than
being cut short around where the first one would have ended.

---

## B2. Artificer - the alchemist fire bomb, the one that changes numbers

Committed 2026-08-30 in `06d5a7721`.

The bomb's Reflex save was rolled and its result thrown away, so a character who
saved took the same damage as one who failed, on entry and on every six-second
tick. It now works.

- **Stand in the fire and make the save.** Damage must be half. With Evasion,
  none at all. Failing the save must still deal full damage as before.
- **Stay in it for four or more ticks.** The damage must not shrink from one tick
  to the next. A bomb that starts strong and decays means only half the repair
  landed, and that is the specific failure to watch for.
- **The follow-up hits** arrive six seconds later, up to six of them. Their
  damage is their own and should look exactly as it always has. Do not expect
  them to shrink when you save.
- The fire must still end when it used to.

This is a real damage reduction for the artificer. The numbers are the owner's to
revisit now the mechanic is right.

---

## B3. Artificer - four infusions that now do what they say

Committed 2026-09-01 in `214345abd`.

- **The Bazooka gained its 2d6 of fire.** It should now deal about seven more on
  average than before. Compare it with the Flamethrower, which always had that
  bonus and must be unchanged.
- **The Empowerment Bomb only reaches allies and yourself.** Throw it into a
  mixed crowd: your side gets +2 attack and +25% speed, the enemy gets nothing.
  Before this the enemy got both.
- **The Love Sprayer charms instead of dominating.** On a hostile creature that
  fails its Will save, it must stop attacking you and must **not** follow your
  orders. Three rounds, unchanged, and spell resistance must still block it.
- **Rockbreaker deals sonic on a critical too.** Land a normal hit and a
  critical on a creature with sonic resistance. Both must be reduced by it now;
  before, the critical went through as magical damage.

---

## B4. Artificer - the Armorer, which stacked infusions meant to replace each other

Committed 2026-09-01 in `bea7988de` and `fd81e40e3`.

Every Armorer infusion retunes the same armour, so one should end the last. Two
were not being ended by anything.

- Cast the **Antidamage Field**, then Cyborg. The damage reduction must be gone.
  Before, you kept both.
- Repeat with the **Detection Field**, which is the one worth two passes because
  its timer is counted in turns - twenty minutes at caster level 20. Cast it,
  switch infusion, and confirm it stops detecting.
- **Repel** was the one branch that cleaned up nothing at all, so it was the free
  way to keep a field running while attacking. With any field up, use Repel and
  confirm the field ends.
- **Cyborg's lock.** Cast Cyborg, confirm the speed, then switch to anything
  else. The speed goes, as it always did, and Cyborg must be castable again
  straight away. Before, you waited out the full original duration holding
  neither.
- **Sticky Goo's lock.** Hit a target, have **both** the slow and the attack
  penalty dispelled, and confirm you can apply the goo again at once. Then the
  case that must **not** work: dispel only one of the two, and the goo must still
  refuse while the other runs.

And the case that must be invisible: every infusion's own effect must still land
normally after the cleanup runs, including the one being cast.

---

## B5. Artificer - two saves rolling against the wrong element

- **The Force Bazooka** rolled against fire while dealing force damage, and now
  rolls against no subtype at all - NWN has twenty-one and none of them is force.
  A character with a large fire saving throw bonus must no longer be helped by
  it, and nothing replaces it.
- The same test with Spellcraft: zero against fifteen invested ranks. The second
  must now resist three points better. This is a **new** bonus for the defender,
  not a restored one; neither had it before.
- **Repel** dealt sonic damage and rolled against fire. Now sonic. A fire bonus
  stops helping and a sonic bonus starts. Its knockback is untouched: failing the
  second Reflex save must still push you back regardless of how the damage roll
  went.

---

## B6. Archmage - Arcane Fire, which took other people's spells

Committed 2026-09-01 in `bc3a7e44a` and `cb9beaa5e`. **This is the one to test
first.** Everything in it was reachable by any player in the module, not only by
an archmage.

- With an archmage armed, have a **different player** cast any spell anywhere.
  It must work normally, components and all, and the archmage must still be
  armed. Before, that player lost the slot with no effect and no message, and the
  archmage was left armed and unable to re-arm until rest or relog.
- **Two archmages** arm one after the other, then both fire. Afterwards, cast a
  spell needing a material component with a third character and confirm the
  component is still checked. Before this, the module's spell hook was gone for
  the rest of the session.
- Arm, then rest. Arm, then log out and back in. Arm, log out, and have somebody
  **else** cast before you return. In all three the next spell must behave
  normally.
- Arm and cast something Arcane Fire cannot convert: from a wand, or with the
  target dead, or with the target friendly. The spell must go off as itself and
  Arcane Fire must **still be armed**. All four used to spend the slot for
  nothing.
- Then the ability: arm, cast a ninth-level spell at a hostile target, confirm
  the touch attack and the damage. Repeat until a critical lands - it must deal
  double, which it did not before.

---

## B7. Archmage - the focus and the spell it must never hold

Committed 2026-09-01 in `8298594c9` and `1162e8e81`.

- Try to store **Time Stop**: refused, as it already was, and the focus keeps
  whatever it held.
- Store and activate a **different ninth-level spell**: unchanged.
- The case this fixes needs a DM to set `SPELL_ID` to 185 on a focus directly.
  Activating it must refuse, say so, and leave the focus **empty**. Storing a new
  spell afterwards must work and the uses per day must be unchanged.
- Then activate that emptied focus **again without storing anything**, and do the
  same with a focus straight from a level-up that has never held a spell. Both
  must say the focus is empty and cast nothing. **Before this, both cast Acid
  Fog** - an absent stored spell reads as zero, and spell row zero is a real
  spell.

---

## B8. The !test command

Committed 2026-09-01 in `a46359ffa` and `53860a880`.

- Type `!test`: you arrive at the spell testing point and the words are not
  spoken. Try it while walking and while in combat.
- Try it in every channel you can - talk, shout, party, whisper.
- Confirm it ate nothing else: `!d20` and the other dice commands still work.
- The case that decided where it sits in the command list: **start writing a
  book, type `!test`**, and confirm you travel rather than writing the word into
  the page and spending the ink.

---

# PART C - Four measurements, before the caster level work

These are not bug reports. They are questions no file in the repository can
answer, and the answer decides what gets written. Each one is two characters and
five minutes. Recorded 2026-09-02 from
`documentation/pending-changes/caster-level.md` section 12c.

## C1. Does the warlock have a caster level at all?

`classes.2da` row 57 is the only spellcasting class in the project - and the only
one in vanilla 8193.37 - whose `CLMultiplier` cell is empty. Since build 8193.36
the engine multiplies every caster level by that cell. If an empty cell reads as
zero, the warlock's engine-side caster level is zero.

- Take a warlock and a wizard of the **same total level**.
- Cast something whose **duration** is stated per caster level. For the wizard
  any buff will do; for the warlock use an invocation with a stated duration.
- Compare how long each lasts.
- Then repeat with a warlock/wizard multiclass and confirm which half is
  affected.

**It is a failure if** the warlock's durations behave as though he were level
zero or level one, while the wizard's scale normally.

## C2. Does Empower still work on an area spell's ticks?

Thirteen area scripts read the metamagic from inside the area, where there is no
caster to read it from. If that returns nothing, Maximize and Empower have never
applied to any tick after the first.

- Cast **Nube aniquiladora** normally. Note the damage of one tick.
- Cast it **potenciada**. Note the damage of one tick.
- Repeat with **maximizada**.
- Do the same with **Bruma ácida** and **Muro de fuego**.

**It should be** +50% on every tick when empowered and maximum dice when
maximized. **It is a failure if** the ticks are identical to the unmodified cast
while the entry damage is not.

## C3. Does a wall outlive its caster correctly?

- Cast **Muro de fuego** or **Tentáculos negros de Evard**.
- Walk far away, or have the caster log out, while the area is still up.
- Have someone else walk into it.

**It is a failure if** the damage drops once the caster is gone or out of range.
The area is supposed to keep the caster level it was created with.

## C4. Can a first-level sorcerer cast at all?

- Make a **sorcerer of class level 1** - not a multiclass, not a higher level.
- Try to cast one of his three first-circle spells.

**It is a failure if** he is told *"Este conjuro es de nivel demasiado alto para
ti."* His cantrips will work either way, so test a real first-circle spell.

---

## Still owed to the owner, not to the tester

- A hak repack for `spells.2da` row 1406, the force bazooka's targeting circle,
  and `vfx_persistent.2da` row 67, the humidifier's exit script name.
- Whether the alchemist fire bomb's dice should go up now that saving against it
  halves the damage. Nothing is broken either way; the mechanic is right and the
  bomb is simply weaker than it was.
