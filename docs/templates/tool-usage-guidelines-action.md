# Tool Usage Guidelines Template - Action Droids

Add this section to all action droid documentation files.

---

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Run validation, tests, and build processes - full execution rights

#### Allowed Commands
**All Assessment Commands Plus**:
- All commands from assessment droids
- Plus modification and build commands below

**Build & Compilation**:
- `npm run build` - Build application
- `npm run dev` - Start development server
- `tsc` - TypeScript compilation
- `vite build` - Vite build
- `next build` - Next.js build
- `docker build` - Build Docker images

**Installation & Dependencies**:
- `npm install` - Install dependencies
- `npm ci` - Clean install
- `pnpm install` - PNPM install
- `pip install -r requirements.txt` - Python dependencies

**Git Operations**:
- `git add` - Stage changes
- `git commit` - Create commits
- `git checkout` - Switch branches
- `git merge` - Merge branches
- `git rebase` - Rebase branches

**Testing & Validation**:
- All testing commands from assessment droids
- Plus any additional test runners or validation tools

#### Prohibited Commands
**Destructive System Operations**:
- `sudo rm -rf /` - System destruction
- `rm -rf ~` - Home directory deletion
- `mkfs` - Format filesystems
- `dd if=/dev/zero of=/dev/sda` - Disk overwrite

**Remote Publishing** (Requires Explicit Approval):
- `git push` - Push to remote (ask user first)
- `npm publish` - Publish package (ask user first)
- `docker push` - Push to registry (ask user first)

**Security Note**: Action droids have full modification rights but should still confirm destructive operations and remote publishing with the user.

---

### Edit & MultiEdit Tools
**Purpose**: Modify source code to implement fixes and features

#### Usage Guidelines
**Single File Changes** (Edit tool):
- Targeted bug fixes in one file
- Small refactoring changes
- Configuration updates
- Single file improvements

**Multiple File Changes** (MultiEdit tool):
- Coordinated changes across multiple files
- Feature implementation spanning files
- Refactoring that touches many files
- Type changes propagating through codebase

**Best Practices**:
1. **Read before editing** - Always read files first to understand context
2. **Preserve formatting** - Match existing code style
3. **Atomic changes** - Each edit should be a complete, working change
4. **Test after editing** - Run tests to verify changes work

---

### Create Tool
**Purpose**: Generate new files - full creation rights including source code

#### Allowed Paths
**Source Code** (Full Access):
- `/src/**/*.ts` - TypeScript source files
- `/src/**/*.tsx` - React components
- `/lib/**/*.ts` - Library code
- `/app/**/*.tsx` - Next.js app directory
- `/pages/**/*.tsx` - Next.js pages
- `/components/**/*.tsx` - React components
- `/api/**/*.ts` - API routes
- `/utils/**/*.ts` - Utility functions
- `/hooks/**/*.ts` - React hooks
- `/types/**/*.ts` - TypeScript types

**Test Files**:
- `/tests/**/*.test.ts` - Test files
- `/__tests__/**/*.test.tsx` - Jest tests
- `/src/**/*.spec.ts` - Spec files

**Documentation**:
- `/docs/**/*.md` - Documentation
- `/README.md` - Project readme
- `/CHANGELOG.md` - Changelog

**Configuration** (With Caution):
- `package.json` - Package config (careful with versions)
- `tsconfig.json` - TypeScript config (preserve existing)
- `.env.example` - Example environment variables

#### Prohibited Paths
**Security Sensitive**:
- `.env` - Actual environment variables (should never be created)
- `.env.local` - Local secrets
- `secrets/` - Secret storage directories

**System Files**:
- `.git/` - Git internals (use git commands instead)
- `/etc/` - System configuration
- `~/.ssh/` - SSH keys

**Best Practices**:
1. **Check before creating** - Ensure file doesn't already exist
2. **Follow conventions** - Match project structure and naming
3. **Complete implementations** - Create working, tested code
4. **Document new files** - Add JSDoc, comments, and documentation

---

## Workflow Pattern

```
Action Droid Workflow:
1. Read Tasks (Read tool)
   └─> Load /tasks/tasks-*.md from assessment droid
   
2. Understand Context (Read, Grep, Glob)
   └─> Read relevant source files
   
3. Implement Changes (Edit, MultiEdit, Create)
   └─> Fix bugs, implement features, create new files
   
4. Validate Changes (Execute tool)
   └─> Run tests, linters, build process
   
5. Update Task Status (Edit tool)
   └─> Mark tasks as completed in task file
```

**Key Principle**: Action droids have full modification rights to implement fixes and features. They should validate all changes with tests and update task files to track progress.
