# Code Review Task Example

**Created**: 2025-01-13
**PR**: #123 - Add user authentication system
**Reviewer**: code-reviewer-droid-forge

## Relevant Files
- `src/api/auth.ts` - New authentication endpoints (modified)
- `src/services/userService.ts` - User management logic (modified)
- `db/migrations/002_add_auth.sql` - Database schema changes (added)
- `src/middleware/auth.ts` - Authentication middleware (added)
- `tests/auth.test.ts` - Authentication tests (added)

## Tasks

### Security Review (BLOCKER)
- [ ] 1.1 Remove hardcoded API key from src/config/api.ts:15
  - **Droid**: security-fix-droid-forge
  - **Evidence**: `const API_KEY = "sk-1234567890abcdef";`
  - **Impact**: Credential exposure leading to unauthorized access
  - **CWE**: CWE-798

- [ ] 1.2 Fix SQL injection vulnerability in src/services/userService.ts:45-52
  - **Droid**: security-fix-droid-forge  
  - **Evidence**: Concatenated query string with user input
  - **Impact**: Database compromise, data exfiltration
  - **CWE**: CWE-89

- [ ] 1.3 Add input validation for authentication endpoints
  - **Droid**: security-fix-droid-forge
  - **Files**: src/api/auth.ts:23-35
  - **Impact**: Potential injection attacks

### Performance Review (HIGH)
- [ ] 2.1 Fix N+1 query pattern in user loading
  - **Droid**: backend-engineer-droid-forge
  - **Files**: src/services/userService.ts:45-52
  - **Impact**: Database performance degradation with large datasets
  - **Solution**: Use JOIN or batch queries

- [ ] 2.2 Add database indexes for authentication queries
  - **Droid**: database-performance-droid-forge
  - **Files**: db/migrations/002_add_auth.sql
  - **Impact**: Slow login times under load
  - **Indexes**: users.email, sessions.token

### Code Quality (MEDIUM)
- [ ] 3.1 Extract long authentication function
  - **Droid**: code-refactoring-droid-forge
  - **Files**: src/api/auth.ts:15-85 (70 lines)
  - **Issue**: Function exceeds 50 line limit
  - **Suggestion**: Split into validateUser, authenticateUser, generateToken

- [ ] 3.2 Add error handling for async operations
  - **Droid**: bug-fix-droid-forge
  - **Files**: src/services/userService.ts:78-92
  - **Issue**: Missing try/catch for database operations
  - **Impact**: Unhandled promise rejections

### Testing Review (HIGH)
- [ ] 4.1 Add unit tests for authentication logic
  - **Droid**: unit-test-droid-forge
  - **Files**: tests/auth.test.ts (incomplete)
  - **Coverage**: Missing edge cases, error scenarios
  - **Tests needed**: Invalid credentials, malformed input, rate limiting

- [ ] 4.2 Add integration tests for API endpoints
  - **Droid**: unit-test-droid-forge
  - **Endpoints**: POST /api/auth/login, POST /api/auth/register
  - **Scenarios**: Valid login, invalid credentials, rate limiting

### Integration Safety (HIGH)
- [ ] 5.1 Create rollback migration for auth schema
  - **Droid**: drizzle-orm-specialist-droid-forge
  - **Files**: db/migrations/002_add_auth.sql
  - **Issue**: No rollback plan provided
  - **Risk**: Cannot recover from failed migration

- [ ] 5.2 Add feature flags for authentication rollout
  - **Droid**: frontend-engineer-droid-forge
  - **Files**: src/components/LoginForm.tsx
  - **Purpose**: Gradual rollout capability
  - **Kill switch**: Disable authentication if issues arise

### Documentation (LOW)
- [ ] 6.1 Update API documentation for auth endpoints
  - **Droid**: auto-pr-droid-forge
  - **Files**: docs/api.md
  - **Content**: Request/response formats, error codes

- [ ] 6.2 Add authentication setup guide
  - **Droid**: auto-pr-droid-forge
  - **Files**: README.md
  - **Sections**: Environment variables, database setup, testing

## Priority Order
1. **BLOCKER**: Tasks 1.1, 1.2 (Security vulnerabilities)
2. **HIGH**: Tasks 2.1, 2.2, 4.1, 4.2, 5.1, 5.2 (Performance, testing, integration)
3. **MEDIUM**: Tasks 3.1, 3.2 (Code quality)
4. **LOW**: Tasks 6.1, 6.2 (Documentation)

## Next Steps
1. Fix BLOCKER security issues (1.1, 1.2) using security-fix-droid-forge
2. Address HIGH priority performance and testing issues
3. Complete remaining MEDIUM and LOW priority tasks
4. Re-review and approve PR once all tasks completed
