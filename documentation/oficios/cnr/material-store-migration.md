# Material store: legacy Arcane conversion

**Role: current source behavior after the September 2026 correction.** Runtime
acceptance on the testing server remains pending.

## Ownership and trigger

`sapo_alma_abri` calls `AlmMigrar` from `sapo_alma_migr` before showing the
character's material-store holdings. Quantities are integer locals on the
character's `CONTENEDOR_VARIABLES` item through `mti_libreria`; they are not
MySQL catalogue rows. The converter adds to existing destination quantities,
removes the converted source key and writes `CNR_ALMACEN_MIGRADO` once the
original conversion completes. Existing CNR resource-renaming passes retain
their own flags and run before this original conversion.

## Arcane preservation boundary

The conversion preserves **97 legacy Arcane keys**: all **93 distinct essences**
referenced by `documentation/oficios/arcano.json`, plus the four legacy
crystals. The literal old/new correspondence is in `AlmMigrar`; it is not
computed by fuzzy names at runtime. Existing new holdings are added to, never
replaced. The destination is written before the converted source is deleted.

| Legacy crystal key | Destination | Current material |
|--------------------|-------------|------------------|
| `pb_artesa_poten1` | `cnr_c_1` | Nishruu |
| `pb_artesa_poten2` | `cnr_c_2` | Fenix |
| `pb_artesa_poten3` | `cnr_c_3` | Hada, previously Quimera |
| `pb_artesa_poten4` | `cnr_c_4` | Dragon, previously Leviatan |

The other **34 legacy Arcane keys** remain on the retired-material list because
no material in the current Arcane design claims them. This includes school
powders and gem-golem fragments. This conversion does not delete blueprints,
modify profession progression or change MySQL schema/catalogue data.

## Provenance and checks

The correspondence was established from tracked legacy UTI localized names,
current `arcano.json` material references and current CNR UTI identities. Color
spans, case and accents were removed for the source comparison only. All 92
available legacy essence blueprint names match their current design material;
`pb_artesa_clas06` is identified as Nobleza de grifo by its tracked original
retirement entry and maps to the same named current `cnr_e_57` design/blueprint.
The Quimera/Hada and Leviatan/Dragon continuity is recorded in
[`arcane-unused-blueprints.md`](arcane-unused-blueprints.md); actual current
crystal references are established by `build_arcane.py` and `05_arcane.sql`,
which reference all six crystals. The unused-blueprint inventory is corrected
in the same slice to match the current 99 used / 36 unused resources.

Static verification checks complete design coverage, unique source keys,
aligned destination blueprint tag/resref, material-store listing and generated
Arcane SQL references. In-memory literal-table checks cover adding old and new
quantities and conservation after repeated execution or loss of the one-shot
flag. These checks do not establish in-game persistence or runtime success.

Focused compilation: `./linux_build.sh --check sapo_alma_migr.nss
sapo_alma_abri.nss` passed with one executable successful, the include skipped
and zero errors. The documentation checker from DEV, bound to this checkout
because the production copy is absent, passed for 89 Markdown files and 23
README indexes. Independent review has not been run.

## Testing boundary

Repeat trials using the owner's pre-conversion backup state. Already-deleted
testing holdings are not repaired, and no new retroactive conversion pass is
added. The restored fixture must contain the character's variable-container
holdings. With the general migration flag already set, the converter leaves
that original conversion unchanged.

Open the material store with legacy essences and all four crystals, including
existing new holdings; confirm totals and withdrawals use the current material.
Verify an unused school powder is retired with its message. Close, reopen and
relog: no quantity may duplicate or disappear. Also exercise zero quantities,
unrelated material holdings and the existing CNR rename passes. Packaging and
in-game testing remain the owner's next validation steps.
