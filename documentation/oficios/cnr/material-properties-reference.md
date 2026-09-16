# `material_properties` — Value Reference

How to write a correct `INSERT` into `material_properties`. Every constant table
below was read from this server's own data, not from memory.

Sources, in order of authority:

| Constant family | Source | Note |
|-----------------|--------|------|
| Damage types | `haks-2da/iprp_damagetype.2da` | **Server-modified.** Rows 16-18 are custom |
| Custom damage types | `src/shared/nss/pb_constantes.nss:1008-1010` | `FUERZA=16`, `VENENO=17`, `PSIQUICO=18` — matches the 2da |
| Racial types | `haks-2da/racialtypes.2da` | Plus PDB custom races in `pb_constantes.nss:53-104` |
| Damage bonus, alignment, immunity, saves, spell failure | Base game `nwscript.nss` | Not overridden by any hak in this repo |

---

## 1. Row shape

```sql
INSERT OR REPLACE INTO material_properties VALUES
  (material, type, gem, propertyType, subtype, value1, value2);
```

`UNIQUE(material, type, gem, propertyType, subtype)` — two rows differing only in
`value1`/`value2` **collapse into one**, last write wins. You cannot express
"two of the same property" by repeating the row.

The meaning of `subtype`, `value1`, and `value2` is **different for every
`propertyType`**. Section 3 is the contract.

---

## 2. Constant tables

### 2.1 Damage types — `iprp_damagetype.2da` (server-modified)

| # | Label | | # | Label |
|---|-------|---|---|-------|
| 0 | Contundente | | 10 | Fuego |
| 1 | Perforante | | 11 | Necrotico |
| 2 | Cortante | | 12 | Radiante |
| 3 | Subdual | | 13 | Trueno |
| 4 | Fisico | | 14 | Base |
| 5 | Magico | | 15 | Fisico (dup) |
| 6 | Acido | | **16** | **Fuerza** (custom) |
| 7 | Frio | | **17** | **Veneno** (custom) |
| 8 | Divino | | **18** | **Psiquico** (custom) |
| 9 | Relampago | | | |

Rows 0-13 match stock NWN (`Relampago`=ELECTRICAL, `Trueno`=SONIC,
`Radiante`=POSITIVE, `Necrotico`=NEGATIVE). Rows 16-18 exist **only on this
server** — using them is correct here and would break on a stock server.

The catalogue editor exposes row `4` as **Físico directo**. Physical-opposite
damage is not a damage-type row: it is the separate `DamageBonusOpposite`
property, whose runtime script detects the weapon's base physical type. Row
`15` duplicates the `Fisico` label in the 2DA, is unused by the current
catalogue, and is deliberately not offered for new edits.

`-1` is not a damage type. Physical is `4`.

### 2.2 Damage amount — `IP_CONST_DAMAGEBONUS_*`

| # | Amount | | # | Amount | | # | Amount |
|---|--------|---|---|--------|---|---|--------|
| 1-5 | +1 … +5 | | 9 | 1d10 | | 14 | 1d12 |
| 6 | 1d4 | | 10 | **2d6** | | 15 | 2d12 |
| 7 | 1d6 | | 11 | 2d8 | | 16-20 | +6 … +10 |
| 8 | 1d8 | | 12 | 2d4 | | | |
| | | | 13 | 2d10 | | | |

Trap: **16 is `+6`, not `3d6`.** 20 is `+10`, not `4d6`.

### 2.3 Racial types — `racialtypes.2da`

| # | Race |
|---|------|
| 16 | Elemental |
| **17** | **Fey** (Fatas) |
| 20 | Outsider |
| **24** | **Undead** (No-muertos) |
| 25 | Vermin (alimañas) |
| 28 | INVALID_RACE |

`28` is not "all races" — it is the invalid sentinel. For "all", use the
non-VsRace variant of the property.

### 2.4 Alignment groups — `IP_CONST_ALIGNMENTGROUP_*`

| # | Group | | # | Group |
|---|-------|---|---|-------|
| 0 | ALL | | 3 | CHAOTIC |
| 1 | NEUTRAL | | 4 | GOOD |
| 2 | LAWFUL | | **5** | **EVIL** (Malignos) |

### 2.5 Damage immunity — `IP_CONST_DAMAGEIMMUNITY_*`

| # | % | | # | % |
|---|---|---|---|---|
| 1 | 5% | | 5 | 75% |
| 2 | **10%** | | 6 | 90% |
| 3 | **25%** | | 7 | 100% |
| 4 | 50% | | 8 | **20%** (PDB custom) |
| | | | 9 | **15%** (PDB custom) |

Rows 8 and 9 come from this server's extended `haks-2da/iprp_immuncost.2da`.
`wrap_on_equip_it.nss:424` already relies on index `8` when it rewrites flat
damage resistances.

**These are indices, not percentages.** `value1 = 10` is not "10%" — it is an
out-of-range index and the property is silently discarded. 10% is `2`.

20% **does** exist here as index `8`, unlike stock NWN. No rounding needed.

### 2.6 Saving throws — `IP_CONST_SAVEVS_*`

| # | Vs | | # | Vs |
|---|----|---|---|----|
| 0 | UNIVERSAL | | 8 | FEAR |
| 1 | ACID | | 9 | FIRE |
| 3 | COLD | | 11 | MINDAFFECTING |
| 4 | DEATH | | 12 | NEGATIVE |
| 5 | DISEASE | | 13 | POISON |
| 6 | DIVINE | | 14 | POSITIVE |
| 7 | ELECTRICAL | | 15 | SONIC |

Note there is no `2` and no `10`.

### 2.7 Arcane spell failure — `IP_CONST_ARCANE_SPELL_FAILURE_*`

| # | Effect | | # | Effect |
|---|--------|---|---|--------|
| 0 | -50% | | 5 | **-25%** |
| 1 | **-45%** | | 6 | **-20%** |
| 2 | **-40%** | | 7 | **-15%** |
| 3 | **-35%** | | 8 | **-10%** |
| 4 | **-30%** | | 9 | **-5%** |

Ten constants, indices 0-9, and they are **linear**:
`index = (50 - percent) / 5`.

Indices, not percentages. `value1 = -30` is invalid; -30% is `4`.

**This table has been wrong twice.** It first listed only 0, 4, 5 and 6, so a
carpentry design asking for a 5% reduction was reported as impossible in NWN.
The correction then listed seven values and called that the full set — also
wrong, because only the constants that were guessed at got tested. Every value
above now comes from compiled bytecode:

```bash
# declare the constants, compile, then disassemble
tools/linux/neverwinter/nwn_asm -d out.ncs | grep CONST.I
# -> 9 8 7 6 5 4 3 2 1 0   for MINUS_5, _10, _15, _20, _25, _30, _35, _40, _45, _50
```

`src/shared/nss/cr_onequip.nss:40` had been using
`IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT` all along. When a constant's
value is in doubt, compile it and disassemble; the bytecode is the only
authority — and enumerate the **whole** range, not the values you expect to
find.

### 2.8 Spell resistance — `IP_CONST_SPELLRESISTANCEBONUS_*`

| Index | Resistance | | Index | Resistance |
|-------|------------|---|-------|------------|
| 0 | 10 | | 6 | 22 |
| 1 | 12 | | 7 | 24 |
| 2 | 14 | | 8 | 26 |
| 3 | 16 | | 9 | 28 |
| 4 | 18 | | 10 | 30 |
| 5 | 20 | | 11 | 32 |

These are indices consumed by `ItemPropertyBonusSpellResistance`, not the
displayed resistance values. The complete mapping is defined by the
[NWN Lexicon spell-resistance constants](https://nwnlexicon.com/Ip_const_spellresistancebonus).

### 2.9 On-hit save DC and bonus spell slots

`Stun` and `Silence` store an `IP_CONST_ONHIT_SAVEDC_*` index in `value1`:

| Index | Save DC |
|-------|---------|
| 0 | 14 |
| 1 | 16 |
| 2 | 18 |
| 3 | 20 |
| 4 | 22 |
| 5 | 24 |
| 6 | 26 |

`BonusLevelSpell` stores the spellcasting class in `subtype`, the spell level
in `value1`, and **how many slots at that level** in `value2`. A gem granting
two different spheres carries one row per sphere.

This was documented the other way round until 2026-08-14 - `value2` as a count
of consecutive levels - and the engine matched the wrong reading, so "Esfera
4/2" handed out one fourth-sphere slot and one fifth. Class indices are
`IP_CONST_CLASS_*`: Bard `1`, Cleric `2`, Druid `3`, Paladin `6`, Ranger `7`,
Sorcerer `9`, Wizard `10`. `4` is Fighter and yields an invalid property that
the engine silently drops.

**The eleven named constants are not the limit.** `subtype` is a `classes.2da`
row, and this server's own classes work: `pb_tesoros_inc.nss:1226` grants slots
to Ingeniero/Artifice `64`, Paladin de los antiguos `60`, Paladin oscuro `61`
and Paladin vengador `62`, with Alma predilecta at `59`. Reading the table's
size off `nwscript.nss` is the same mistake section 2.5 records for immunity
index `8`. See the
[class constants](https://nwnlexicon.com/Ip_const_class) and
[`ItemPropertyBonusLevelSpell`](https://nwnlexicon.com/ItemPropertyBonusLevelSpell)
contracts.

---

## 3. Contract per `propertyType`

Read from the shared consumer, `cnr_i_prop.nss`, which is also mirrored by the
standalone `cnr_apply_prop.nss` path. Anything not handled there is dead data;
the catalogue generator rejects such property types.

| `propertyType` | `subtype` | `value1` | `value2` |
|----------------|-----------|----------|----------|
| `DamageBonus` | damage type (2.1) | amount const (2.2), used only when `value2 = 0` | die shorthand — see below |
| `DamageBonusOpposite` | resolved from the base weapon | amount const when `value2 = 0` | die shorthand — see below |
| `DamageBonusVsRace` | racial type (2.3) | damage type (2.1) | amount const (2.2) |
| `DamageBonusVsAlign` | align group (2.4) | damage type (2.1) | amount const (2.2) |
| `DamageImmunity` | damage type (2.1) | immunity index (2.5) | — |
| `EnhancementBonus` | — | bonus 1-20 | — |
| `EnhancementBonusVsRace` | racial type (2.3) | bonus | — |
| `EnhancementBonusVsAlign` | align group (2.4) | bonus | — |
| `ACBonus` | — | AC bonus | — |
| `ACBonusVsRace` / `ACBonusVsAlign` | race / align | AC bonus | — |
| `SavingThrowBonusVs` | save type (2.6) | bonus | — |
| `SpellFailure` | — | ASF index (2.7) | — |
| `SpellResistance` | — | spell-resistance bonus index | — |
| `Regeneration` | — | HP per round | — |
| `VampiricRegeneration` | — | amount | — |
| `Keen` | — | — | — |
| `Stun` / `Silence` | — | on-hit save DC const | — |
| `OnHitSlow` | — | on-hit save DC const | — |
| `BonusLevelSpell` | class | spell level | number of slots at that level |
| `Mighty` | — | STR-damage cap | — |
| `AttackBonus` | — | attack bonus | — |
| `MassiveCriticals` | — | amount const when `value2 = 0` | die shorthand, as `DamageBonus` |

This is the complete current runtime set: **24 property types**. Legacy names
such as `ImmunityType` and `AbilityBonus` are still unhandled by either
consumer and must not be written to the catalogue.

### The four added for carpentry

`Mighty`, `AttackBonus`, `MassiveCriticals` and `OnHitSlow` were added for the
carpentry design. Two traps, both confirmed by compiling rather than assumed:

- **`ItemPropertyMighty` does not exist.** Mighty is
  `ItemPropertyMaxRangeStrengthMod` in NWScript; the obvious name fails with
  `UNDEFINED IDENTIFIER`.
- **`MassiveCriticals` reuses the `DamageBonus` die shorthand**, through the
  same `CnrProp_DamageAmount(value1, value2)` call, so "1d6 massive criticals"
  is authored exactly like "1d6 damage": `value2 = 6`. It is not a raw
  `IP_CONST_DAMAGEBONUS_*` unless `value2 = 0`.

`OnHitSlow` mirrors `Stun` and `Silence`: `value1` is an
`IP_CONST_ONHIT_SAVEDC_*` index, not a DC number. CD 14 is `0`.

### Two consumers must agree

The if-chain exists twice: in `cnr_i_prop.nss`, which the engine calls from
`cnr_i_craft`, and in the standalone `cnr_apply_prop.nss`. **A new property type
must be added to both.** `build_catalogue.py` reads both and refuses to build if
they disagree, so drift is a build error rather than a silent runtime gap.

### `DamageBonus` — the `value2` shorthand

`cnr_i_prop.nss` translates `value2` before calling the engine:

| `value2` | Result |
|----------|--------|
| 4 | 1d4 |
| 6 | 1d6 |
| 8 | 1d8 |
| 10 | 1d10 |
| 12 | 1d12 |
| 20 | **2d6** |
| 0 | uses `value1` directly as an `IP_CONST_DAMAGEBONUS_*` |

So `value2` is a *die size*, except `20` which means 2d6, and `0` which switches
to raw-constant mode. `value2 = 2` or `= 5` matches nothing and yields **no
property at all**.

This shorthand applies **only** to `DamageBonus`. `DamageBonusVsRace` and
`DamageBonusVsAlign` pass `value2` straight through as an
`IP_CONST_DAMAGEBONUS_*` — for those, 1d4 is `6`, not `4`.

### Unsupported legacy alias

`SavingThrowUniversal` is not a runtime property type. Use
`SavingThrowBonusVs` with `subtype = 0` (UNIVERSAL). `SpellResistance` is
supported by both current consumers.

### The `type` column and gems

Gem rows must mirror how the **recipes** declare them, because
`ApplyMaterialProperties` is called with the recipe's own `material`, `type` and
`gem` values:

```sql
-- recipe_metadata: ('recipe_bru_cuarzo_ring', 'Gem', 'Anillo', 'cnr_g_cuar', ...)
-- so material_properties needs:
('Gem', 'Anillo',   'cnr_g_cuar', 'SavingThrowBonusVs', 3, 3, 0)
('Gem', 'Colgante', 'cnr_g_cuar', 'SavingThrowBonusVs', 3, 3, 0)
```

Every gem therefore needs **two rows**, one per jewellery type.

The gem tag must be the **blueprint tag** in `src/shared/uti/bru_*.uti.json`
(short form: `cnr_g_zafe`, `cnr_g_pic`), not a long descriptive name.
`recipe_metadata` originally used long names for 17 gems and matched nothing.

`AttachGemToRing` (`cnr_sql_c_item.nss:182`) is a separate path for socketing
gems into an existing ring; it queries `type = 'Anillo'`. **It currently has no
callers.**

---

## 4. Worked examples

Design: *"Mejora +5 vs Malignos, 1d4 Radiante vs Malignos"* (Plata, arma).

```sql
-- EnhancementBonusVsAlign: subtype = align group, value1 = bonus
INSERT OR REPLACE INTO material_properties VALUES
  ('Plata','Arma','','EnhancementBonusVsAlign', 5, 5, 0);
--                                              ^EVIL

-- DamageBonusVsAlign: subtype = align, value1 = damage type, value2 = amount
INSERT OR REPLACE INTO material_properties VALUES
  ('Plata','Arma','','DamageBonusVsAlign', 5, 12, 6);
--                                         ^EVIL ^Radiante ^1d4
```

Design: *"2d6 Mágico vs Fatas"* (Hierrofrio, arma).

```sql
INSERT OR REPLACE INTO material_properties VALUES
  ('Hierrofrio','Arma','','DamageBonusVsRace', 17, 5, 10);
--                                             ^Fey ^Magico ^2d6
```

One row. Two `1d6` rows would collide on the UNIQUE key and leave a single 1d6.

Design: *"Resistencia 10% Frío"* (Hierro, armadura).

```sql
INSERT OR REPLACE INTO material_properties VALUES
  ('Hierro','Armadura','','DamageImmunity', 7, 2, 0);
--                                          ^Frio ^10% index
```

Design: *"1d6 Fuego"* (Hierro Enardecido, arma) — plain `DamageBonus`, so
`value2` is the die size:

```sql
INSERT OR REPLACE INTO material_properties VALUES
  ('Hierro Enardecido','Arma','','DamageBonus', 10, 0, 6);
--                                              ^Fuego     ^1d6
```

---

## 5. Checklist before writing a row

1. Is the `propertyType` handled by `cnr_sql_c_item.nss`? If not, the row is dead.
2. Does `subtype` mean damage type, race, align, or save here? Section 3.
3. For amounts: is this the `DamageBonus` die shorthand, or a raw
   `IP_CONST_DAMAGEBONUS_*`? They are different numbers for the same die.
4. Immunity and spell-failure values are **indices**, never percentages.
5. Will this row collide with an existing one on
   `(material, type, gem, propertyType, subtype)`?
6. Custom damage types 16-18 are PDB-only — intended, but note it.
7. **Does the row match the design table for that material and garment?** The
   seed is hand-written and nothing cross-checks it against the design.

### A property the base item cannot carry is discarded in silence — 2026-08-23

The mithril helmet gave its armour class and nothing else. The seed asked it for
arcane spell failure reduction, and **`itemprops.2da` leaves column `7_Helm`
empty on row 84**, so the engine rejected the property and said nothing. The
mithril armour and shield keep theirs: column `6_Arm_Shld` allows it. Only the
helmet has no column for it. It carries 15% slashing resistance instead, which a
helmet does accept.

Every property of every recipe was then crossed against the column its base item
uses, resolving variants to each product they can make. **That was the only
impossible combination in the catalogue.** The sweep is worth repeating whenever
a property is written for a kind of item that did not carry it before:

| Ask | Where |
|---|---|
| Which row is the property? | `itempropdef.2da`, by label |
| Which column does the item use? | `baseitems.2da`, `PropColumn` |
| Is it allowed? | `itemprops.2da`, that row and that column; `****` means no |

### Provisioned tier-4 smithing defence matrix — 2026-09-01

This is the compact review table for the properties written by
`migration/03_catalogue.sql` into `cnr_recipe_property`. It records the actual
database provision, not the older summary text in the smithing JSON or CSV.
The ordinary recipes grant AC +5 and the recipes named `ligera` or `ligero`
grant AC +4.

| Metal | Recipe | Armour | Shield | Helmet |
|---|---|---|---|---|
| Metal vivo | Ordinary | AC +5; Regeneration 1 | AC +5; Regeneration 1 | AC +5; Regeneration 1 |
| Metal vivo | Light | AC +4; Regeneration 1 | AC +4; Regeneration 1 | AC +4; Regeneration 1 |
| Mithril | Ordinary | AC +5; -30% arcane spell failure | AC +5; -25% arcane spell failure | AC +5; 15% slashing immunity |
| Mithril | Light | AC +4; -30% arcane spell failure | AC +4; -25% arcane spell failure | AC +4; 15% slashing immunity |
| Adamantita | Ordinary | AC +5; 20% slashing immunity | AC +5; 20% bludgeoning immunity | AC +5; 20% piercing immunity |
| Adamantita | Light | AC +4; 20% slashing immunity | AC +4; 20% bludgeoning immunity | AC +4; 20% piercing immunity |

The mithril helmet substitution is intentional. `SpellFailure` is not valid
for helmets in this module's item-property tables, so the provision gives it
15% slashing immunity instead. The matching recipe-property rows are the AC +5
block at `migration/03_catalogue.sql:1969-2104` and the AC +4 block at
`migration/03_catalogue.sql:2105-2140`.

### The rows are not generated, so they drift — 2026-08-20

Four leather rows shipped with the wrong armour class: herbivore belt, cloak,
boots and bracers carried AC 1 where the design table gives them AC 2. Five of
the six herbivore garments carry AC 2 - armour, belt, cloak, boots and bracers -
and **gloves carry none**, only 1d4 slashing, so they were correct as written
and were not touched. The armour rows of the same hide were right too, which is
why the four wrong ones read as a deliberate rule for accessories. It was not
one.

Testers found two of them, the cloak and the bracers, because those are
sastrería recipes. The other two are peletería and nobody had looked. A full
comparison of all ninety hide-and-garment combinations against the design CSV
found those four and nothing else; the damage immunities all matched.

Worth knowing why it is possible: the smithing design is cross-checked, the
generator refuses to build when `herreria.json` and the smithing CSV disagree.
Nothing does that for `material_properties`, which is written by hand. Comparing
a trade's rows against its design table is a manual job, and it is worth doing
whenever a tester reports a number that does not match the sheet.
