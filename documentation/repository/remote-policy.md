# Git Remote Safety Policy

Status 2026-08-11: active local policy for this checkout.

## Invariant

Normal commits and pushes from this checkout belong exclusively to
`git@github.com:Dhraax/pdb-prod.git`. The original
`git@github.com:Puerta-de-Baldur/pdb-prod.git` repository is fetch-only and must never
receive a push unless Dhraax explicitly authorizes that individual operation.

Do not rename `pdb-readonly` to `origin`, remove its disabled push URL, change
`remote.pushDefault`, change the active branch's push remote, disable the
pre-push hook, or bypass the hook as part of routine development.

## Required configuration

| Setting | Required value |
|---------|----------------|
| `origin` fetch/push URL | `git@github.com:Dhraax/pdb-prod.git` |
| `pdb-readonly` fetch URL | `git@github.com:Puerta-de-Baldur/pdb-prod.git` |
| `pdb-readonly` push URL | `DISABLED` |
| `remote.pushDefault` | `origin` |
| `push.default` | `current` |
| `push.autoSetupRemote` | `true` |
| `branch.main.remote` | `origin` |
| `branch.main.pushRemote` | `origin` |
| `core.hooksPath` | `.githooks` |

`.githooks/pre-push` adds a second barrier. It permits only the exact
`origin` name and `git@github.com:Dhraax/pdb-prod.git` URL, so every other
remote name or URL is rejected.

## Verification

Run before publishing repository work:

```bash
git remote -v
git config --get remote.pushDefault
git config --get push.default
git config --get push.autoSetupRemote
git config --get branch.main.remote
git config --get branch.main.pushRemote
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
git switch main
git merge pdb-readonly/main
git push origin main
```

## Owner-authorized exception

Only Dhraax may authorize a push to the original PDB repository. That one
operation requires both barriers to be opened deliberately:

```bash
git remote set-url --push pdb-readonly \
  git@github.com:Puerta-de-Baldur/pdb-prod.git

PDB_ALLOW_UPSTREAM_PUSH=I_HAVE_AUTHORIZED_PDB_PUSH \
  git push pdb-readonly main

git remote set-url --push pdb-readonly DISABLED
```

Immediately verify that `pdb-readonly` again reports `DISABLED (push)`. The
authorization environment variable is intentionally scoped to one command and
must never be stored in shell profiles, Git configuration, scripts, or CI.

## Recovery check

If configuration drift is suspected, do not push. Restore the required values
from the table above and confirm that this command is rejected:

```bash
git push --dry-run pdb-readonly main
```
