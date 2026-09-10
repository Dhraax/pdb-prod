# Changelog

What changed, when, and what has to be tested for it. One entry per day per area,
newest first inside each file.

## Why it is split in two

| Directory | Scope |
|-----------|-------|
| [`oficios/`](oficios/) | The CNR trade systems: recipes, stations, the alchemist's potions, the catalogue and its migrations. Everything under `src/cnr/`, `migration/` and `documentation/oficios/` |
| [`modulo/`](modulo/) | Everything else: spells, effects, areas, persistence, events, tooling, 2DA and HAK content |

A change that touches both is written where its **subject** lives, and the other
file gets a one-line cross-reference. The alchemist's potions gaining an effect
identity is a `modulo/` change - the subject is the effect library - and
`oficios/` says so in one line and points at it.

## The rule

**A change that a player, a DM or a builder could notice gets an entry, on the
day it is committed.** Refactoring that nobody can observe does not, unless it
moves a file or changes how something is built.

Every entry carries four things and none of them is optional:

- **What changed**, in the terms of whoever will notice it, not in the terms of
  the diff.
- **What has to be tested**, concretely enough to act on without reading the
  code. "Enter and leave the wall four times in a row" is a test. "Verify wall of
  fire" is not.
- **What is still owed** - a hak repack, a migration, a decision - or `nothing`.
- **The commits**, so the entry can be traced back.

Entries are not deleted when the test passes. The line is amended to say it
passed and on what date, because "this was tested on the 26th" is the thing
somebody wants to know in November.

## The bulk sheet

[`pending-tests.md`](pending-tests.md) gathers every test still awaiting play
into one page, so a tester can be handed one document instead of a month of
entries. It is a **view**: each entry keeps its own list and remains the record.
When a test passes, amend the entry and strike the line on the sheet.

## Files

One file per month: `YYYY-MM.md`. A month with no entries has no file.
