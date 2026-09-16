# CNR — Findings, technical debt and parked ideas

Running log. Anything discovered about the crafting system that is not fixed
yet goes here: defects, half-finished work, and ideas worth keeping.

Rules for this file:

- One entry per thing, with the evidence that makes it real — a file and line,
  a query, an observed behaviour. An entry with no evidence is a guess and does
  not belong here.
- **A closed entry gets deleted, not annotated.** Git holds the history, and the
  document that owns the behaviour holds the reasoning.
- If an entry grows into a design of its own, move it to its own document and
  leave a one-line pointer.

Last reviewed 2026-09-01.

---

## Findings

### F1. Production station instances have never been inventoried

The repository only holds `testarea_oficios`, with one instance of each of the
ten stations. Production almost certainly has more, in towns and player areas,
and this repository cannot see them.

It matters because **a placed instance carries its own copy of the event
fields**, not a reference to the blueprint. A bench placed before the migration
still points at whatever script it was placed with, so it will not open the new
menu — it will do nothing, or run dead legacy code. Every placed instance needs
the current contract:

- its tag seeded in `cnr_station`;
- `OnUsed = cnr_device_ou`;
- `OnInventoryDisturbed`, `OnOpen` and `OnClosed` empty.

An unknown tag reports a configuration error on purpose and has no legacy
fallback, so a missed bench fails loudly rather than silently.

The ten station blueprints are consistent now: all eleven live in
`src/cnr/utp/` with `tag` = `resref` = filename, `OnUsed = cnr_device_ou` and
`Conversation = cnr_c_station`. The two that left `Conversation` empty were
filled on 2026-08-16, and `cnrJewelersBench` and `cnrSewingTable`, which had no
blueprint at all, were created. Only `cnrArcaneTable` has empty events, because
arcane is not built.

### F2. Decide what the help bonus should be worth

`cnr_i_craft.nss:735`. The roll is `d20 + profession level + help`, and help is:

```
ability   = floor( (mod(ability_1) + mod(ability_2)) / 2 )
craft     = base Craft ranks / 5
help      = floor( (ability + craft) / 2 )
```

The second averaging is what makes it small. Concretely:

| Abilities | Craft ranks | help |
|---|---:|---:|
| 12 / 12 (+1/+1) | 0 | **0** |
| 14 / 14 (+2/+2) | 0 | **1** |
| 14 / 14 | 10 | **2** |
| 18 / 18 (+4/+4) | 20 | **4** |

So a maxed character gets +4 while profession level alone gives up to +20. The
help is close to noise, and for an average character it is exactly nothing.

This is a design decision, not a defect — it does what it was written to do.
Three ways to go, whenever it is picked up:

1. **Leave it.** Level is the profession; abilities are a rounding detail.
2. **Drop the second halving** (`help = ability + craft`). Doubles it: the
   14/14 character gets +2 with no ranks, the maxed one +8.
3. **Make Craft ranks matter more**, by lowering `CNR_CRAFT_RANKS_PER_BONUS`
   from 5. Rewards the investment rather than the character sheet.

Testers have been told the `0 (ayuda)` in the roll message is expected, so
nothing is blocked either way.

### F3. Agitated Potion passes an invalid movement-speed value

`pb_potion_inc.nss:515` calls `EffectMovementSpeedIncrease(150)`. The native
contract in `documentation/nwscript/reference/nwscript.nss:7626` limits the
argument to 0 through 99. The engine behaviour outside that range is not
defined by the API and must not be treated as a 150% increase without an
in-game probe.

### F4. Obtuse and Dazing Potions are exact effect duplicates

`pb_potion_inc.nss:702-710` gives both potion cases the permanent
`DISEASE_BURROW_MAGGOTS` effect. The catalogue exposes them as two different
recipes, `Poción Obtusa` and `Poción Atontadora`. No design source establishes
that the duplicate is intentional; decide which disease Dazing Potion should
use before documenting the two as separate effects.

### F5. Acoustic and Aware Potions build effects from an uninitialised link

In case 10, the two lines that would initialise `eLink` are commented out and
`pb_potion_inc.nss:247` applies it anyway. The +14 Listen bonus beside it is
still applied through `DoNoStackSkillBonus`, so the malformed application is a
separate no-op.

Case 70 starts with `EffectLinkEffects(eLink, eVis)` at line 840, again before
`eLink` has a value, and later applies the resulting link twice. Its +7 Spot and
Listen calls are separate and should still run. The skill bonuses and visuals
need independent in-game checks before this is fixed.

### F6. Unhealthy Potion is implemented but cannot be crafted

`pb_potion_inc.nss:745-749` implements potion id 63 as Bebilith Venom. There is
no `sute_her_063*` output in `documentation/oficios/alquimia.json` or in the
generated catalogue, so the case is unreachable from the current profession.
Either restore the recipe deliberately or remove the dead branch.

### F7. Three designed poisons disagree with the runtime poison table

The recipe tags select rows in `haks-2da/poison.2da`, but three rows do not
match `documentation/oficios/Oficios Basicos - Etapa 2 - 2025 - Venenos.csv`:

| Recipe | Runtime row | Design | Runtime table |
|---|---:|---|---|
| Raíz de Sanguinaria | 4 | 1d6 WIS, then 1d4 WIS | 1d3 WIS, then 1d4 CON |
| Aceite de sangreverde | 3 | 1 CON, then unconsciousness | 1 CON, then 1d2 CON |
| Veneno de Araña | 36 | 1d4 INT, then 2d6 INT | 1d4 STR, then 1d4 STR |

The player table keeps the reviewed design values so testing exposes the
disagreement. Decide whether the recipe tags or `poison.2da` rows are wrong.

### F8. Poisoned drinks have overlapping application paths

The same `_envenenada` tag is decoded and applied in
`cerr_venom_activ.nss:21-34`, `cwa_enforcer.nss:46-64`, and
`nw_s3_alcohol.nss:35-52`. The module activation path always executes
`cerr_venom_activ` from `pb_mod_activate.nss:2581`; spell-backed potions can
also pass through the pre-spell hook, while alcohol has its own spell script.
This is duplicated ownership and may apply the poison twice. Confirm the event
order in game before consolidating it.

### F9. Fury Potion clears the module's actions, not the drinker's

`pb_potion_inc.nss` runs as an include from the module's OnActivateItem script,
so `OBJECT_SELF` is the module. Case 104 calls bare `ClearAllActions()` at line
1298 even though the surrounding polymorph cases use
`AssignCommand(oPC, ClearAllActions())`. The comment says this prevents an
exploit, but the current call does not clear the player's queue.

---

## Technical debt

### D1. The old arcane resources are still lying around

The arcane trade itself is built and has been played: station, window, 105
properties, 442 steps, and a tester enchanting a longsword on 2026-08-23. What
this entry is now down to is the debris of the system it replaced, all of it
inert:

| Resource | What it is | State |
|---|---|---|
| `pb_ofi_artesa` | "Mesa de artesania urdimbrica", the old station | `OnUsed` empty, `OnClosed` points at `pb_ofi_artesa_c`, **which does not exist in `src/`**. Placed twice in `testarea_oficios`, where it does nothing |
| `pb_ofi_varita_es` | "Varita esenciadora", the wand meant to capture essences | Casts spell 329, which `spells.2da` calls `DELETED_PRO_Elec`. It casts elemental protection, not essence capture. Two placed in the shop area |
| `sapo_esencia_enc` | "Alas de Pixie", enchantment-school essence powder | Old naming, and the `cnr_e_*` family already carries a Polvo de encantamiento |
| `sapo_vendobj` | Placeable for selling crafted goods | Old profession system |

The two `pb_ofi_*` are placed in areas and would confuse a player who walks
into them expecting the working table. The two `sapo_*` need a decision rather
than a deletion.

Related: [`arcane-unused-blueprints.md`](arcane-unused-blueprints.md) lists the
53 `cnr_e_*` / `cnr_c_*` blueprints no material claims, which is the same
kind of cleanup and waits on the same thing — the trade being played enough to
know what is really unused.

### D2. Carpentry's four property types have never been seen on an item

`Mighty`, `AttackBonus`, `MassiveCriticals` and `OnHitSlow` are implemented in
the engine and carried by 56 recipes, but no crafted item has been inspected in
game to confirm the constructors produce what the tables say. It is on the
tester plan; until a tester reports back, treat it as unproven.

### D3. The timelock library announces once and never again

`inc_timelock.nss` is used by eleven scripts and 89 call sites: potions,
teleport, the vampire feats, stealth events, drinks, the warrior strike and two
feats. Three defects were fixed on 2026-08-23 — a frozen clock, a permanent lock
that poisoned every other question in the same script, and messages muted at
creation so no caller could ever switch them on.

**Correction, 2026-08-23.** An earlier version of this entry claimed a cooldown
does not survive a relog or a rest, because the timestamp is stored with
`SetTempInt(..., TEMP_VARIABLE_EXPIRATION_EVENT_REST)`. That was wrong, and it
was wrong from reading the constant's name instead of finding its consumer:

```nwscript
void SetTempInt(object oObject, string sVarName, int nValue, int nExpirationEvent)
{
    SetLocalInt(oObject, sVarName, nValue);
    _TrackTempVariable(oObject, sVarName, TEMP_VARIABLE_TYPE_INT, nExpirationEvent);
}
```

It is a plain `SetLocalInt` plus a note of when the variable *ought* to be
dropped — and **nothing ever reads that note**. `DeleteTempVariables` is called
from nowhere in `src/`, and the only script that includes `inc_tempvars` is
`inc_timelock` itself. The expiration flag is decorative.

So the storage is **the same mechanism the potions used before the timelock
move**: a local on the PC holding a real wall-clock timestamp, which
`GetIsTimelocked` compares against the present. Whatever durability the old
`SetLocalInt(oPC, sNumPocion, …)` had, the library has too. Nothing regressed.

What remains, and is structural:

- **The "available again" notice is lost on relog, and nothing brings it back.**
  It is fired by a `DelayCommand`, which dies with the session. `UpdateTimelocks`
  exists to walk the character's locks and reschedule exactly that — and **it is
  called from nowhere**. So the lock itself keeps working after a relog, the
  refusal message still gives the right countdown, but the green line never
  arrives.

  **Accepted, 2026-08-25: losing the floating notice on disconnect is not a
  problem today.** The entry stays because the fix has a direction, not because
  it is urgent.

- **`UpdateTimelocks` cannot simply be wired up, and the reason is an engine
  change.** It enumerates with `NWNX_Object_GetLocalVariableCount` and then calls
  `NWNX_Object_GetLocalVariable(obj, i)` once per index. The plugin's own header:

  > *As of build **8193.14**, this function takes **O(n) time**, where n is the
  > number of locals on the object.*
  > *As of build 8193.14 local variables **no longer have strict ordering**.*

  `Object.cpp` confirms it: each call walks the variable map from the start to
  reach `index`, so the loop is **O(n²)** — 125,000 map iterations for a
  character carrying 500 locals, two million for 2000, on the login path. The
  server runs `build8193.37`. The function was written when iterating locals was
  cheap and ordered, and it is now neither. **This is what "the timelock system
  lost steam" actually was.**

- **The direction when it is picked up: put the cooldowns in PWDB.** Not a list
  of active locks in a local variable, which was the first idea — the answer is
  the database that already holds per-character state, alongside `pwdb_*` and
  the identity `PWDB_ResolveCharacterId` resolves at login. Then the reschedule
  reads three rows instead of walking a variable table, it survives a restart by
  construction rather than by the variable container happening to keep it, and
  the NWNX iteration order stops mattering.

- ~~**The announcement can be a second early.**~~ Fixed 2026-08-25.
  `_UpdateTimelock` treated one second remaining as expired. It now removes the
  lock only at zero and sleeps a lone remaining second rather than announcing
  early — falling straight through to the update branch would have printed a
  "one second remaining" nobody needs.

Settled on the storage question: the module keeps a variable container that is
not going away — it carries state from several older systems — and the cooldown
timestamp is verified against it, so it does survive a restart today. That is
not a reason to leave it there forever, which is what the PWDB note above is
about, but nothing is broken by it now.

### D5. A reply in the station menu renders without its label

Testers keep reporting that a reply in the crafting menu loses its text, most
often `[Atras]`. On 2026-08-23 one of them established the decisive fact: **the
reply is still there.** Pressing its number works -- 6 pages forward, 7 goes
back -- and only the label is missing. An earlier screenshot showed the fifth
line cut in the middle of a word with nothing after it.

That rules out what the previous attempts were aimed at. The links and the
`Active` conditions are not the fault: had a condition failed, the reply would
be absent and the numbering would shift.

**What is established.** Custom tokens are expanded by the *client*, not by the
server. `CNWSMessage::SendServerToPlayerDialogReplies` takes the reply strings
plus an `oidTokenTarget` and a gender
(`nwnxee/NWNXLib/API/API/CNWSMessage.hpp:250`), so the text travels with its
`<CUSTOM####>` markers unexpanded and each client resolves them against its own
`CTlkTable::m_pTokensCustom` (`CTlkTable.hpp:29-31`), synchronised separately by
`SendServerToPlayerSetCustomToken` and `SendServerToPlayerSetCustomTokenList`
(lines 152-153).

**What is not established, and must not be written down as if it were.** That
mechanism explains how a label *could* come out empty; it does not prove it is
what happened here. Nothing has been reproduced, no packet has been traced, and
no threshold has been measured. A client parsing failure, a dropped message or a
rendering fault would look the same from the player's chair. Treat the token
table as the leading candidate, not as the cause.

**The numbers, corrected on 2026-08-23** after an audit found the first version
of this entry wrong on every count:

| When | Button labels |
|---|---|
| `c13a4f7cb`, 2026-08-08 | 13 plain strings in the `.dlg` |
| `97612e2fb`, 2026-08-17 | 8 tokens **shared by label** across 13 replies |
| `710abba61`, 2026-08-19 | back to 13 plain strings, when the colour attempt was reverted |
| `b571eb38c`, 2026-08-20 | 13 tokens, one per reply |

So the fix of 2026-08-20 went from **eight shared tokens to thirteen unique
ones**, not from five. Per screen the menu now asks the client for **20** token
values on the root, category, product and variant nodes -- 2 header, 13 button,
5 slot -- and 15 on the detail node, whose own `<CUSTOM5012>` is filled by the
action script rather than by the conditional. Whether that is enough to matter
is exactly what has not been measured.

The blanks were observed both while the buttons shared eight tokens and now that
they hold thirteen. Whether they ever appeared during the two days the labels
were plain strings is **not recorded**, and that is the cheapest experiment
available: put the thirteen labels back in the `.dlg` as plain text, lose the
green, and see whether the reports stop. If they do, the token path is the
fault; if they do not, it never was.

**The other way out, when the slice is opened.**
`NWNX_Dialog_SetCurrentNodeText()` sets the node's text on the server, so no
token is involved. The plugin is enabled -- `NWNX_DIALOG_SKIP=n` in
`config/nwserver.env` -- and `nwnx_dialog.nss` is already in
`src/shared/nss/`. Two things to plan for:

- It only works from a starting conditional, and **eleven of the thirteen fixed
  button replies have none**: `Crear nueva produccion`, `Crear por ID`, `Abrir
  inventario` and `Terminar` on the root; `[Atras]`, `Abrir inventario` and
  `Terminar` on the three list screens; and `Fabricar`, `[Atras]`, `Abrir
  inventario` and `Terminar` on the detail screen. Only `[Pagina siguiente]` and
  `[Pagina anterior]` are conditional today. `build_station_dlg.py` would have
  to give every reply a condition script, parameterised the way `cnr_c_slot`
  already is.
- Whether a colour code survives text injected at runtime is **unknown**.
  Writing `<c...>` into the `.dlg` itself was tried on 2026-08-19 and left the
  menu unreadable in game, but that is a different path: a token's *value*
  carries colour today and renders correctly, so the two are not parsed alike.
  If injected colour comes out as garbage, the labels lose their green and keep
  their text, which is the better trade.

### D4. The runtime smoke test has not been run end to end

Static checks do not prove engine behaviour. Still to cover:

- category and recipe ordering at representative profession levels;
- component consumption on both success and failure;
- coal consumed only as a forge recipe component;
- station tool requirements and breakage;
- per-station animation and sound;
- roll and XP persistence across reconnect and server restart;
- two players crafting at the same inventory station;
- all 79 crafted `sute_her*` potion effects through `pb_potion_inc`;
- all 27 poisons in their wound, contact, ingestion or inhalation path;
- Pure Water, Edible Roots, Magic Juice and the FoodRICH Magic Cookie producing
  no potion effect.

---

## Parked ideas

- **Socketing smithing pieces with jewellery.** Dropped for now. The
  `CNR_ENGARZADO` mark it was designed around stays, because on its own it
  already stops a finished jewel from counting as material again.
- **Masterwork results and generated crafted-item descriptions.** Helper code
  is in the tree and dormant by explicit decision; it has no runtime effect.

---

## Variantes de producto — 2026-08-17

**Cerrado**: el oficio ya no necesita una receta por producto. `cnr_variant` y
`cnr_recipe.variant_group` permiten una receta por material, y el menú pregunta
qué fabricar. Catálogo: 1226 → 505 filas.

**Cerrado**: el daño opuesto de las once armas que hacen dos tipos. Se les daba
el que ya tenían; ahora reciben el tercero.

**Abierto, y sale de este cambio:**

1. ~~**88 recetas más son la misma receta repetida.**~~ **Decidido el
   2026-08-17: se quedan como están.** En herrería (71), carpintería (16) y una
   de joyería, para cada material el escudo grande, el pequeño, el pavés, el
   yelmo y las dos armaduras comparten todo menos el producto y el molde, y
   colapsarlas dejaría el catálogo en 417 filas en vez de 505.

   No se hace: **la separación actual se lee mejor y cuesta menos de mantener
   que el ahorro que da**, y cada uno de esos productos pide su propio molde,
   lo que además obligaría a que una variante pudiera cambiar componentes. Un
   17% menos de filas no lo justifica. Las armas eran otra cosa: allí sobraban
   721.

2. **Un molde por familia.** Todas las armas de herrería piden
   `molde_esplarga`. Funciona, pero un molde de espada para hacer un hacha
   chirría. Serían cinco o seis moldes nuevos, en la paleta y en
   `tienda_herreria`.
3. **El látigo no tiene propiedades.** Las de peletería se buscan por tipo de
   prenda y un látigo no es una. Hay que decidir qué le corresponde.
