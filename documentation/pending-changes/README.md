# Pending Changes

This directory records active proposals and partially implemented change sets
that still have unresolved decisions, implementation slices or validation.
Current behavior belongs in the owning module; completed implementation records
move to that module's history or are folded into its current documentation.

## Proposals

| Proposal | Status |
|----------|--------|
| [**PWDB production migration ledger**](pwdb-production-migration-ledger.md) | Canonical execution record: completed changes, exact migration boundary, verification, source-control state, deployment order and future work queue |
| [**PWDB production port survey**](pwdb-production-port-audit.md) | First PWDB-only production slice approved and in progress; records the comparison, decisions, runtime preparation and eventual upload manifest |
| [**Urgent server-vault and disguise security assessment**](urgent-securiry.md) | Critical active investigation. The legacy disguise system overrides community names while the supplied server vault is keyed by player name; immediate containment, pre-vault authorization, ownership recovery and any eventual CD-key vault migration remain pending |
| [**Spells, effects and their saving throws**](spells-and-effects.md) | The saving throw migration, from 102 legacy calls to 17; what remains, why the legacy adapter cannot be retired, and the rules the audits produced |
| [**The darkness descriptor**](darkness-descriptor.md) | Parked. Shadow Defence's darkness clause has never existed; the research, the eleven spell rows and the decision on which count |
| [**Caster level**](caster-level.md) | Partially implemented: the engine-facing prestige modifier is live in source; consolidation of the module calculation, the cast gate and remaining probes is still open. Current behavior is in `../rules/caster-level.md` |
| [Loot weapon distribution](loot-weapon-distribution.md) | Pending review |
| [`cnr-naming-normalisation.md`](cnr-naming-normalisation.md) | **Aceptado, en curso.** Llevar todo lo del CNR bajo `src/cnr` y a nombres `cnr_*`, resref y tag iguales: el esquema, lo que toca, las cinco fases y cómo se verifica cada una |
| [`cnr-naming-slice4-map.md`](cnr-naming-slice4-map.md) | La tabla exacta de la fase 4: resref y tag viejos y nuevos de cada uno de los 153 blueprints renombrados |
