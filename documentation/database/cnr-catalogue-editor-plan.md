# CNR Catalogue Editor Plan

Status: accepted and in progress. The user authorized implementation on
2026-08-09.

The implementation is versioned under the standalone root directory
`cnr-editor/`. It is deliberately separate from the NWN module source tree. Its
standalone Compose file joins the development stack network and uses the
already-running MySQL service without defining, replacing or starting either
MySQL or the NWN server.

## Goal

Provide an authenticated internal web application that connects to the MySQL
catalogue and lets authorized users:

- browse recipes by profession, station, category, material and enabled state;
- edit an existing recipe and all of its components and properties atomically;
- create a recipe by cloning or starting from a blank validated form;
- disable and re-enable recipes without deleting their history;
- hard-delete only when explicitly authorized and confirmed;
- display NWN item-property values as translated domain labels instead of raw
  numeric constants;
- export a reproducible catalogue snapshot for review and production promotion.

The browser must never connect to MySQL directly. The server-side application
connects to MySQL with a restricted catalogue account; the browser talks only
to the authenticated HTTP API.

## Recommended stack

### Backend

- Python 3.12.
- FastAPI for the HTTP API.
- SQLAlchemy 2 for explicit transactions and relational loading.
- Pydantic models for request validation.
- Alembic for numbered editor-owned schema migrations.
- MySQL 8.4, using a dedicated user that cannot access player/account tables.

This keeps catalogue validation in Python beside the existing generator and
supports MySQL without coupling the UI to NWScript. FastAPI permits any SQL
library and documents the SQLModel/SQLAlchemy approach in its
[official relational database guide](https://fastapi.tiangolo.com/tutorial/sql-databases/).

The backend targets Python 3.12 inside its container. No Python runtime is
installed or replaced in WSL.

### Frontend

- TypeScript.
- React with function components.
- MUI Core and the MIT MUI X Data Grid initially.
- TanStack Query for server state and request invalidation.
- React Hook Form plus a schema adapter for the recipe detail form.

MUI Data Grid already supports editable rows, validation hooks, filtering,
sorting and pagination in its community edition. Its official documentation
covers [row editing and validation](https://mui.com/x/react-data-grid/editing/)
and [persisting edits through a server callback](https://mui.com/x/react-data-grid/editing/persistence/).
Advanced row grouping is a paid MUI X feature, so the first version should use
server-side profession/station/category filters and a tree sidebar instead of
assuming a commercial license.

The frontend targets React 19 and Node.js 22.12 or newer inside its build
container. Vite's official
[Node.js compatibility note](https://vite.dev/guide/) requires Node 20.19+ or
22.12+. The WSL Node installation is not used to install or build the frontend.

### Alternative for a faster prototype

Django 5.2 with its built-in admin can deliver authentication, permissions and
basic CRUD faster. Django describes the admin as a customizable management
interface in its [official admin documentation](https://docs.djangoproject.com/en/5.2/ref/contrib/admin/),
and its authorization layer provides model permissions and permission checks
([official authentication documentation](https://docs.djangoproject.com/en/5.2/topics/auth/default/)).

It is not the preferred final choice because recipe editing is a domain screen,
not ordinary single-table CRUD: one save spans a recipe, components, properties,
output validation and translated value selectors. A dedicated React screen is
cleaner once those workflows become central.

## Main screens

### Authentication and authorization

The editor owns separate credentials; game accounts and CD keys are never web
login credentials. Passwords are stored only as Argon2 hashes.

The current authorization model has four roles:

| Role | Catalogue | Identity management | User administration |
|------|-----------|---------------------|---------------------|
| `collaborator` | Browse all recipes; edit assigned profession tabs | No access | No access |
| `editor` | Browse and edit every profession | No access | No access |
| `technical` | Browse and edit every profession | Full access | Full access |
| `admin` | Browse and edit every profession | Full access | Full access |

Collaborator assignments are stored in
`cnr_editor_profession_permission(user_id, profession_id)`. The profession ID
is validated by the API but intentionally has no database foreign key: catalogue
seeding deletes and recreates `cnr_profession`, while permission assignments
must survive that operation. The user foreign key uses `ON DELETE CASCADE`.

The recipe update endpoint checks both the recipe's current profession and the
profession of the submitted target category. This prevents a collaborator from
moving a recipe into or out of an unauthorized tab. Frontend read-only state is
only a usability aid; backend authorization is the security boundary.

Authentication uses an opaque random session token in a Secure, HttpOnly,
SameSite=Strict cookie. Only its SHA-256 hash is stored in MySQL. Mutating
requests also require a CSRF token tied to that session. Sessions expire and
are revocable. The API must prevent demoting or disabling the last active
administrator.

The first administrator is created through an interactive CLI command; no
default username or password is committed. User-management routes require the
`admin` or `technical` role in the backend. Hiding the frontend navigation item
is usability, not authorization. Usernames and optional normalized emails are
unique. Changing a username or password revokes that user's existing sessions.
The API prevents demoting or disabling the last active administrator.

### Catalogue browser

Left filter tree:

```text
Profession
  Station
    Category
      Material
```

Main grid columns:

- enabled state;
- public ID;
- recipe name;
- material and tier;
- DC, XP and gold;
- output blueprint and tag;
- component/property counts;
- last modification.

Filters must be URL state so a specific working set can be bookmarked.

### Recipe editor

One transactional form with sections:

1. Identity: profession, station, category, public ID and enabled state.
2. Output: blueprint resref, final name, final tag and quantity.
3. Progression: material, tier, DC, XP and gold.
4. Components: ordered tag, translated object name, quantity and retained-on-fail
   quantity.
5. Properties: translated property editor.
6. Validation preview: errors, warnings and the exact numeric rows that the game
   will read.
7. History: author, timestamp and before/after snapshot.

Saving must use one DB transaction. A component or property failure rolls back
the entire recipe edit.

### Property editor

Raw columns (`property_type`, `subtype`, `value1`, `value2`) remain the runtime
storage contract, but users never edit them as unexplained numbers.

The backend exposes a versioned property definition catalogue. Each definition
declares:

- translated property name;
- which controls are used by `subtype`, `value1` and `value2`;
- legal value options and labels;
- validation rules;
- a human preview formatter.

Examples of controls include damage type, race, alignment, saving throw,
damage dice, percentage and spell resistance. Labels must be generated from
the project's verified 2DA/constant tables. If the actual project mapping says
that numeric value `18` is a particular damage type, the UI displays that name;
it must never guess from vanilla NWN constants.

The editor shows both views:

```text
Player-facing:  Damage immunity: Fire 20%
Runtime row:    DamageImmunity / subtype=... / value1=... / value2=...
```

The runtime row is read-only by default and available for expert diagnosis.

## Data integrity and lifecycle

- Deactivate is the normal removal operation (`enabled = 0`).
- Hard delete is restricted to administrators, requires typed confirmation and
  records a final snapshot.
- Add an editor audit table before enabling writes:
  `cnr_catalogue_revision(recipe_id, actor, action, changed_at, before_json,
  after_json)`.
- Use `updated_at` for optimistic concurrency. Reject a save when another user
  changed the recipe after it was opened.
- Validate resrefs against an imported blueprint index and allowlisted
  base-game/HAK resources.
- Validate tags, public IDs, quantities, retained quantities, tiers and all
  property values server-side; frontend validation is only convenience.
- Offer clone as the primary creation workflow because recipes usually differ
  by material or output type.
- Export normalized JSON and SQL after approved edits so the database never
  becomes the only historical record.

## API outline

```text
GET    /api/professions
GET    /api/stations?profession_id=
GET    /api/categories?station_id=
GET    /api/materials?profession_id=&enabled=
GET    /api/recipes?...filters...
GET    /api/recipes/{id}
POST   /api/recipes
PUT    /api/recipes/{id}
POST   /api/recipes/{id}/clone
POST   /api/recipes/{id}/enable
POST   /api/recipes/{id}/disable
DELETE /api/recipes/{id}
GET    /api/property-definitions
POST   /api/recipes/validate
GET    /api/catalogue/export
```

The recipe GET/PUT payload contains components and properties, avoiding partial
client saves across several endpoints.

## Delivery phases

1. Freeze and verify the corrected migration baseline.
2. Add audit/revision schema and a read-only API.
3. Build the catalogue browser and translated property renderer.
4. Add transactional recipe editing and validation.
5. Add clone/create and enable/disable.
6. Add guarded hard deletion and catalogue export.
7. Test against a disposable DB, then dev MySQL, then production promotion.

### First implementation slice

The initial vertical slice covers:

1. editor-owned user, session and catalogue-revision tables;
2. interactive first-admin bootstrap;
3. login/logout/current-session API with CSRF protection;
4. admin/technical user list, creation, username/email/role/status/password management and
   collaborator profession assignments;
5. authenticated recipe list/detail endpoints;
6. one transactional recipe update containing components and properties, with
   optimistic concurrency through `cnr_recipe.updated_at`;
7. React login, recipe list/detail form and admin-user screens.

Catalogue writes are disabled by default through configuration until the
generic in-game consumer has passed the documented runtime validation. The UI
and API can be exercised read-only before that gate is deliberately enabled.
The local `cnr-editor/.env` controls this gate through
`CNR_EDITOR_WRITES_ENABLED=true|false`. `scripts/run_cnr_editor.sh` passes that
file explicitly to Docker Compose and recreates the editor containers so a
changed value is applied on the next launch. The safe default remains
read-only.

The editor must not be introduced until the generic in-game consumer has been
validated against the corrected catalogue. Otherwise the UI would make it
easier to author data for an unproven runtime contract.
