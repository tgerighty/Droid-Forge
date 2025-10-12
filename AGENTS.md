# AGENTS.md - Droid Forge Guide

> **AI agent guide for Droid Forge framework (v2.2 - Optimized)**

Quick guide for AI agents using Droid Forge's specialized droids for software development.

## Contents

[Overview](#overview) • [Principles](#principles) • [Tasks](#tasks) • [Droids](#droids) • [Usage](#usage) • [Examples](#examples) • [Reference](#reference)

---

## Overview

**Droid Forge** = Meta-orchestration framework with Factory.ai droids for complex workflows

**Core:**
- Manager orchestrator (central)
- Specialist droids (domain handlers)
- Auto delegation (pattern matching)
- ai-dev-tasks (structured tracking)

**Modes:**
1. **Iterative** (default): Human confirm each step • For: Architecture/unclear reqs
2. **One-Shot**: Full auto + testing + PR review (5 cycles) • For: Clear/routine tasks

**Flow:** `User → Manager → Match → Delegate → Execute → Monitor → Results`

---

## Principles

**1. ai-dev-tasks Only** (CRITICAL)
- Use `/tasks/tasks-[prd].md` exclusively
- Never custom task systems

Format:
```md
## Relevant Files
- `file.tsx` - Purpose
## Tasks
- [ ] 1.0 Category
  - [x] 1.1 Sub-task
```
Status: `[ ]` pending • `[~]` in progress • `[x]` done • `[cancelled]` aborted

**2. Delegate via Task Tool**
```bash
Task tool subagent_type="droid-name" description="brief" prompt "details"
```

**3. Config-Driven** → `droid-forge.yaml` (delegation, git, timeouts)

**4. Code Quality** → `biome.json` (2-space, 100-char, single quotes, semicolons)

---

## Tasks

**Create:** Analyze PRD → Generate tasks → Save `/tasks/tasks-[prd].md` → Link files

**Update:**
```bash
# Manual
sed -i 's/- \[ \] 1.2/- [~] 1.2/' tasks/tasks-X.md  # Start
sed -i 's/- \[~\] 1.2/- [x] 1.2/' tasks/tasks-X.md  # Done

# Via Manager
Task tool subagent_type="manager-orchestrator-droid-forge" prompt "Mark 1.2 done in tasks-X.md"
```

**Dependencies:** Hierarchical structure
```md
- [ ] 1.0 Database
  - [ ] 1.1 Schema
  - [ ] 1.2 Migrations (needs 1.1)
- [ ] 2.0 API (needs 1.0)
```

---

## Droids

**Assessment** (Analyze → Tasks) • **Action** (Execute → Updates) • **Infrastructure** (Orchestration)

### Assessment (8)

| Droid | Purpose |
|-------|---------|
| plan-review | Pre-impl validation • Go/no-go (GREEN/YELLOW/RED scores) |
| impact-analyzer | Bug impact map • All affected files (direct/indirect/cascade/tests/configs) |
| code-smell | Anti-patterns • Bloaters, OOP abuse, couplers |
| cognitive-complexity | Complexity scores • High functions (>10), nesting |
| security | Vulnerabilities • Injection, XSS, CSRF, secrets |
| typescript | Type safety • 'any' usage, weak types, null checks |
| debugging | Root cause • Bugs, perf, memory leaks, races |
| test | Test quality • Coverage, flaky tests, missing cases |

### Action (7)

| Droid | Handles |
|-------|---------|
| bug-fix | Logic errors, races, leaks, null refs |
| code-refactoring | Extract methods/classes, simplify, deduplicate |
| security-fix | Fix injections, update deps, remove secrets |
| typescript-fix | Replace 'any', strict mode, null handling |
| unit-test | Write/run tests, coverage |
| frontend-engineer | React/Next.js, CSS, a11y, state |
| backend-engineer | REST/GraphQL, DB, microservices, cache |

### Infrastructure (8)

| Droid | Role |
|-------|------|
| manager-orchestrator | Central coord, delegation, mode select |
| auto-pr | PR + iterative review (5 cycles) + CI/CD |
| reliability | Incidents, SRE, chaos engineering |
| task-manager | Lifecycle, atomic ops, file locks |
| ai-dev-tasks-integrator | PRD → task files |
| git-workflow-orchestrator | Branches, commits, merges |
| biome | Lint, format |
| typescript-professional | Advanced TS (use assessment+fix instead)

---

## Usage

| Task | Droid | Prompt Example |
|------|-------|----------------|
| Plan check | plan-review | "Review tasks/plan-X.md. Check alignment, risks, go/no-go" |
| Bug impact | impact-analyzer | "Map affected files for /api/users 500s. Trace propagation, propose fix" |
| Feature | manager-orchestrator | "Analyze tasks/tasks-0001.md, create delegation plan" |
| React UI | frontend-engineer | "TS user profile: avatar upload, responsive, a11y" |
| API | backend-engineer | "Auth API with JWT: register, login, logout, refresh" |
| Bug debug | debugging-assessment | "Analyze logs/profile.txt memory leak, identify source" |
| Auto PR | auto-pr | "PR for issue #123: monitor reviews, iterate 5x, fix CI/CD" |
| Incident | reliability | "50% error rate: classify, notify, execute playbook" |
| Security | security-assessment | "Scan: injection, XSS, CSRF, secrets, deps" |
| Tests | unit-test | "UserService.ts: unit tests, 90%+ coverage, edges" |

**Auto-PR Flow:** Create PR → Monitor comments → Categorize (code/style/security/tests/perf) → Route to specialists → Fix → Update PR → Repeat (max 5x) → Fix CI/CD

---

## Decision Trees

**Feature:** Complex/multi? YES → manager-orchestrator | NO → frontend-engineer/backend-engineer/unit-test/security-assessment/reliability

**Bug:** Cause known? YES → Domain specialist | NO → debugging-assessment → impact-analyzer → specialist

**Automation:** GitHub → auto-pr | Incidents → reliability | Quality → biome | Tests → unit-test | Git → git-workflow-orchestrator

---

## Examples

**Full-Stack:**
```bash
Task tool subagent_type="manager-orchestrator-droid-forge" \
  prompt "Analyze tasks/tasks-0005.md, coordinate frontend/backend/testing"
```

**Bug (3 steps):**
```bash
# 1. Debug
Task tool subagent_type="debugging-assessment-droid-forge" \
  prompt "Analyze logs/api.log for /api/users 500s, find root cause"
# 2. Impact
Task tool subagent_type="impact-analyzer-droid-forge" \
  prompt "Map all affected files, trace propagation, propose fix"
# 3. Fix
Task tool subagent_type="backend-engineer-droid-forge" \
  prompt "Fix race condition: transactions, retry logic"
```

**Auto PR:**
```bash
Task tool subagent_type="auto-pr-droid-forge" \
  prompt "PR for github.com/org/repo/issues/456. Monitor feedback, iterate 5x, fix CI/CD"
```

**Security:**
```bash
Task tool subagent_type="security-assessment-droid-forge" \
  prompt "Audit v2.0: auth, injection, XSS, CSRF, deps. Report with severity"
```

**Incident:**
```bash
Task tool subagent_type="reliability-droid-forge" \
  prompt "Payment 50% errors: classify, notify, playbook, post-mortem"
```

---

## Best Practices

**1. Detailed Prompts**
```bash
# ❌ "Make a form"
# ✅ "TS React registration: email (validated), password (strength), terms. Real-time validation, POST /api/auth/register, loading, errors, ARIA, responsive. src/components/auth/RegistrationForm.tsx"
```

**2. Manager for Multi-Domain**
```bash
Task tool subagent_type="manager-orchestrator-droid-forge" \
  prompt "Search: backend (Elasticsearch), frontend (UI, autocomplete), tests, security. tasks/tasks-0010.md"
```

**3. Auto-PR for Full Cycle**
```bash
prompt "PR for feature X: impl, monitor feedback, iterate 5x, fix CI/CD"
```

**4. Update Status**
```bash
Task tool subagent_type="manager-orchestrator-droid-forge" prompt "Mark 1.2 done in tasks/tasks-X.md"
```

**5. Git** → Branches: `feat/1.2-desc` `fix/2.3-desc` • Commits: `feat(auth): JWT` `fix(api): timeout`

**6. Security First**
```bash
Task tool subagent_type="security-assessment-droid-forge" \
  prompt "Review auth: validation, hashing (bcrypt), session, injection, HTTPS"
```

**7. Test Coverage**
```bash
Task tool subagent_type="unit-test-droid-forge" \
  prompt "Auth tests: unit (all methods), integration (API), edges, security. 90%+ coverage"
```

**8. Document** → Include: PropTypes, JSDoc, Storybook, README, a11y notes

**9. Performance** → Include: Pagination, indexes, caching, compression, rate limits, benchmarks (<200ms p95)

**10. Chaos Engineering**
```bash
Task tool subagent_type="reliability-droid-forge" \
  prompt "Chaos: payment DB failure, 10% traffic, graceful degradation, auto-rollback 5min"
```

---

## Common Pitfalls

| ❌ Wrong | ✅ Right |
|---------|---------|
| Custom task systems | ai-dev-tasks only: `tasks/tasks-X.md` |
| Manual multi-droid coord | Use manager-orchestrator |
| Vague prompts ("Create API") | Detailed: "REST users API: GET (paginated), POST, PUT, DELETE. Auth, validation, rate limit, OpenAPI" |
| Skip security review | Always include security-assessment |
| Manual PR reviews | Use auto-pr with 5x iteration |
| No tests | Include: "with test suite using React Testing Library" |
| Random git names | Conventions: `feat/1.2-desc`, `feat(auth): JWT` |
| No monitoring | Setup first: "health checks, metrics, alerts, dashboards" |

---

## Reference

**Quick Select:**

| Task | Droid |
|------|-------|
| Plan check | plan-review |
| Bug impact | impact-analyzer |
| Complex | manager-orchestrator |
| React | frontend-engineer |
| API | backend-engineer |
| Debug | debugging-assessment |
| Auto PR | auto-pr |
| Incident | reliability |
| Security | security-assessment |
| Tests | unit-test |
| Format | biome |
| Git | git-workflow-orchestrator |

**Pattern:** `Task tool subagent_type="droid-name" prompt "details"`

**Update:** `Task tool subagent_type="manager-orchestrator-droid-forge" prompt "Mark X done in tasks/Y.md"` or `sed -i 's/\[ \]/[x]/' tasks/Y.md`

**Files:** `droid-forge.yaml` (config) • `biome.json` (quality) • `tasks/*.md` (tracking) • `.factory/droids/*.md` (droids)

**Env:** `FACTORY_API_KEY` • `DROID_FORGE_CONFIG` • `DROID_FORGE_TASKS_DIR`

---

## Troubleshoot

| Issue | Fix |
|-------|-----|
| Droid not found | `ls .factory/droids/[name].md` or check droid-forge.yaml |
| Task not updating | `head -20 tasks/X.md` or manual sed |
| Delegation fails | Check droid-forge.yaml or use manager explicitly |
| PR stuck | `gh pr view N --json state` or use debugging-assessment |

---

## Advanced

**Multi-Phase:** manager-orchestrator → delegates phases (architecture, backend, frontend, tests, security, perf)

**Incident:** reliability → debugging-assessment → specialist → unit-test → reliability

**Continuous Security:** Weekly security-assessment + auto-pr for dep updates

---

## Changelog

**v2.2.0** - Full re-optimization with plan-review + impact-analyzer  
**v2.1.0** - 60% token reduction, auto-pr iteration, chaos patterns

---

**Docs:** [README](./README.md) • [CHANGELOG](./CHANGELOG.md) • [LICENSE](./LICENSE)  
**External:** [Factory.ai](https://factory.ai/) • [ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks) • [Biome](https://biomejs.dev/)

---

## Summary

**Droid Forge = Systematic AI development**

1. ai-dev-tasks only • 2. Delegate via Task tool • 3. Use specialists • 4. Manager for complex • 5. Auto-PR for automation • 6. Follow droid-forge.yaml • 7. Security first • 8. Test thoroughly • 9. Monitor proactively • 10. Document always

**Status:** Production-ready 🚀

---

*Built with ❤️ and optimized droids*
