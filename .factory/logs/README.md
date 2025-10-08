# Geonosis Project Logs (.factory/logs)

Project-scoped, append-only JSON logs used by the Geonosis orchestrator (Kalani) for minimal auditability and progress tracking. No database or global registry is used. Kalani will create this directory and baseline log files if they do not exist.

- Location: `.factory/logs/`
- Scope: Per project only
- Format: NDJSON (one JSON object per line) or small per-run NDJSON files

## Files

- `events.ndjson` — Runtime event stream (task scheduling, start/completion, droid start/completion, failures)
- `audit.ndjson` — Audit trail (notable orchestration actions, git operations)
- `run-<run_id>.ndjson` — Optional per-run file containing only that run's events (created when helpful)

## Event Format (NDJSON)

Each line is a standalone JSON object. Minimal schema:

- `timestamp` (string, ISO 8601)
- `event_type` (string)
- `run_id` (string)
- `task_id` (string, optional)
- `droid_id` (string, optional)
- `status` (string, optional; e.g., `scheduled|started|completed|failed`)
- `details` (object, optional)
- `git` (object, optional; e.g., `{ "sha": "abc123", "branch": "feat/x" }`)

### Example Entries

```
{"timestamp":"2025-10-08T09:55:12.345Z","event_type":"task.scheduled","run_id":"r-20251008-0955","task_id":"1.1","status":"scheduled","details":{"title":"Setup orchestrator skeleton"}}
{"timestamp":"2025-10-08T10:00:05.201Z","event_type":"droid.started","run_id":"r-20251008-0955","task_id":"1.1","droid_id":"security-sweeper@1.0.0"}
{"timestamp":"2025-10-08T10:07:44.002Z","event_type":"git.commit","run_id":"r-20251008-0955","git":{"sha":"abc1234","branch":"feat/orchestrator"}}
{"timestamp":"2025-10-08T10:15:22.119Z","event_type":"task.completed","run_id":"r-20251008-0955","task_id":"1.1","status":"completed"}
```

### Event Types (minimal)

- `task.scheduled`, `task.started`, `task.completed`, `task.failed`
- `droid.started`, `droid.completed`
- `git.commit`
- `audit.recorded`

## Task List Status Conventions

Update the generated task list file at `/tasks/tasks-[prd-file-name].md` to reflect progress:

- When scheduled: append `status: scheduled` to the task line
- When started: append or replace with `status: started`
- When completed: check the box and optionally append `status: completed`
- Preserve the Markdown structure, numbering, and indentation

### Examples

```
- [ ] 1.1 Implement orchestrator bootstrap status: scheduled
- [ ] 1.1 Implement orchestrator bootstrap status: started
- [x] 1.1 Implement orchestrator bootstrap status: completed
```

## Reading Logs

- Tail live events: `tail -f .factory/logs/events.ndjson`
- Grep for an event: `rg '"event_type":"task\\.started"' .factory/logs/events.ndjson`
- Filter by run (jq): `jq -r 'select(.run_id=="r-20251008-0955")' .factory/logs/events.ndjson`

## Maintenance

- No rotation by default; prune older `.ndjson` files as needed
- Kalani creates or recreates the `.factory/logs/` directory and any missing log files when it runs

## Privacy & Safety

- Do not log secrets or full command payloads
- Store only metadata necessary for traceability

## Changelog

- Kalani maintains a project changelog at `CHANGELOG.md` in the repo root.
- Only Kalani writes to this file. It is created if missing.
- Entries include date, `run_id`, affected task IDs/titles, and commit SHAs.

## Conventions & Overrides

- The event shapes and task status markers shown here are defaults.
- If a project defines a different convention, Kalani adapts and preserves the existing structure.
