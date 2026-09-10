# Performance measurement

How to find out what a script actually costs on this server, without asking
anyone to run a stopwatch.

## The one rule

**Only ever query the window that was named.** If the report is *"I played for
the last twenty minutes"*, the query covers the last twenty minutes and nothing
else.

This is not tidiness. Cumulative totals on a server that is empty most of the
time are dominated by whatever ran during the quiet hours, and they invite
exactly the wrong conclusion. An unbounded query once put creature AI at the top
of the list on a server with nobody logged in — true, and useless for deciding
where to spend effort on a system players touch.

A number without its window and its player count is not a measurement.

## Where the data is

NWNX writes metrics through `Metrics_InfluxDB` into the `metrics` database of
the `influxdb` container. **No port is published to the host**, deliberately, so
the query goes through the container:

```bash
docker exec server-influxdb-1 influx -database metrics -execute '<query>'
```

Add `-precision rfc3339` to get readable timestamps instead of nanoseconds.

Grafana reads the same database on port 3000. Its admin password is **not** the
one in `config/grafana.env` unless the volume was created after that value was
set — `GF_SECURITY_ADMIN_PASSWORD` applies only when Grafana first initialises
`grafana.db`, and the named volume `server_grafana` survives restarts. Reset it
with `grafana-cli admin reset-admin-password` inside the container rather than
editing the env and expecting a change.

## What is recorded, and what it is not

**Every timing is a one-second aggregate, not an execution.**
`nwnxee/Plugins/Profiler/Profiler.cpp:127` installs
`Resamplers::Sum<int64_t>` on `TimingEvent` with a one-second period, and
`Tracking/Targets/Activity.cpp:27` does the same to `Activity` with
`Sum<uint32_t>`. What reaches InfluxDB is therefore *the total nanoseconds a
script spent during that second*, and one point per second in which it ran at
all.

This is the trap in the whole file. Getting it wrong turns bucket counts into
call counts and one-second totals into per-call averages, and the numbers look
plausible either way.

| Query | Actually means | Does **not** mean |
|-------|----------------|-------------------|
| `sum(ns)` | Total time in the window. **Trustworthy** | — |
| `count(ns)` | Seconds in which the script ran at all | The number of executions |
| `mean(ns)` | Mean nanoseconds per **active second** | Cost per call |
| `max(ns)` | The worst **second** | The worst single execution |

There is no per-execution figure. To get one, the script has to count its own
calls; the profiler cannot supply it.

| Measurement | Useful fields | Answers |
|-------------|---------------|---------|
| `NWNX_Profiler.TimingEvent` | `Script`, `ns`, `EventName` | How much time a named script consumed |
| `NWNX_Profiler.GameTickRate` | `Count` | Whether any of it is hurting the server |
| `NWNX_Profiler.GameObjectUpdate` | `ns` | Engine-side object update cost |
| `NWNX_Profiler.AIQueuedEvents`, `.AIUpdateListObjects` | `Count` | AI load |
| `NWNX_SQL.SQLQueries` | `ns` | Query cost, by id |
| `NWNX_Tracking.Activity` | `Area`, `Type`, `Count` | Where activity was, summed per second |

`Script` is empty for engine-internal timings, so a per-script question must
filter on it.

**`Activity` is not a headcount.** It is a per-second sum of activity samples,
so `count(Count)` counts seconds and `mean(Count)` is an activity level. The
population belongs in the report from whoever played, not in a query.

## The switches

In `config/nwserver-dev.env`. `NWNX_PROFILER_SKIP` and
`NWNX_METRICS_INFLUXDB_SKIP` must both be off, and:

| Switch | Installs | Measures |
|--------|----------|----------|
| `ENABLE_SCRIPTS` (default on) | `Scripts` | **Per-script time. This is the usual target** |
| `SCRIPTS_AREA_TIMINGS`, `SCRIPTS_TYPE_TIMINGS` | — | The same, split by area and by event type |
| `ENABLE_OBJECT_EVENT_HANDLERS` (default off) | `ObjectEventHandlers` | The **engine's** native object handlers, not NWNX subscriber scripts |
| `ENABLE_TICKRATE`, `ENABLE_MAIN_LOOP` | — | Server health |

Read from `nwnxee/Plugins/Profiler/Profiler.cpp`. Reading an object-handler
figure as the cost of a script is the easy mistake; they are different targets.

## Recipes

**Time consumed per script inside a named window.** `sum(ns)` is the figure to
trust. `active_s` is how many seconds the script ran at all, which is a duty
cycle, not a call count.

```sql
SELECT sum(ns) AS total_ns, count(ns) AS active_s
FROM "NWNX_Profiler.TimingEvent"
WHERE "Script" != '' AND time > now() - 20m
GROUP BY "Script"
```

**One script over the same window**, when the question is about a change:

```sql
SELECT sum(ns) AS total_ns, count(ns) AS active_s, max(ns) AS worst_second_ns
FROM "NWNX_Profiler.TimingEvent"
WHERE "Script" = 'event_effects' AND time > now() - 20m
```

`total_ns / active_s` is nanoseconds per active second — a load figure. It is
not the cost of one call and must never be reported as one.

**Server health across the window**, which is what says whether a cost matters:

```sql
SELECT min(Count) AS worst_tick, mean(Count) AS mean_tick
FROM "NWNX_Profiler.GameTickRate"
WHERE time > now() - 20m
```

**Where the activity was**, to check the window covers real play:

```sql
SELECT sum(Count) FROM "NWNX_Tracking.Activity"
WHERE "Type" = 'Player' AND time > now() - 20m GROUP BY "Area"
```

An absolute window when "the last N minutes" is wrong — the session ended an
hour ago, say:

```sql
WHERE time >= '2026-08-25T15:40:00Z' AND time < '2026-08-25T16:10:00Z'
```

## Reporting a result

Always with the window, the population, and what the server was doing — and
always saying which of the four figures above it is. "Six milliseconds per
active second" and "six milliseconds per call" are different claims and only one
of them can be backed by this data.

Record durable findings in the module document that owns the system measured,
not here. This file is the method.
