# Control Panel

## Scope

This module documents the reusable administrative web application under the
legacy `cnr-editor/` path. The product name is **Control Panel**. It has no
project or feature acronym in its visible identity, API title, or package
metadata. Its title and subtitle can be customized at image build time through
`CONTROL_PANEL_TITLE` and `CONTROL_PANEL_SUBTITLE`.

The current installation connects several domain features: recipe catalogue
editing, account and character management, and system-user management. Each
feature owns its authorization rules. Adding a feature to the navigation does
not grant access to its backend endpoints.

## Compatibility boundary

The directory, Compose project, container names, launcher, database tables,
cookie names, environment-variable prefix, and remote deployment paths retain
their historical `cnr-editor` identifiers. Existing automation depends on
those identifiers. They are compatibility interfaces, not product branding.
Renaming them requires a separate coordinated schema and deployment migration.

## System users

The existing `cnr_editor_user` table remains the authentication source. A user
has a unique login name, an optional normalized unique email, an Argon2
password hash, one descriptive role, an active state, explicit system
permissions, and an explicit set of editable professions. The supported role
labels are `admin`, `technical`, `dungeon_master`, `editor`, and
`collaborator`. Explicit permissions authorize ordinary feature endpoints. The
DM CD-key whitelist is the deliberate exception: because it controls access to
the server's highest-privilege game client, it requires the exact `admin` or
`technical` role in the API.

Migration `0014_integral_permissions` expands the permission catalogue and
backfills role-compatible presets so existing users retain their previous
access. After that migration, administrators can grant or revoke every
capability on every user profile. A role selection supplies a convenient
initial preset when a user is created, but later role changes do not silently
overwrite the explicit permission set. Only an administrator may alter system
permissions. A user with `edit_users` may maintain ordinary user fields and
profession scopes without being able to grant new system access. A
non-administrator also cannot create, promote, demote, deactivate, rename, or
reset the password of an administrator profile.

Recipe, user, account, and character access each have separate view and edit
permissions. Character data is further divided into identity, timestamps,
ability scores, classes, level unlocks, technical profile, and tradeskills.
The API omits unauthorized character sections from its response and checks the
matching edit permission for every submitted field. The frontend visibility
rules are therefore a reflection of the backend policy, not the security
boundary. `activate_cd_keys` remains a dedicated capability and never follows
from `edit_accounts` or a role.

Changing a username or password revokes all sessions owned by that user.
Deactivation also revokes all sessions. The system-user overview keeps creation
behind an explicit dialog so the primary view remains a readable user list.
Permanent deletion is isolated in a red danger zone at the end of the edit
dialog and requires confirmation. A manager cannot delete the account backing
their current session, and only an administrator can delete another
administrator. The API also prevents any manager from deleting, demoting, or
disabling the last active administrator, or from removing the last active
administrator with user-recovery permissions. Existing users receive a null
email when migration `0006_control_panel_user_profiles` runs; the field is
optional so migration never invents contact data.

Migration `0016_nullable_revision_actors` preserves catalogue and identity
audit history when a system user is deleted. Its actor reference becomes null
while the immutable revision contents remain available; sessions and explicit
permissions continue to be deleted with the user.

Migration `0017_system_user_audit` extends the same immutable history to user
creation, profile updates, and deletion. User snapshots deliberately exclude
password hashes and session secrets.

Migration `0018_mfa_and_login_throttle` adds optional TOTP credentials,
single-use recovery codes, short pre-session MFA challenges, and per-account
password-failure throttling. TOTP seeds are encrypted with the deployment-only
`CNR_EDITOR_MFA_ENCRYPTION_KEY`; recovery codes, challenge tokens, and throttle
subjects are stored only as hashes. The key belongs in the ignored MySQL
environment file already supplied to the API, must remain stable across
restarts, and must never enter a tracked deployment-control file.

Five password failures in the configured window start progressive cooldowns of
30 seconds, 60 seconds, five minutes, and fifteen minutes. A password accepted
for an MFA account creates only a five-minute challenge, not an authenticated
session. Five bad second-factor submissions destroy that challenge. Accepted
TOTP steps cannot be replayed, and each recovery code can be consumed once.

Users manage their own MFA after confirming their password. Enabling it exposes
ten recovery codes once; disabling it also requires a current TOTP or recovery
code and revokes all sessions. An administrator can reset another user's MFA
for account recovery, which revokes that user's sessions and creates an audit
revision. Secret values are excluded from every revision snapshot.

The limiter is account-based only. IP throttling remains deferred until the
deployment has an HTTPS reverse proxy with an explicit trusted-proxy boundary;
the API must not treat an unvalidated forwarding header as a client address.
The development HTTP endpoint and insecure-cookie setting are not suitable for
production MFA.

## Administrative audit

Administrators have a dedicated audit workspace that unifies catalogue,
account, character, DM-access, and system-user revisions in reverse
chronological order.
Every row identifies the affected object, action, timestamp, and actor and can
open the stored before-and-after snapshots. The endpoint enforces the
administrator role independently of navigation visibility. Deleted actors are
shown as deleted users while their historical revisions and change payloads
remain intact.

An inactive control-panel user cannot authenticate and any existing sessions
are rejected. Game accounts use only `active` and `blocked`; a blocked account
rejects a subsequent connection before the character list when the presented
name is protected by PWDB history. It does not push-disconnect an existing
session. Characters use `active`, `blocked`, and `deleted`. Character policy is
applied after character selection because that identity is unavailable at
client-connect time. A deleted character receives a five-second warning on its
next login and its server-vault BIC is removed, while its database tree remains
as an immutable tombstone. The same normalized name cannot be recreated inside
that account until an administrator explicitly unlocks it. A separate
administrator-only purge with typed confirmation permanently removes the
character-owned data.
Changing a panel user's own active flag does not alter a game account unless an
authorized manager changes that account separately.

Migration `0019_account_access_security` adds aggregated historical public
CD-key and IP observations and persistent global CD-key bans. Only the exact
`admin` role receives raw keys, histories and ban endpoints; ordinary account
view permission still returns masked hints. Administrator account search also
matches any recorded key, IP or historical community name. The module enforces
the database ban through `NWNX_ON_CLIENT_CONNECT_BEFORE`, so panel changes apply
to the next connection without a server restart. An administrator with the
separate `activate_cd_keys` grant can also promote an observed, unbanned key to
primary after an explicit confirmation; attempted history alone is not treated
as proof of ownership. See
[`../database/account-access-security.md`](../database/account-access-security.md).

Migration `0008_access_status_policy` maps every legacy account denial state to
`blocked`, maps legacy character `retired` to `blocked`, and replaces both
database constraints with the reduced status sets.

## Feature authorization

| Domain | View permission | Edit permission or scope |
|--------|-----------------|--------------------------|
| Recipe catalogue | `view_recipes` | `edit_recipes` plus an assigned profession |
| Panel users | `view_users` | `edit_users`; only an admin can change system permissions |
| Game accounts | `view_accounts` | `edit_accounts` |
| CD-key recapture | `view_accounts` | `activate_cd_keys` |
| Raw access history and global CD-key bans | `view_accounts` plus exact `admin` role | Exact `admin` role; every write also requires CSRF |
| Historical CD key promoted to primary | `view_accounts` plus exact `admin` role | Exact `admin` role plus `activate_cd_keys`; requires CSRF and confirmation |
| DM CD-key whitelist | Exact `admin` or `technical` role | Exact `admin` or `technical` role; every write requires CSRF and is audited |
| Character list | `view_characters` | Section-specific permissions below |
| Identity and status | `view_character_identity` | `edit_character_identity` |
| Deleted-name unlock and permanent character purge | Exact `admin` role | Exact `admin` role; every write requires CSRF and explicit confirmation |
| Creation and login dates | `view_character_timestamps` | Read-only |
| Ability scores | `view_character_abilities` | Read-only |
| Classes and levels | `view_character_classes` | Read-only |
| Level unlocks | `view_character_level_unlocks` | `edit_character_level_unlocks` |
| Technical profile | `view_character_profile` | `edit_character_profile` |
| Character tradeskills | `view_character_tradeskills` | `edit_character_tradeskills` |

Edit permissions require their matching view permission. Character-section
permissions also require `view_accounts` and `view_characters`. The UI applies
these dependencies automatically when an administrator ticks or unticks a
permission, and request validation rejects inconsistent permission sets.

At least one active administrator must retain both `view_users` and
`edit_users`. This recovery invariant applies when changing an administrator's
role, active state, or permissions.

## Character overview

The account workspace presents each character's registered classes, total
level, six base ability scores, creation date, and latest login. Ability scores
and identity dates are runtime observations and are intentionally read-only.
Class identities and levels are also read-only: the update contract rejects
class data so the interface cannot imply that a database edit changes the game
save. Administrative profile fields and tradeskill progression retain their
existing edit rules while the character is active or blocked. A deleted
character is read-only regardless of those section permissions. Its sheet
shows the deletion date and whether its same-account name reservation remains
locked. Name unlock and hard purge are intentionally separate actions: unlock
does not reactivate the deleted UUID, while purge removes the complete
character-owned tree.

Migration `0007_character_statistics` adds nullable base-score columns. Older
characters show a pending state until their next login captures the values.
Deploy the migration before the updated game scripts so the first capture can
complete without a retry.

## Interface design

The interface uses a compact, responsive, CSS-only visual system. It has no
image dependency: depth comes from restrained gradients, translucent surfaces,
thin separators, spacing, and native controls. A warm midnight-grey palette
uses orange and muted red accents without blue interface elements. The design
takes directional inspiration from [AI Oriented](https://www.aioriented.dev/)
and applies the platform principles in Apple's guidance for
[macOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-macos/),
[layout](https://developer.apple.com/design/human-interface-guidelines/layout),
[materials](https://developer.apple.com/design/human-interface-guidelines/materials),
and [typography](https://developer.apple.com/design/human-interface-guidelines/typography)
without copying assets or product-specific branding.

The internal character view follows a compact technical-sheet hierarchy:
identity and timestamps first, six ability scores with their derived modifiers,
the persistent rebuild counters, then side-by-side class and level-unlock
records. Controls, markers, spacing, and the letter emblem are deliberately
reduced so the character data remains central and readable. The layout
collapses to one column on narrower screens.

Boolean controls use switches consistently. This includes recipe activation,
level unlocks, user activation, editable-profession scope, and every explicit
system permission. User and character interiors use separated cards with a
minimum visual gutter instead of adjoining outlined controls; odd final options
span their grid row to preserve balance rather than leaving a narrow orphan.

The application uses system fonts, high-contrast layered surfaces, restrained
corner radii, comfortable information density on large displays, and adaptive
grids and dialogs on small screens. The application shell owns the viewport:
the title bar and primary navigation remain visible while an isolated workspace
scrolls, and feature-category tabs remain sticky within that workspace. This
avoids an iframe boundary while providing the same scroll containment without
duplicating routing, authentication, or accessibility context. Reduced-motion
preferences are respected. Visible product identity remains generic;
historical directory, schema, and deployment names exist only as compatibility
interfaces.
