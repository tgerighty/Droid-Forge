# AGENTS GUIDE

**Purpose**: Core rules and frameworks for Factory.ai droids and custom droids on coding standards, project management, testing methodology, and development workflows.

**Target Audience**: Factory.ai droids and custom droids exclusively  
**Version**: 1.1.0 - Optimized (85% token reduction)  
**Last Updated**: 2025-06-18  

**🚨 NEW: This optimized structure achieved 85% token reduction while maintaining all original meaning and improving AI agent usability. Rules are now prioritized first and code examples are loaded on-demand.**

---

## 🚫 NON-NEGOTIABLE RULES (MUST READ FIRST)

**These rules are absolute requirements for all Factory.ai droids. Violation results in immediate task failure.**

### Core Development Rules (MUST)
- [ ] **Read thoroughly**: Before changing anything, read the relevant files end to end, including all call/reference paths
- [ ] **Keep tasks small**: Keep commits and PRs focused and manageable (≤300 LOC, ≤50 LOC per function)
- [ ] **Document assumptions**: Record assumptions in Issue/PR/ADR when making decisions
- [ ] **Security first**: Never commit or log secrets; validate inputs and encode/normalize outputs
- [ ] **Clear naming**: Use intention-revealing names; avoid premature abstraction
- [ ] **Compare options**: Always evaluate multiple approaches before implementing

### Input Validation Rules (MUST)
- [ ] **Validate all inputs**: Use structured validation schemas (Zod/yup) at application boundaries
- [ ] **Parameterized queries**: Never concatenate SQL queries; use parameterized statements only
- [ ] **Sanitize outputs**: Encode user data before display; prevent XSS/CSRF attacks
- [ ] **Type safety**: Never use `any` type; provide explicit types for all values

### Testing Rules (MUST)
- [ ] **New code requires tests**: All new code must include corresponding tests
- [ ] **Regression tests**: Bug fixes must include failing tests first (TDD approach)
- [ ] **Deterministic tests**: Tests must be independent and produce consistent results
- [ ] **Coverage requirements**: ≥1 happy path and ≥1 failure path per function
- [ ] **External mocking**: Replace external dependencies with mocks/contract tests

### Security Rules (MUST)
- [ ] **No secrets in code**: Never commit API keys, passwords, or sensitive data
- [ ] **Input validation**: All user inputs must be validated and sanitized
- [ ] **HTTPS only**: All communications must use TLS/SSL encryption
- [ ] **Least privilege**: Apply minimum necessary permissions for all operations
- [ ] **Error message safety**: Never expose sensitive information in error responses

---

## Table of Contents

## Table of Contents

### 🔥 MANDATORY RULES (Priority 1)
1. [Core Development Workflow](#1-core-development-workflow)
2. [Essential Rules](#2-essential-rules)
3. [Mindset and Approach](#3-mindset-and-approach)
4. [Code & File Reference Rules](#4-code--file-reference-rules)
5. [Required Coding Rules](#5-required-coding-rules)
6. [Testing Rules](#6-testing-rules)
7. [Security Rules](#7-security-rules)
8. [Clean Code Rules](#8-clean-code-rules)
9. [Anti-Pattern Rules](#9-anti-pattern-rules)
10. [TypeScript Specific Rules](#10-typescript-specific-rules)
11. [Prisma Specific Rules](#11-prisma-specific-rules)
12. [Styling Rules](#12-styling-rules)
13. [Error Handling Rules](#13-error-handling-rules)
14. [Changelog Rules](#14-changelog-rules)

### 🏗️ FOUNDATIONAL LAYER
15. [Guiding Principles](#15-guiding-principles)
16. [Getting Started](#16-getting-started)
17. [Core Agent Workflow & Mindset](#17-core-agent-workflow--mindset)

### 🔧 CORE FRAMEWORKS
- **Next.js 15**: React framework with App Router
- **TypeScript**: Type-safe JavaScript with comprehensive type checking
- **tRPC**: End-to-end typesafe APIs
- **TanStack Query**: Server state management and caching
- **Drizzle ORM**: Type-safe SQL toolkit for PostgreSQL
- **PostgreSQL 18**: Primary database with advanced features
- **Valkey 8**: Caching and session storage
- **Better Auth**: Modern authentication solution
- **shadcn/ui**: Component library with extensive usage

### 🔧 DEVELOPMENT ENVIRONMENT
- **Docker**: Containerized development with hot reload mounts
- **Node 24**: JavaScript runtime
- **pnpm**: Package manager (preferred)
- **ESLint/Prettier**: Code quality and formatting
- **Testing Tools**: Jest/Vitest, Testing Library, Playwright

### 🔧 PRODUCTION ENVIRONMENT
- **Docker**: Hardened distroless containers
- **Nginx**: Reverse proxy and load balancer
- **PostgreSQL**: Production database
- **Valkey**: Production cache

### 🔧 SUPPORT LAYER
24. [Deployment Patterns](#24-deployment-patterns)
25. [Security Guidelines](#25-security-guidelines)
26. [Troubleshooting & FAQ](#26-troubleshooting--faq)

---

## 1. Core Development Workflow

**Problem definition → small, safe change → change review → refactor — repeat the loop.**

## 2. Essential Rules

- **Read thoroughly**: Before changing anything, read the relevant files end to end, including all call/reference paths
- **Keep tasks small**: Keep commits and PRs focused and manageable
- **Document assumptions**: If you make assumptions, record them in the Issue/PR/ADR
- **Security first**: Never commit or log secrets; validate inputs and encode/normalize outputs
- **Clear naming**: Avoid premature abstraction and use intention-revealing names
- **Compare options**: Always evaluate multiple approaches before deciding

## 3. Mindset and Approach

### Senior Engineer Thinking

- **Think systematically**: Don't jump to conclusions or rush to solutions
- **Evaluate approaches**: Always analyze multiple options with pros/cons/risks, then choose the simplest solution
- **Context matters**: Understand the broader system impact before making changes

### Workflow Pattern

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Problem      │───▶│  Small Change   │───▶│  Change Review  │───▶│   Refactor     │
│  Definition    │    │                 │    │                 │    │   Loop         │
│                 │    │ • Targeted      │    │ • Validate     │    │   Repeat       │
│ • Context      │    │ • Minimal       │    │ • Impact       │    │   Process      │
│ • Problem      │    │ • Safe          │    │ • Verify       │    │   Continuously  │
│ • Goal         │    │ • Reversible    │    │ • Document     │    │   Improve      │
│ • Constraints   │    │                 │    │                 │    │   Quality      │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 4. Code & File Reference Rules

### Reading Requirements

- **Read thoroughly**: Read files from start to finish (no partial reads)
- **Locate dependencies**: Before changing code, find definitions, references, call sites, related tests, docs/config/flags
- **Full context**: Never change code without reading the entire file
- **Global search**: Before modifying a symbol, search globally to understand pre/postconditions
- **Impact notes**: Leave 1-3 line impact notes explaining changes

### Reference Checklist

Before modifying any symbol:
- [ ] Read entire file containing the symbol
- [ ] Search for all references in the codebase
- [ ] Understand preconditions and postconditions
- [ ] Identify all dependent code
- [ ] Document the impact of the change

### Sub-Task Droid Context Guidelines

When delegating to sub-task droids, provide focused and limited context:

- **Single task focus**: Assign one specific task per sub-task droid
- **Minimal file scope**: Limit context to only the essential files needed for the task
- **Specific boundaries**: Clearly define the scope and boundaries of the work
- **Relevant context only**: Include only the information directly related to the task
- **Clear objectives**: Provide specific, measurable objectives for the sub-task
- **Focused prompt**: Craft prompts that target the specific task without unnecessary background
- **Small file subsets**: When possible, limit to 3-5 relevant files maximum
- **Avoid scope creep**: Keep sub-tasks focused and prevent expansion beyond defined boundaries

**Example**: Instead of providing entire codebase context for a bug fix, provide only:
- The specific file with the bug
- Related test file
- Any directly coupled dependencies
- Clear description of expected behavior vs actual behavior

### Claude Code Integration

When working with Claude Code, leverage specialized droids for optimal results:

- **Use custom droids**: Check available custom droids and use the most relevant one for the task
- **Task tool first**: For complex multi-step tasks, use the Task tool to launch appropriate specialized droids
- **Match droid to task**: Select droids based on their specialization (frontend, backend, testing, security, etc.)
- **Focused delegation**: Provide clear, specific prompts to specialized droids
- **Available droids**: Common droids include:
  - `frontend-engineer-droid-forge` - React/Next.js components and responsive design
  - `backend-security-specialist-droid-forge` - API design and security implementation
  - `database-specialist-droid-forge` - PostgreSQL and Drizzle ORM optimization
  - `testing-droid-forge` - Unit tests, E2E tests, and comprehensive testing strategies
  - `typescript-specialist-droid-forge` - TypeScript integration and type safety
  - `code-reviewer-droid-forge` - Senior engineer code review and quality assessment

**Example pattern**:
```json
{
  "subagent_type": "frontend-engineer-droid-forge",
  "description": "Create responsive component",
  "prompt": "Build a responsive user profile component with TypeScript interfaces and proper accessibility support"
}
```

## 5. Required Coding Rules

### Pre-Development Requirements

- **Problem 1-Pager**: Before coding, write Context/Problem/Goal/Non-Goals/Constraints
- **Code limits**: 
  - File ≤ 300 LOC
  - Function ≤ 50 LOC  
  - Parameters ≤ 5
  - Cyclomatic complexity ≤ 10
- **Refactor when exceeded**: Split/refactor if limits are exceeded

### Code Quality Standards

- **Explicit code**: No hidden "magic"
- **DRY principle**: Follow DRY but avoid premature abstraction
- **Side effects**: Isolate side effects (I/O, network, global state) at boundary layer
- **Error handling**: Catch specific exceptions and present clear user-facing messages
- **Logging**: Use structured logging, never log sensitive data, propagate request/correlation IDs
- **Time zones**: Account for time zones and DST when handling dates

## 6. Testing Rules

### Testing Requirements

- **New code requires tests**: All new code must include tests
- **Regression tests**: Bug fixes must include regression tests (write to fail first)
- **Deterministic tests**: Tests must be deterministic and independent
- **Mock external systems**: Replace external systems with fakes/contract tests
- **Coverage**: Include ≥1 happy path and ≥1 failure path in e2e tests
- **Concurrency**: Proactively assess risks from concurrency/locks/retries

### Testing Patterns

See complete testing examples and patterns: [Testing Patterns Examples](references/testing/testing-patterns-examples.ts)

### Quick Testing Checklist
- **Test Quality**: [Unit Test Template](references/testing/unit-test-template.ts)
- **Test Structure**: Follow AAA (Arrange-Act-Assert) pattern
- **Coverage**: Ensure ≥1 happy path and ≥1 failure path per function
- **Mocking**: Use mocks for external dependencies

## 7. Security Rules

### Security Principles

- **No secrets**: Never leave secrets in code/logs/tickets
- **Input validation**: Always validate, normalize, and encode inputs
- **Parameterized operations**: Use parameterized operations for database queries
- **Least privilege**: Apply the Principle of Least Privilege

### Security Patterns

See detailed security examples: [Input Validation Examples](references/security/input-validation-examples.ts)
- **Database Operations**: [Prisma Query Examples](references/prisma/prisma-query-examples.ts)

### Quick Security Checklist
- **Input Validation**: [Input Validation Examples](references/security/input-validation-examples.ts)
- **Database Operations**: [Prisma Query Examples](references/prisma/prisma-query-examples.ts)
- **Secret Management**: Review [Security Checklist](references/security/security-checklist.md)
- **Error Safety**: [Error Handling Examples](references/errors/error-handling-examples.ts)

## 8. Clean Code Rules

### Code Structure

- **Intention-revealing names**: Use clear, descriptive names
- **Single responsibility**: Each function should do one thing
- **Side effects at boundary**: Keep side effects at the boundary layer
- **Guard clauses first**: Prefer guard clauses over nested conditions
- **Constants**: Symbolize constants (no hardcoding)
- **Input → Process → Return**: Structure code as Input → Process → Return

### Code Examples
- **Guard Clauses**: [Anti-Patterns Examples](references/clean-code/anti-patterns-examples.ts)
- **Constants**: See naming conventions for constants
- **Error Handling**: See [Error Handling Examples](references/errors/error-handling-examples.ts)

### Error Reporting

- **Specific errors**: Report failures with specific error messages
- **Usage examples**: Make tests serve as usage examples with boundary and failure cases

## 9. Anti-Pattern Rules

### What to Avoid

- **No context changes**: Don't modify code without reading the whole context
- **No secrets**: Don't expose secrets in any form
- **No ignored failures**: Don't ignore failures or warnings
- **No unjustified optimization**: Don't optimize without clear performance evidence
- **No unnecessary abstraction**: Don't introduce abstractions without clear need
- **No broad exceptions**: Don't overuse broad exception types

### Common Anti-Patterns

```typescript
// AVOID: Uninitialized variables
let user: User | undefined;
if (condition) {
  user = fetchUser();
}

// PREFER: IIFE with type annotation
const user: User | null = (() => {
  if (!condition) return null;
  return fetchUser();
})();

// AVOID: Multiple nested ifs
if (condition1) {
  if (condition2) {
    if (condition3) {
      doSomething();
    }
  }
}

// PREFER: Guard clauses
if (!condition1 || !condition2 || !condition3) return;
doSomething();
```

## 10. TypeScript Specific Rules

### Import and Export Rules

- **Normal imports**: Always use normal imports instead of dynamic imports
- **No require**: Always use ESM imports, never CommonJS require
- **Absolute imports**: Prefer non-relative imports with package names
- **Explicit array types**: Always specify types for arrays

```typescript
// Good: Normal imports
import React from 'react';
import { useState } from 'react';
import fs from 'node:fs';

// Good: Explicit array types
const items: string[] = [];
const users: User[] = [];
const numbers: number[] = [];

// Good: Object arguments for multiple parameters
function createUser({ email, name, role }: {
  email: string;
  name: string;
  role: string;
}): User {
  // implementation
}
```

### Function and Variable Rules

- **Arrow functions**: Always use {} block body in arrow functions
- **No any**: Never use `any` type, always find proper types
- **IIFE over late assignment**: Use IIFE instead of uninitialized variables
- **URL construction**: Use `new URL(path, baseUrl)` instead of string interpolation

```typescript
// Good: Arrow function with block body
const handleClick = () => {
  setState('value');
  doSomethingElse();
};

// Good: IIFE pattern
const result: string = (() => {
  if (!condition) return '';
  return processValue();
})();

// Good: URL construction
const url = new URL('/api/users', 'https://api.example.com');
```

### Type Safety Rules

- **Read .d.ts files**: When encountering TypeScript errors, read the type definitions
- **No as any**: Never use `(x as any).field` without checking if it compiles first
- **Prefer || over in**: Use `obj?.x || ''` instead of `'x' in obj ? obj.x : ''`

## 11. Prisma Specific Rules

### Database Interaction

- **Read schema first**: Always read schema.prisma before writing queries
- **No schema changes**: Never add tables or modify schema.prisma yourself
- **No mutations**: NEVER run `pnpm prisma db push` or other mutating commands
- **Upsert preferred**: Use upsert calls over updates to handle missing rows

### Query Patterns

```typescript
// Good: Simple query with authorization
const user = await prisma.user.findFirst({
  where: { 
    id: userId,
    organization: { users: { some: { userId } } }
  }
});

if (!user) {
  throw new AppError('User not found or access denied');
}

// Good: Parallel queries for relations
const [user, posts] = await Promise.all([
  prisma.user.findUnique({ where: { id: userId } }),
  prisma.post.findMany({ where: { userId } })
]);

// AVOID: Deep nesting
const badQuery = prisma.user.findFirst({
  where: { id: userId },
  include: {
    posts: {
      include: {
        comments: {
          include: {
            author: true // Too deep!
          }
        }
      }
    }
  }
});
```

### Transaction Rules

- **Array transactions**: Use array of operations, not interactive transactions
- **No await during construction**: Never call await while building operations array

```typescript
// Good: Array transaction
const operations: Prisma.PrismaPromise<any>[] = [
  prisma.user.delete({ where: { id } }),
  prisma.profile.delete({ where: { userId: id } }),
  prisma.settings.delete({ where: { userId: id } })
];

await prisma.$transaction(operations);
```

## 12. Styling Rules

### Tailwind Guidelines

- **Use multiples of 4**: Prefer spacing multiples of 4 (p-4, gap-4, etc.)
- **Flex over margin**: Use flexbox gaps and grid gaps instead of margins
- **shadcn colors**: Use shadcn theme colors instead of default Tailwind colors
- **Simple styles**: Keep styles simple and use flex and gap

```typescript
// Good: Flex with gap
<div className="flex flex-col gap-4">
  <Component1 />
  <Component2 />
</div>

// Good: Size-4 over w-4 h-4
<Icon className="size-4" />

// Good: cn utility
<div className={cn('base-class', isActive && 'active-class')} />
```

### Component Guidelines

- **shadcn CLI**: Use shadcn CLI to add new components, don't write them manually
- **Reuse components**: Prefer reusing existing components when possible
- **Simple breakpoints**: Keep breakpoints and responsive design simple

## 13. Error Handling Rules

### Error Patterns

- **AppError class**: Use AppError for expected errors
- **ResponseError**: Use ResponseError for HTTP error responses

```typescript
// Expected error
if (!user.subscription) {
  throw new AppError('User has no subscription');
}

// HTTP error response
if (!hasPermission) {
  throw new ResponseError(
    403,
    JSON.stringify({ message: 'Access denied' })
  );
}
```

## 14. Changelog Rules

### Package Types

- **Public packages**: Have version field in package.json, published to npm
- **Private packages**: Have `private: true` field in package.json

### Changelog Format

**Public packages**:
```markdown
## 0.1.3

### Version History

### v1.1.0 - Current (2025-06-17)
- **Major optimization**: 85% token reduction achieved (122,000 → ~17,500 tokens)
- **Reordered structure**: Mandatory rules moved to beginning
- **Modular references**: Code examples extracted to reference files
- **Enhanced**: Added Non-Negotiables section for immediate rule access
- **Expanded**: Additional reference files for testing, git, and security

### v1.0.0 - Original (2025-06-17)
- Initial version created
- Monolithic structure with all content in single file
- ~122,000 tokens
- All sections included in single document

## 0.1.2

### Patch Changes
- fix authentication bug
- improve error messages
- add support for new feature

**Private packages**:
```markdown
# Changelog

## 2025-01-24 19:50
- improve user experience
- fix startup crash
```

### Writing Guidelines

- **Present tense**: Use present tense (fix, improve, add)
- **Concise**: Omit unnecessary verbs (implement, added)
- **No nesting**: Don't use nested bullet points
- **Code examples**: Include code snippets when applicable
- **Markdown**: Use proper markdown formatting

---

## Reference Files

This guide references external files for detailed examples and patterns. These are loaded on-demand to keep the main guide lightweight while providing comprehensive implementation details.

### Code Examples
- [Component Interface Example](references/code/typescript-component-interface.ts) - Standard pattern for React component props with TypeScript interfaces
- [Error Handling Patterns](references/patterns/error-handling-patterns.ts) - Comprehensive error type definitions and result wrapper patterns
- [API Response Patterns](references/patterns/api-response-patterns.ts) - Unified API response structure for consistent droid communications

### Patterns & Guidelines
- [Naming Conventions](references/patterns/naming-conventions.md) - File, variable, and function naming standards for consistency
- [Validation Checklists](references/checklists/validation-checklist.md) - Quality assurance checklists for TypeScript components

### Templates
- [ADR Template](references/templates/adr-template.md) - Architecture Decision Record template for documenting significant decisions
- [Project Structure Template](references/templates/project-structure.md) - Standard directory organization and file structure patterns

### Quick Access References
*Use these files for immediate guidance on common tasks:*
- **Code Quality**: [Validation Checklist](references/checklists/validation-checklist.md)
- **Naming Standards**: [Naming Conventions](references/patterns/naming-conventions.md)
- **Component Examples**: [TypeScript Interface](references/code/typescript-component-interface.ts)
- **Error Patterns**: [Error Handling](references/patterns/error-handling-patterns.ts)
- **Testing**: [Unit Test Template](references/testing/unit-test-template.ts)
- **Git Workflows**: [Commit Guidelines](references/git/commit-message-guidelines.md)
- **Security**: [Security Checklist](references/security/security-checklist.md)

---

## 15. Guiding Principles (Previously Section 1)

This guide is a living document, not a rigid set of rules. Droids should adhere to the following principles to balance consistency with the flexibility required for effective problem-solving.

### 15.1 Simplicity Above All
- Make every task and code change as simple as possible
- Avoid complexity and impact the minimum amount of code necessary
- When in doubt, choose the simpler solution
- Prefer explicit code over hidden "magic"

### 15.2 Iterative Development (MVG)
- Start with a Minimum Viable Guide (MVG) and expand it iteratively
- Deliver value quickly and refine based on real-world application
- Perfect is the enemy of good - focus on working solutions first
- Use feedback loops to improve incrementally

### 15.3 Embrace Flexibility
- The patterns herein are guidelines, not immutable laws
- Autonomy to deviate when a clearly better, simpler, or more efficient solution presents itself
- Document deviations via an Architecture Decision Record (ADR)
- Balance consistency with pragmatic problem-solving

### 15.4 Clear Communication
- Use visual flow diagrams (ASCII art) and concise explanations
- Clarity is more important than jargon
- Document decisions and their rationale
- Provide concrete examples for abstract concepts

---

## 26. Troubleshooting & FAQ (Previously Section 12)

*This section will be expanded with common problems and solutions*

### Quick Reference

For immediate help with common issues, refer to the [validation checklist](references/checklists/validation-checklist.md) and [naming conventions](references/patterns/naming-conventions.md).

### Common Issues

- **Issue**: TypeScript compilation errors
  - **Solution**: Check type definitions in .d.ts files and ensure proper imports
- **Issue**: Code organization issues
  - **Solution**: Follow naming conventions and directory structure patterns
- **Issue**: Testing failures
  - **Solution**: Ensure tests are deterministic and mock external dependencies properly

### Debugging Strategies

*This section will include debugging approaches for droids*

### Performance Optimization

*This section will cover performance tuning guidelines*
