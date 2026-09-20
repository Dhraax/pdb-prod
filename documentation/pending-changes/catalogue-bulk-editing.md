# Editing the catalogue in bulk, after the testing stage

**Status: proposal, nothing implemented.** Recorded 2026-09-20 from the owner's
decision. Nothing in this document is live, and no part of it should be built
before the testing stage closes.

## Where the system is today

Two tools own the catalogue and they do not overlap.

`db-apply.sh` is the testing stage's reset. It applies `migration/*.sql` in
order, and those migrations drop and rebuild the whole catalogue: nine recipe
tables, four arcane ones, and three retired legacy ones. **That is deliberate.**
Putting the database back to exactly what the repository says is what stops a
leftover from a previous shape of a recipe or an arcane step making a test pass
or fail for the wrong reason. It is the only way a repository change reaches a
server at all.

The control panel is the other one, and it edits a single row at a time: one
recipe with its components and properties, or one arcane property with its
steps, each under a profession scope, a concurrency check and an audit row.

During testing the two fit together without friction. A value tuned in the panel
lasts until the next apply, and losing it is not a loss: it was a test.

## What breaks when the trades launch

From launch there are no more applies against that database. The panel is the
live authority, nothing is authored in the repository any more, and no
write-back exists or is wanted - keeping a repository-side record of what a
designer tuned in the panel would be a second copy of the truth with nothing to
keep it honest.

Two things follow, and the second is the problem.

`db-apply.sh` becomes a rollback of the design. It is not guarded against that
today; its header says so and nothing else does. Whether that deserves a guard
is open.

And the panel's one-row-at-a-time editing becomes the only way to change
anything. That is fine for correcting a DC and unusable for the work a designer
actually does: raising the XP of every tier-3 recipe, retiring a material across
the eighty recipes that name it, renaming a wood everywhere it appears,
rebalancing a whole arcane section's steps. Each of those is one decision and
dozens of writes, and the panel offers no way to express it.

## What is needed

A way to apply a change across many catalogue rows at once, from the panel,
that **cannot touch player data**. The boundary is already drawn and already
enforced in one place: `db-reset-players.sh` classifies every table in the
database as player state or system state and refuses to run if it meets one it
does not recognise. Whatever is built here answers to that same line.

Open questions, none of them settled:

- **What a bulk edit is.** A filter plus a field change, applied to whatever the
  filter selected? A preview of the affected rows before it commits? An
  uploadable file of changes? The first is the smallest thing that helps and the
  third is what a designer would ask for by the second week.
- **How it is undone.** One row at a time, `cnr_catalogue_revision` already
  holds a before and an after. A bulk edit needs one reversible unit covering
  every row it touched, which the current table cannot express: its primary key
  is a revision, not a batch.
- **What stops a mistake.** A bulk edit is exactly as fast wrong as right. A dry
  run that reports the count and a sample, a per-batch cap, or a second
  confirmation naming the number of rows.
- **Whether the repository keeps a seed.** A brand-new database still needs a
  catalogue from somewhere. The generated SQL can stay as the installer without
  being reapplied to a live database, but then it ages, and a restore from it
  is a rollback to launch day rather than to yesterday. The alternative is that
  backups are the only source and the generator is retired.
- **What happens to the generators.** `build_catalogue.py` and
  `build_arcane.py` validate the design before it reaches SQL:
  `build_catalogue.py --check` enforces the CNR catalogue invariants. If nothing
  regenerates the SQL any more, those checks have to move into the panel's write
  path or they are lost.
- **Whether `db-apply.sh` gets a guard.** Refusing to run against a database
  that has the panel installed, unless told explicitly, converts a comment
  nobody reads into something that has to be overridden on purpose.

## What must not be done meanwhile

Do not build a write-back from the panel to `documentation/oficios/arcano.json`
or to the recipe catalogue's authored JSON. It was considered and ruled out on
2026-09-20. The panel's edits are the live truth; a repository copy of them
would be a second truth.
