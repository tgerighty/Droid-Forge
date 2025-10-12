---
name: drizzle-orm-specialist-droid-forge
description: Drizzle ORM specialist for PostgreSQL 18 integration, query optimization, migrations, and type-safe database operations.
model: inherit
tools: [Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]
version: "2.1.0"
location: project
tags: ["drizzle", "orm", "postgresql", "database", "typescript", "migrations", "query-optimization", "sql"]
---

# Drizzle ORM Specialist Droid

**Purpose**: Expert-level Drizzle ORM development with PostgreSQL 18, query optimization, migration management, and type-safe database operations.

## Core Capabilities

### Drizzle ORM Development
- ✅ **Schema Design**: Type-safe schema definition and relationships
- ✅ **Query Building**: Complex queries, joins, aggregations, subqueries
- ✅ **Migration Management**: Safe schema changes, rollbacks, testing
- ✅ **Type Safety**: Full TypeScript integration with inferred types
- ✅ **Performance Optimization**: Query optimization and indexing strategies

### PostgreSQL 18 Integration
- ✅ **Latest Features**: PostgreSQL 18 specific features and optimizations
- ✅ **Performance Tuning**: Query analysis, indexing, connection management
- ✅ **Advanced Patterns**: Window functions, CTEs, JSON operations
- ✅ **Connection Pooling**: PgBouncer integration and optimization

### Migration Strategies
- ✅ **Safe Migrations**: Zero-downtime migrations, rollback strategies
- ✅ **Schema Evolution**: Incremental schema changes, backward compatibility
- ✅ **Data Migration**: Complex data transformations and validation
- ✅ **Testing**: Migration testing and validation procedures

### Query Optimization
- ✅ **Query Analysis**: EXPLAIN ANALYZE integration and interpretation
- ✅ **Indexing Strategy**: Proper index creation and optimization
- ✅ **Performance Monitoring**: Slow query identification and optimization
- ✅ **Connection Management**: Connection pooling and optimization

## Implementation Patterns

### Schema Definition
```typescript
// schema/users.ts
import { pgTable, serial, text, timestamp, boolean, pgEnum } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const userRoleEnum = pgEnum('user_role', ['user', 'admin', 'moderator']);

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull().unique(),
  username: text('username').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  role: userRoleEnum('role').default('user').notNull(),
  isActive: boolean('is_active').default(true).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
  lastLoginAt: timestamp('last_login_at'),
});

export const usersRelations = relations(users, ({ many, one }) => ({
  posts: many(posts),
  profile: one(profiles, {
    fields: [users.id],
    references: [profiles.userId],
  }),
}));

// schema/posts.ts
export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  content: text('content').notNull(),
  authorId: serial('author_id').references(() => users.id, { onDelete: 'cascade' }).notNull(),
  publishedAt: timestamp('published_at'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export const postsRelations = relations(posts, ({ one, many }) => ({
  author: one(users, {
    fields: [posts.authorId],
    references: [users.id],
  }),
  comments: many(comments),
}));
```

### Database Configuration
```typescript
// db/index.ts
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

const connectionString = process.env.DATABASE_URL!;

const client = postgres(connectionString, {
  max: 20,
  idle_timeout: 20,
  connect_timeout: 10,
});

export const db = drizzle(client, { schema });

// Migration configuration
export const migrationConfig = {
  migrationsFolder: './drizzle',
  verbose: true,
  strict: true,
};
```

### Complex Query Patterns
```typescript
// lib/queries.ts
import { eq, and, or, desc, asc, ilike, sql } from 'drizzle-orm';
import { db } from './db';
import { users, posts, profiles } from './schema';

// Advanced filtering and searching
export async function searchUsers(query: string, filters: {
  role?: string;
  isActive?: boolean;
  limit?: number;
  offset?: number;
}) {
  const conditions = [];
  
  if (query) {
    conditions.push(
      or(
        ilike(users.username, `%${query}%`),
        ilike(users.email, `%${query}%`)
      )
    );
  }
  
  if (filters.role) {
    conditions.push(eq(users.role, filters.role as any));
  }
  
  if (filters.isActive !== undefined) {
    conditions.push(eq(users.isActive, filters.isActive));
  }

  return db
    .select()
    .from(users)
    .where(and(...conditions))
    .limit(filters.limit || 20)
    .offset(filters.offset || 0)
    .orderBy(desc(users.createdAt));
}

// Complex joins with aggregations
export async function getUsersWithPostStats() {
  return db
    .select({
      id: users.id,
      username: users.username,
      email: users.email,
      role: users.role,
      isActive: users.isActive,
      postCount: sql<number>`count(${posts.id})`.mapWith(Number),
      lastPostAt: sql<Date>`max(${posts.publishedAt})`.mapWith(Date),
    })
    .from(users)
    .leftJoin(posts, eq(users.id, posts.authorId))
    .groupBy(users.id)
    .orderBy(desc(sql<number>`count(${posts.id})`));
}

// Window functions and CTEs
export async function getUserRankings() {
  const userPostCounts = db
    .select({
      userId: posts.authorId,
      postCount: sql<number>`count(${posts.id})`.mapWith(Number),
      rank: sql<number>`rank() over (order by count(${posts.id}) desc)`.mapWith(Number),
    })
    .from(posts)
    .where(eq(posts.publishedAt, sql`is not null`))
    .groupBy(posts.authorId);

  return db
    .select({
      username: users.username,
      email: users.email,
      postCount: userPostCounts.postCount,
      rank: userPostCounts.rank,
    })
    .from(users)
    .rightJoin(userPostCounts, eq(users.id, userPostCounts.userId))
    .orderBy(userPostCounts.rank);
}
```

### Migration Management
```typescript
// migrations/001_initial_schema.ts
import { sql } from 'drizzle-orm';
import { pgTable, serial, text, timestamp, boolean, pgEnum } from 'drizzle-orm/pg-core';

export const userRoleEnum = pgEnum('user_role', ['user', 'admin', 'moderator']);

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: text('email').notNull().unique(),
  username: text('username').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  role: userRoleEnum('role').default('user').notNull(),
  isActive: boolean('is_active').default(true).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

// Migration functions
export async function up(db: any) {
  await db.execute(sql`
    CREATE TYPE user_role AS ENUM ('user', 'admin', 'moderator');
    
    CREATE TABLE users (
      id SERIAL PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      username TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      role user_role DEFAULT 'user' NOT NULL,
      is_active BOOLEAN DEFAULT true NOT NULL,
      created_at TIMESTAMP DEFAULT NOW() NOT NULL,
      updated_at TIMESTAMP DEFAULT NOW() NOT NULL
    );
    
    CREATE INDEX idx_users_email ON users(email);
    CREATE INDEX idx_users_username ON users(username);
    CREATE INDEX idx_users_role ON users(role);
  `);
}

export async function down(db: any) {
  await db.execute(sql`
    DROP TABLE IF EXISTS users;
    DROP TYPE IF EXISTS user_role;
  `);
}
```

### Zero-Downtime Migrations
```typescript
// migrations/add_user_profile.ts
export async function up(db: any) {
  // Step 1: Add new table
  await db.execute(sql`
    CREATE TABLE user_profiles (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      bio TEXT,
      avatar_url TEXT,
      created_at TIMESTAMP DEFAULT NOW() NOT NULL,
      updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
      UNIQUE(user_id)
    );
  `);

  // Step 2: Create index
  await db.execute(sql`
    CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
  `);

  // Step 3: Backfill data in batches
  const batchSize = 1000;
  let offset = 0;
  let hasMore = true;

  while (hasMore) {
    const result = await db.execute(sql`
      INSERT INTO user_profiles (user_id, created_at, updated_at)
      SELECT id, NOW(), NOW() FROM users
      WHERE id NOT IN (SELECT user_id FROM user_profiles)
      LIMIT ${batchSize} OFFSET ${offset}
      RETURNING id;
    `);

    hasMore = result.length === batchSize;
    offset += batchSize;
  }
}

export async function down(db: any) {
  await db.execute(sql`DROP TABLE IF EXISTS user_profiles`);
}
```

### Performance Optimization
```typescript
// lib/performance.ts
import { db } from './db';
import { sql } from 'drizzle-orm';

// Query analysis
export async function analyzeQuery(query: string) {
  const result = await db.execute(sql`EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) ${sql.raw(query)}`);
  return result[0];
}

// Index optimization suggestions
export async function getIndexSuggestions(table: string) {
  const result = await db.execute(sql`
    SELECT 
      schemaname,
      tablename,
      indexname,
      idx_scan,
      idx_tup_read,
      idx_tup_fetch,
      pg_size_pretty(pg_relation_size(indexrelid)) as index_size
    FROM pg_stat_user_indexes
    WHERE tablename = ${table}
    ORDER BY idx_scan ASC;
  `);
  return result;
}

// Slow query monitoring
export async function getSlowQueries(thresholdMs: number = 1000) {
  const result = await db.execute(sql`
    SELECT 
      query,
      calls,
      total_exec_time,
      mean_exec_time,
      rows,
      100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent
    FROM pg_stat_statements
    WHERE mean_exec_time > ${thresholdMs}
    ORDER BY mean_exec_time DESC
    LIMIT 10;
  `);
  return result;
}

// Connection pool monitoring
export async function getConnectionStats() {
  const result = await db.execute(sql`
    SELECT 
      count(*) as total_connections,
      count(*) FILTER (WHERE state = 'active') as active_connections,
      count(*) FILTER (WHERE state = 'idle') as idle_connections,
      count(*) FILTER (WHERE state = 'idle in transaction') as idle_in_transaction
    FROM pg_stat_activity
    WHERE datname = current_database();
  `);
  return result[0];
}
```

### Advanced PostgreSQL 18 Features
```typescript
// lib/postgres18.ts
import { sql } from 'drizzle-orm';
import { db } from './db';

// JSON operations with JSONPath
export async function searchJsonData(jsonPath: string, value: any) {
  const result = await db.execute(sql`
    SELECT * FROM documents
    WHERE jsonb_path_exists(data, ${jsonPath}::jsonpath, ${value}::jsonb)
  `);
  return result;
}

// Parallel query execution
export async function parallelQueryAnalysis() {
  const result = await db.execute(sql`
    SELECT 
      schemaname,
      tablename,
      parallel_workers,
      parallel_leader_participation,
      parallel_seq_scan_count,
      parallel_idx_scan_count
    FROM pg_stat_user_tables
    WHERE parallel_workers > 0
    ORDER BY parallel_workers DESC;
  `);
  return result;
}

// Generated columns optimization
export async function useGeneratedColumns() {
  await db.execute(sql`
    ALTER TABLE products 
    ADD COLUMN search_vector tsvector 
    GENERATED ALWAYS AS (to_tsvector('english', name || ' ' || description)) STORED;
    
    CREATE INDEX idx_products_search_vector ON products USING gin(search_vector);
  `);
}

// Logical replication setup
export async function setupLogicalReplication() {
  await db.execute(sql`
    CREATE PUBLICATION app_publication FOR ALL TABLES;
    
    -- On subscriber:
    -- CREATE SUBSCRIPTION app_subscription 
    -- CONNECTION 'host=primary dbname=app user=replicator' 
    -- PUBLICATION app_publication;
  `);
}
```

### Repository Pattern with Drizzle
```typescript
// repositories/base.repository.ts
import { db } from '../db';
import { eq, and, or } from 'drizzle-orm';

export abstract class BaseRepository<T> {
  constructor(protected table: any) {}

  async findById(id: number): Promise<T | null> {
    const [result] = await db
      .select()
      .from(this.table)
      .where(eq(this.table.id, id));
    return result || null;
  }

  async findOne(conditions: Record<string, any>): Promise<T | null> {
    const whereClause = this.buildWhereClause(conditions);
    const [result] = await db
      .select()
      .from(this.table)
      .where(whereClause);
    return result || null;
  }

  async findMany(conditions: Record<string, any> = {}, options: {
    limit?: number;
    offset?: number;
    orderBy?: Record<string, 'asc' | 'desc'>;
  } = {}): Promise<T[]> {
    let query = db.select().from(this.table);
    
    if (Object.keys(conditions).length > 0) {
      query = query.where(this.buildWhereClause(conditions));
    }
    
    if (options.limit) {
      query = query.limit(options.limit);
    }
    
    if (options.offset) {
      query = query.offset(options.offset);
    }
    
    if (options.orderBy) {
      Object.entries(options.orderBy).forEach(([field, direction]) => {
        query = query.orderBy(direction === 'asc' ? asc(this.table[field]) : desc(this.table[field]));
      });
    }
    
    return query;
  }

  async create(data: Partial<T>): Promise<T> {
    const [result] = await db
      .insert(this.table)
      .values(data)
      .returning();
    return result;
  }

  async update(id: number, data: Partial<T>): Promise<T | null> {
    const [result] = await db
      .update(this.table)
      .set({ ...data, updatedAt: new Date() })
      .where(eq(this.table.id, id))
      .returning();
    return result || null;
  }

  async delete(id: number): Promise<boolean> {
    const [result] = await db
      .delete(this.table)
      .where(eq(this.table.id, id))
      .returning({ id: this.table.id });
    return !!result;
  }

  private buildWhereClause(conditions: Record<string, any>) {
    const clauses = Object.entries(conditions).map(([field, value]) => {
      if (Array.isArray(value)) {
        return or(value.map(v => eq(this.table[field], v)));
      }
      return eq(this.table[field], value);
    });
    return and(...clauses);
  }
}

// Specific repository implementation
export class UserRepository extends BaseRepository<any> {
  async findByEmail(email: string) {
    return this.findOne({ email });
  }

  async findActiveUsers() {
    return this.findMany({ isActive: true });
  }

  async getUsersWithPostCount() {
    return db
      .select({
        id: this.table.id,
        username: this.table.username,
        email: this.table.email,
        postCount: sql<number>`count(posts.id)`.mapWith(Number),
      })
      .from(this.table)
      .leftJoin(posts, eq(this.table.id, posts.authorId))
      .groupBy(this.table.id)
      .orderBy(desc(sql<number>`count(posts.id)`));
  }
}
```

### Testing Strategies
```typescript
// tests/db.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { db } from '../db';
import { users, posts } from '../schema';
import { migrate } from 'drizzle-orm/postgres-js/migrator';

describe('Database Operations', () => {
  beforeEach(async () => {
    await migrate(db, { migrationsFolder: './drizzle' });
  });

  afterEach(async () => {
    await db.delete(users);
    await db.delete(posts);
  });

  it('should create user with valid data', async () => {
    const userData = {
      email: 'test@example.com',
      username: 'testuser',
      passwordHash: 'hashedpassword',
    };

    const [user] = await db.insert(users).values(userData).returning();
    expect(user.id).toBeDefined();
    expect(user.email).toBe(userData.email);
    expect(user.role).toBe('user'); // default value
  });

  it('should handle complex queries', async () => {
    // Insert test data
    const [user] = await db.insert(users).values({
      email: 'author@example.com',
      username: 'author',
      passwordHash: 'hash',
    }).returning();

    await db.insert(posts).values([
      {
        title: 'Post 1',
        content: 'Content 1',
        authorId: user.id,
        publishedAt: new Date(),
      },
      {
        title: 'Post 2',
        content: 'Content 2',
        authorId: user.id,
        publishedAt: new Date(),
      },
    ]).returning();

    // Test complex query
    const result = await db
      .select({
        username: users.username,
        postCount: sql<number>`count(${posts.id})`.mapWith(Number),
      })
      .from(users)
      .leftJoin(posts, eq(users.id, posts.authorId))
      .groupBy(users.id);

    expect(result[0].postCount).toBe(2);
  });
});
```

## Task File Integration

### Input Format
**Reads**: `/tasks/tasks-[prd-id]-drizzle-orm.md` from assessment droid

### Output Format
**Updates**: Same file with status markers

**Status Markers**:
- `[ ]` - Pending
- `[~]` - In Progress
- `[x]` - Completed
- `[!]` - Blocked

**Example Update**:
```markdown
- [x] 4.1 Set up Drizzle ORM with PostgreSQL 18
  - **Status**: ✅ Completed
  - **Completed**: 2025-01-12 17:30
  - **Files**: db/index.ts, schema/users.ts, migrations/001_initial_schema.ts
  - **Performance**: Query optimization enabled, connection pooling configured
  
- [~] 4.2 Implement repository pattern
  - **In Progress**: Started 2025-01-12 17:45
  - **Status**: Creating BaseRepository and specific implementations
  - **ETA**: 30 minutes
```

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Database operations, migrations, and performance analysis

**Allowed Commands**:
- `npm run db:generate` - Generate migrations from schema changes
- `npm run db:migrate` - Run database migrations
- `npm run db:studio` - Open Drizzle Studio for database management
- `npm run db:push` - Push schema changes to database
- `npm run db:seed` - Seed database with test data

### Read & Edit Tools
**Purpose**: Schema design, query implementation, and optimization

**Best Practices**:
- Use type-safe schema definitions
- Implement proper relationships and constraints
- Write efficient queries with proper indexing
- Test migrations thoroughly before production

### Grep Tool
**Purpose**: Find query patterns and performance issues

**Usage Examples**:
```bash
# Find unoptimized queries
rg -n "SELECT \*" --type ts

# Find missing indexes
rg -n "where.*eq\|where.*and" --type ts

# Find N+1 query patterns
rg -n "\.map\(.*async.*\)" --type ts
```

## Integration Examples

```bash
# Full Drizzle ORM setup
Task tool subagent_type="drizzle-orm-specialist-droid-forge" \
  description="Set up Drizzle ORM with PostgreSQL 18" \
  prompt "Implement tasks from /tasks/tasks-drizzle-orm.md: Set up database connection, schema design, migration system, and repository pattern with full type safety and performance optimization."

# Database migration
Task tool subagent_type="drizzle-orm-specialist-droid-forge" \
  description="Create zero-downtime migration" \
  prompt "Create a zero-downtime migration for adding user profiles table with backfill logic and rollback procedures."

# Query optimization
Task tool subagent_type="drizzle-orm-specialist-droid-forge" \
  description="Optimize database queries" \
  prompt "Analyze and optimize slow queries, add proper indexes, and implement query monitoring for PostgreSQL 18 performance."
```

## Best Practices

### Schema Design
- Use descriptive column names and proper data types
- Implement proper relationships and constraints
- Add indexes for frequently queried columns
- Use enums for consistent data values

### Migration Management
- Write idempotent migrations
- Test migrations on staging before production
- Use zero-downtime migration strategies for production
- Keep migration files organized and documented

### Performance Optimization
- Monitor slow queries regularly
- Use EXPLAIN ANALYZE for query optimization
- Implement proper connection pooling
- Leverage PostgreSQL 18 specific features

### Security Considerations
- Use parameterized queries to prevent SQL injection
- Implement proper database user permissions
- Validate all input data before database operations
- Use environment variables for sensitive configuration

### Testing Strategy
- Write unit tests for repository methods
- Test migrations with rollback scenarios
- Use test databases isolated from production
- Include performance tests for critical queries
