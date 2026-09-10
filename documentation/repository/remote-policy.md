# Git Remote Safety Policy

Status 2026-08-11: active local policy for this checkout.

## Invariant

Normal commits and pushes from this checkout belong exclusively to
`git@github.com:Dhraax/pdb-dev.git`. The original
`git@github.com:minikanyas/pdb-dev.git` repository is fetch-only and must never
receive a push unless Dhraax explicitly authorizes that individual operation.

Do not rename `pdb-readonly` to `origin`, remove its disabled push URL, change
`remote.pushDefault`, change the active branch's push remote, disable the
pre-push hook, or bypass the hook as part of routine development.

## Required configuration

| Setting | Required value |
|---------|----------------|
| `origin` fetch/push URL | `git@github.com:Dhraax/pdb-dev.git` |
| `pdb-readonly` fetch URL | `git@github.com:minikanyas/pdb-dev.git` |
| `pdb-readonly` push URL | `DISABLED` |
| `remote.pushDefault` | `origin` |
| `push.default` | `current` |
| `push.autoSetupRemote` | `true` |
| `branch.feature/oficios.remote` | `origin` |
| `branch.feature/oficios.pushRemote` | `origin` |
| `core.hooksPath` | `.githooks` |

`.githooks/pre-push` adds a second barrier. It blocks both the
`pdb-readonly` remote name and any direct URL containing
`github.com/minikanyas/pdb-dev`, so an explicit-URL push is also rejected.

## Verification

Run before publishing repository work:

```bash
git remote -v
git config --get remote.pushDefault
git config --get push.default
git config --get push.autoSetupRemote
git config --get branch.feature/oficios.remote
git config --get branch.feature/oficios.pushRemote
git config --get core.hooksPath
```

The only normal publication command is:

```bash
git push
```

It must resolve to `origin`, never `pdb-readonly`.

## Receiving changes from PDB

Fetching and merging do not require enabling pushes:

```bash
git fetch pdb-readonly
git switch feature/oficios
git merge pdb-readonly/feature/oficios
git push origin feature/oficios
```

## Fork-only tracked content

The final, delimited block in the root `.gitignore` exists only in
`Dhraax/pdb-dev`. It exposes the canonical documentation, Control Panel,
verification scripts, and local push-safety hook for versioning in this fork.

Do not send that block or those fork-only paths to `minikanyas/pdb-dev` by
accident. Removing the ignore exceptions does not remove files that Git already
tracks. If Dhraax authorizes an upstream contribution, create the contribution
branch from the relevant `pdb-readonly/<branch>` tip and cherry-pick only the
portable commits. Never use the fork branch itself as the upstream push source.

Before reviewing an upstream-bound branch, confirm that neither the delimited
`.gitignore` block nor these paths appear in its diff:

```text
.githooks/
cnr-editor/
documentation/
scripts/
```

## Owner-authorized exception

Only Dhraax may authorize a push to the original PDB repository. That one
operation requires both barriers to be opened deliberately:

```bash
git remote set-url --push pdb-readonly \
  git@github.com:minikanyas/pdb-dev.git

PDB_ALLOW_UPSTREAM_PUSH=I_HAVE_AUTHORIZED_PDB_PUSH \
  git push pdb-readonly feature/oficios

git remote set-url --push pdb-readonly DISABLED
```

Immediately verify that `pdb-readonly` again reports `DISABLED (push)`. The
authorization environment variable is intentionally scoped to one command and
must never be stored in shell profiles, Git configuration, scripts, or CI.

## Recovery check

If configuration drift is suspected, do not push. Restore the required values
from the table above and confirm that this command is rejected:

```bash
git push --dry-run pdb-readonly feature/oficios
```
