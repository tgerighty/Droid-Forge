# Tool Usage Guidelines Template - Assessment Droids

Add this section to all assessment droid documentation files.

---

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Run validation and analysis commands only - never modify code

#### Allowed Commands
**Testing & Validation**:
- `npm test` - Run test suites
- `npm run test:coverage` - Generate coverage reports
- `pytest` - Python tests
- `jest --coverage` - JavaScript/TypeScript test coverage
- `vitest run` - Vite test runner
- `biome check` - Biome linter validation
- `eslint .` - ESLint validation
- `tsc --noEmit` - TypeScript type checking

**Analysis & Inspection**:
- `git status` - Check repository status
- `git log --oneline -10` - Recent commit history
- `git diff` - View changes
- `git branch` - List branches
- `ls -la` - Directory listing
- `tree -L 2` - Directory structure
- `cat`, `head`, `tail` - Read file contents
- `grep -r "pattern"` - Search codebase
- `find . -name "*.ts"` - Find files

**Package Management (Read-Only)**:
- `npm list` - List installed packages
- `npm outdated` - Check for updates
- `pip list` - Python packages
- `pnpm list` - PNPM packages

#### Prohibited Commands
**Destructive Operations**:
- `rm`, `rm -rf` - Delete files
- `mv` - Move/rename files
- `git push` - Push to remote
- `git commit` - Create commits
- `npm publish` - Publish packages
- `docker push` - Push images

**Installation & Modification**:
- `npm install` - Install packages
- `pip install` - Install Python packages
- `pnpm add` - Add dependencies
- `brew install` - System packages

**System Modification**:
- `sudo` - Elevated privileges
- `chmod` - Change permissions
- `chown` - Change ownership
- `systemctl` - Service management

**Security Note**: The Factory.ai CLI prompts for user confirmation before executing any command. All commands are logged and visible to the user.

---

### Create Tool
**Purpose**: Generate task files and assessment reports - never modify source code

#### Allowed Paths
**Task Files** (Primary Output):
- `/tasks/tasks-*.md` - Task files for action droid handoff
- `/tasks/assessment-*.md` - Assessment findings
- `/tasks/findings-*.md` - Detailed findings

**Reports & Documentation**:
- `/reports/*.md` - Assessment reports
- `/reports/security/*.md` - Security assessments
- `/reports/performance/*.md` - Performance analysis
- `/docs/assessments/*.md` - Assessment documentation
- `/docs/findings/*.md` - Detailed findings documentation

**Temporary Files**:
- `/tmp/*.md` - Temporary analysis files
- `.cache/analysis/*.json` - Analysis cache files

#### Prohibited Paths
**Source Code** (NEVER):
- `/src/**/*` - Application source code
- `/lib/**/*` - Library code
- `/app/**/*` - Next.js app directory
- `/pages/**/*` - Next.js pages
- `/components/**/*` - React components
- `/api/**/*` - API routes

**Configuration Files**:
- `package.json` - Package configuration
- `tsconfig.json` - TypeScript config
- `.env`, `.env.*` - Environment variables
- `biome.json` - Biome configuration
- `next.config.js` - Next.js config
- `vite.config.ts` - Vite config
- `docker-compose.yml` - Docker config

**Git & Build Artifacts**:
- `.git/**` - Git metadata
- `node_modules/**` - Dependencies
- `dist/**`, `build/**` - Build outputs
- `.next/**` - Next.js build cache

**Security Principle**: Assessment droids analyze and document - they NEVER modify source code. This separation ensures analysis is read-only and non-destructive.

---

## Workflow Pattern

```
Assessment Droid Workflow:
1. Read & Analyze (Read, Grep, Glob, LS tools)
   └─> Understand codebase structure
   
2. Execute Validation (Execute tool)
   └─> Run tests, linters, type checkers
   
3. Create Tasks (Create tool)
   └─> Generate /tasks/tasks-*.md for action droid
   
4. Handoff to Action Droid
   └─> Action droid reads tasks and implements fixes
```

**Key Principle**: Assessment droids use `Execute` for validation and `Create` for task generation, but NEVER `Edit` source code. This maintains a clear security boundary between analysis and modification.
