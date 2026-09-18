# CNR naming contract

Every blueprint the CNR owns lives under `src/cnr/` and is named `cnr_*`, with its
tag equal to its resref. That makes a rename a mechanical, checkable operation and
lets the trade be lifted into another module whole.

`python3 migration/build_catalogue.py --check` enforces this contract on every run
and refuses to generate the catalogue when it is broken. How the names were
reached is recorded in [`history/cnr-naming-normalisation.md`](history/cnr-naming-normalisation.md).

## The scheme

A resref is capped at **16 characters**, so prefixes are short and the rest is an
abbreviation.

| Prefix | What |
|--------|------|
| `cnr_b_*` | base item a recipe builds on; `cnr_b_veneno_*` the poison flask bases |
| `cnr_e_<n>` | arcane essence |
| `cnr_c_<n>` | arcane crystal |
| `cnr_g_*` | rough gem, out of a vein |
| `cnr_q_*` | cut gem |
| `cnr_j_an_*`, `cnr_j_am_*` | ring, amulet |
| `cnr_m_pe_*`, `cnr_m_li_*` | nugget, ingot — coded by the vein that drops it |
| `cnr_m_pi_*`, `cnr_m_cu_*` | hide, leather |
| `cnr_m_le_*`, `cnr_m_ta_*` | log, plank — named by the wood the player sees |
| `cnr_p_*` | component and processed stock: plants, reagents, grit `po`, rods `ci`, blanks `ar`/`ca`, parts |
| `cnr_t_*` | tool: mould `mo`, template `pl`, kit, work gloves `gu`, hammers, needle, skinning knife |
| `cnr_arb_*`, `cnr_veta_*`, `cnr_pl_*`, `cnr_gema_*` | harvesting nodes: tree, ore vein, plant, gem vein |
| `cnr_almacen`, `cnr_almacen_u` | the material store's chest and its display chest |

Names follow what the player sees, not a legacy suffix: `carplenyo_cipres` was
always shown as cedar and is `cnr_m_le_cedro`, dropped by `cnr_arb_cedro`.

## The exceptions, complete

| Exception | Why | Where it is declared |
|-----------|-----|----------------------|
| Potions `sute_her_*` keep their names and tags | `pb_mod_activate` dispatches on the `sute_her` tag prefix, and potion tags carry codes such as `sute_her_DM1` | `POTION_PREFIX` |
| `cnr_t_martlig_2..4` carry tag `cnr_t_martligero`; `cnr_t_aguja_peq` carries `cnr_t_aguja`; `cnr_t_desol_peq` carries `cnr_t_desollador` | several blueprints must satisfy one station tool, which the engine checks by tag. Owner decision, 2026-09-16 | `SHARED_TOOL_TAGS` |
| Stations and resource chests are named `cnr` + CamelCase (`cnrAnvilSmith`) | the tag is the key `cnr_station` and the scripts use | `ENGINE_PLACEABLE` |
| `sapo_alma_migr.nss` names retired identifiers | it converts persisted store keys from old names to new ones | `STORE_KEY_MIGRATION` |

Script file names are not blueprints and are not part of the contract.

## What the check refuses

- An item under `src/cnr/uti` whose file name differs from its resref, whose
  resref is over 16 characters, that is not named `cnr_*`, or whose tag differs
  from its resref, outside the exceptions above. An exception that names a
  blueprint no longer on disk is refused too.
- A placeable under `src/cnr/utp` with the same faults, where the name may also
  follow the station convention. A `cnr_*` placeable's file name is exactly its
  resref; a station's is its resref in lower case (`cnrAnvilSmith` lives in
  `cnranvilsmith.utp.json`), because unpacking writes file names in lower case.
- A `cnr_*` item or placeable, or a `sute_her_*` item, under `src/shared`, judged
  by the blueprint's own resref as well as its file name.
- A recipe base, extra product or component, a station tool, a material store
  entry, or a `CNR_MATERIAL` drop on a node blueprint or a placed node, that names
  no CNR item.
- A CNR blueprint with no palette entry, or a CNR item palette entry that names
  nothing.
- In any script under `src`, including the NUI scripts in `src/cnr/nui`,
  comments excluded: a `"cnr_..." +` or
  `"sute_her_..." +` concatenation that prefixes no existing blueprint, or a
  literal in an item namespace that names no CNR item.
- In either generator, a string ending in `_` that is a `cnr_`/`sute_her_`
  prefix and prefixes nothing, or a literal in an item namespace that names
  nothing.
- A recipe with a material whose profession's progression list is empty.

The last three rules exist because the rename slices kept finding code that went
on running after a rename and silently stopped matching: `startswith("bru_")`
emptied the jewellery progression, `"cnr_cristal" + n` created nothing, and
`row["metal"] + "_aro"` named a blueprint that no longer existed.

## Renaming something

1. Map old to new from what the player sees, and check the 16-character limit
   and collisions first.
2. Map every reference by resref **and** tag, case-insensitively, including
   concatenations in scripts and generators.
3. Replace only whole identifiers bounded by a quote, backtick or list separator,
   so prose that happens to use the same word is untouched. Where one string is
   one blueprint's resref and another's tag, decide by field.
4. Move persisted store keys with a new, separately flagged pass in
   `sapo_alma_migr.nss`.
5. Regenerate, then compare the committed SQL with the old names translated by
   the same rule: it must be byte-identical, because `--check`'s regression guard
   compares recipe identity and not numbers.
6. Run `--check`, the focused NWScript compilation, and write the changelog entry.

## Adding an exception

Add it to the constant named above in `migration/build_catalogue.py` with the
reason in a comment, add a row to the exceptions table here, and say why in the
commit. An exception without a reason is a rename that was not finished.
