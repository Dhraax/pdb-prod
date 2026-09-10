# Oficios (CNR Crafting System)

Scope: PDB's database-backed CNR crafting and tradeskill system, including
runtime behaviour, recipe/catalogue authorship, profession design sources, and
the production promotion boundary.

Runtime implementation lives in `src/cnr/`; crafted alchemy activation remains
in the shared module activation path. Recipe authorship lives in
`migration/catalogue/`, generated catalogue SQL lives in `migration/`, and
character identity is owned separately by PWDB under `src/pwdb/`.

## Documents

| Document | Current role |
|----------|--------------|
| [`cnr/`](cnr/README.md) | **Canonical CNR index.** Current implementation state, schema, completed catalogue record, production blockers, promotion runbook, and deferred feature boundaries |
| [`cnr/oficios/`](cnr/oficios/README.md) | **Player-facing oficio guide and recipe reference.** General system guide plus the current recipe catalogue for each profession |
| [`legacy/`](legacy/README.md) | Archived pre-migration resources retained only for comparison; never runtime authority |

Current persistence and production transfer guidance is owned by
[`../database/`](../database/README.md), especially
[`pwdb-cnr-production-port.md`](../database/pwdb-cnr-production-port.md).

## Design and source data

These files are reviewed design inputs or migration provenance, not runtime
database state:

| File | Contents |
|------|----------|
| `alquimia.json` | Alchemy recipe/material source data |
| `carpinteria.json` | Carpentry output and material source data |
| `herreria.json` | Smithing recipe/material source data |
| `joyeria.json` | Jewelry recipe/material source data |
| `peleteria.json` | Leatherworking recipe/material source data |
| `Oficios Basicos - Etapa 1 - 2026 - Carpinteria - En progreso.csv` | In-progress Carpentry design source |
| `Oficios Basicos - Etapa 2 - 2025 - Herreria.csv` | Smithing progression/property source |
| `Oficios Basicos - Etapa 2 - 2025 - Joyería.csv` | Jewelry progression/property source |
| `Oficios Basicos - Etapa 2 - 2025 - Peleteria.csv` | Leatherworking progression/property source |
| `Oficios Basicos - Etapa 2 - 2025 - Venenos.csv` | Poison handling-DC source |
| `pnp.txt` | Historical legacy seed statements; not a current migration |

`migration/build_catalogue.py --check` is the authority for current generated
counts and validation. Do not infer runtime or production database contents
from the design files alone.

## Repository constraints

- NWScript source is Windows-1252; preserve its encoding and search it as text.
- NWN resrefs are limited to 16 characters and tags to 32 characters.
- Treat PWDB/tradeskill rows as persistent player data. Catalogue tables are a
  separate replaceable layer.
- Follow [`cnr/legacy-removal-and-production-promotion.md`](cnr/legacy-removal-and-production-promotion.md)
  for production gates and rollback.
