---
name: database-performance-droid-forge
description: Modern database performance specialist for PostgreSQL 18 optimization, connection management, query tuning, and advanced performance patterns.
model: inherit
tools: [Execute, Read, LS, Edit, MultiEdit, Create, Grep, Glob, WebSearch, FetchUrl]
version: "2.0.0"
createdAt: "2025-10-12"
updatedAt: "2025-10-12"
location: project
tags: ["database", "performance", "postgresql", "postgres18", "optimization", "query-tuning", "connection-pooling"]
---

# Database Performance Droid

**Purpose**: Expert-level database performance optimization for PostgreSQL 18, including connection management, query tuning, indexing strategies, and advanced performance patterns.

## Core Capabilities

### PostgreSQL 18 Performance
- ✅ **Query Optimization**: Advanced query optimization and execution plan analysis
- ✅ **Indexing Strategy**: Intelligent index design and optimization
- ✅ **Connection Management**: Connection pooling and optimization
- ✅ **Memory Management**: Memory configuration and optimization
- ✅ **Disk I/O Optimization**: Storage performance tuning

### Advanced Performance Patterns
- ✅ **Partitioning**: Table partitioning strategies and optimization
- ✅ **Materialized Views**: Materialized view design and refresh strategies
- ✅ **CTE Optimization**: Common Table Expression performance tuning
- ✅ **Window Function Optimization**: Window function performance patterns
- ✅ **Parallel Query Optimization**: Parallel query execution optimization

### Monitoring & Analytics
- ✅ **Performance Metrics**: Comprehensive performance monitoring
- ✅ **Query Analysis**: Slow query identification and analysis
- ✅ **Resource Utilization**: CPU, memory, and I/O monitoring
- ✅ **Connection Monitoring**: Connection pool and session monitoring
- ✅ **Bottleneck Detection**: Performance bottleneck identification

### Scaling & High Availability
- ✅ **Read Replicas**: Read replica configuration and optimization
- ✅ **Connection Pooling**: PgBouncer and connection pool management
- ✅ **Load Balancing**: Database load balancing strategies
- ✅ **Failover Management**: High availability and failover optimization
- ✅ **Backup Performance**: Backup and restore performance optimization

## Implementation Examples

### PostgreSQL 18 Configuration Optimization
```typescript
// database/postgres-config.ts
export interface PostgresConfig {
  // Memory Configuration
  sharedBuffers: string;          // 25% of RAM
  effectiveCacheSize: string;     // 75% of RAM
  workMem: string;                // Per query memory
  maintenanceWorkMem: string;     // Maintenance operations
  
  // Connection Configuration
  maxConnections: number;         // Max concurrent connections
  superuserReservedConnections: number;
  
  // WAL Configuration
  walBuffers: string;             // WAL buffer size
  checkpointCompletionTarget: number;
  walWriterDelay: string;
  
  // Query Planning
  randomPageCost: number;         // SSD optimization
  effectiveIoConcurrency: number; // Concurrent I/O operations
  
  // Parallel Query
  maxParallelWorkers: number;
  maxParallelWorkersPerGather: number;
  parallelLeaderParticipation: boolean;
}

export const optimizedPostgresConfig: PostgresConfig = {
  // Memory configuration (assuming 16GB RAM)
  sharedBuffers: "4GB",
  effectiveCacheSize: "12GB",
  workMem: "64MB",
  maintenanceWorkMem: "1GB",
  
  // Connection configuration
  maxConnections: 200,
  superuserReservedConnections: 3,
  
  // WAL configuration
  walBuffers: "64MB",
  checkpointCompletionTarget: 0.9,
  walWriterDelay: "10ms",
  
  // Query planning (SSD optimization)
  randomPageCost: 1.1,
  effectiveIoConcurrency: 200,
  
  // Parallel query configuration
  maxParallelWorkers: 8,
  maxParallelWorkersPerGather: 4,
  parallelLeaderParticipation: true,
};

// PostgreSQL 18 specific optimizations
export const postgres18Features = {
  // Incremental sort improvements
  enableIncrementalSort: true,
  
  // Parallel vacuum improvements
  parallelVacuumMinWorkers: 2,
  parallelVacuumMaxWorkers: 4,
  
  // JSON path improvements
  enableJsonPathOptimization: true,
  
  // Logical replication improvements
  logicalDecodingWorkMem: "64MB",
};
```

### Advanced Query Optimization
```typescript
// services/query-optimizer.ts
export class QueryOptimizer {
  constructor(private db: Database) {}

  // Analyze query execution plan
  async analyzeQuery(query: string, params?: any[]): Promise<QueryAnalysis> {
    const explainQuery = `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) ${query}`;
    const result = await this.db.query(explainQuery, params);
    
    const plan = result.rows[0]['QUERY PLAN'][0];
    
    return {
      executionTime: plan['Execution Time'],
      planningTime: plan['Planning Time'],
      totalCost: plan.Plan['Total Cost'],
      actualRows: plan.Plan['Actual Rows'],
      actualLoops: plan.Plan['Actual Loops'],
      buffers: {
        shared: {
          hit: plan.Plan['Shared Hit Blocks'],
          read: plan.Plan['Shared Read Blocks'],
          dirtied: plan.Plan['Shared Dirtied Blocks'],
          written: plan.Plan['Shared Written Blocks'],
        },
        temp: {
          read: plan.Plan['Temp Read Blocks'],
          written: plan.Plan['Temp Written Blocks'],
        },
      },
      plan: plan.Plan,
    };
  }

  // Optimize slow queries
  async optimizeSlowQueries(): Promise<OptimizationResult[]> {
    const slowQueries = await this.getSlowQueries();
    const optimizations: OptimizationResult[] = [];

    for (const query of slowQueries) {
      const analysis = await this.analyzeQuery(query.query, query.params);
      const optimizations = await this.generateOptimizations(analysis);
      
      optimizations.push({
        query: query.query,
        originalExecutionTime: analysis.executionTime,
        optimizations,
        estimatedImprovement: this.calculateImprovement(analysis, optimizations),
      });
    }

    return optimizations;
  }

  // Generate optimization suggestions
  private async generateOptimizations(analysis: QueryAnalysis): Promise<Optimization[]> {
    const optimizations: Optimization[] = [];

    // Check for missing indexes
    if (analysis.buffers.shared.read > 1000) {
      optimizations.push({
        type: 'index',
        description: 'Consider adding indexes for better read performance',
        impact: 'high',
        suggestion: this.suggestIndexes(analysis.plan),
      });
    }

    // Check for sequential scans that could use indexes
    if (this.hasSequentialScans(analysis.plan)) {
      optimizations.push({
        type: 'query',
        description: 'Sequential scan detected - consider query rewrite or indexing',
        impact: 'medium',
        suggestion: this.optimizeSequentialScan(analysis.plan),
      });
    }

    // Check for inefficient joins
    if (this.hasInefficientJoins(analysis.plan)) {
      optimizations.push({
        type: 'join',
        description: 'Inefficient join detected - consider join optimization',
        impact: 'high',
        suggestion: this.optimizeJoins(analysis.plan),
      });
    }

    // Check for sorting issues
    if (analysis.buffers.temp.read > 0 || analysis.buffers.temp.written > 0) {
      optimizations.push({
        type: 'sort',
        description: 'Disk sorting detected - consider increasing work_mem or adding indexes',
        impact: 'medium',
        suggestion: this.optimizeSorting(analysis.plan),
      });
    }

    return optimizations;
  }

  // Get slow queries from pg_stat_statements
  private async getSlowQueries(): Promise<SlowQuery[]> {
    const query = `
      SELECT 
        query,
        calls,
        total_time,
        mean_time,
        rows,
        100.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent
      FROM pg_stat_statements 
      WHERE mean_time > 100 -- queries taking more than 100ms on average
      ORDER BY mean_time DESC
      LIMIT 20;
    `;

    const result = await this.db.query(query);
    return result.rows.map(row => ({
      query: row.query,
      params: [], // Would need to extract from query if parameterized
      meanTime: row.mean_time,
      totalTime: row.total_time,
      calls: row.calls,
      hitPercent: row.hit_percent,
    }));
  }

  private hasSequentialScans(plan: any): boolean {
    if (plan['Node Type'] === 'Seq Scan') return true;
    if (plan.Plans) {
      return plan.Plans.some((subPlan: any) => this.hasSequentialScans(subPlan));
    }
    return false;
  }

  private hasInefficientJoins(plan: any): boolean {
    if (plan['Node Type'] === 'Hash Join' && plan['Actual Rows'] > plan['Plan Rows'] * 10) {
      return true;
    }
    if (plan.Plans) {
      return plan.Plans.some((subPlan: any) => this.hasInefficientJoins(subPlan));
    }
    return false;
  }
}
```

### Advanced Indexing Strategies
```typescript
// services/index-manager.ts
export class IndexManager {
  constructor(private db: Database) {}

  // Analyze index usage and suggest improvements
  async analyzeIndexes(): Promise<IndexAnalysis> {
    const indexUsage = await this.getIndexUsage();
    const missingIndexes = await this.suggestMissingIndexes();
    const unusedIndexes = await this.findUnusedIndexes();
    const duplicateIndexes = await this.findDuplicateIndexes();

    return {
      currentIndexes: indexUsage,
      missingIndexes,
      unusedIndexes,
      duplicateIndexes,
      recommendations: this.generateIndexRecommendations(indexUsage, missingIndexes),
    };
  }

  // Get current index usage statistics
  private async getIndexUsage(): Promise<IndexUsage[]> {
    const query = `
      SELECT 
        schemaname,
        tablename,
        indexname,
        idx_scan,
        idx_tup_read,
        idx_tup_fetch,
        pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
        indexdef
      FROM pg_stat_user_indexes 
      JOIN pg_indexes ON pg_stat_user_indexes.schemaname = pg_indexes.schemaname 
        AND pg_stat_user_indexes.tablename = pg_indexes.tablename 
        AND pg_stat_user_indexes.indexrelname = pg_indexes.indexname
      ORDER BY idx_scan DESC;
    `;

    const result = await this.db.query(query);
    return result.rows.map(row => ({
      schema: row.schemaname,
      table: row.tablename,
      name: row.indexname,
      scans: row.idx_scan,
      tuplesRead: row.idx_tup_read,
      tuplesFetched: row.idx_tup_fetch,
      size: row.index_size,
      definition: row.indexdef,
    }));
  }

  // Suggest missing indexes based on query patterns
  private async suggestMissingIndexes(): Promise<MissingIndex[]> {
    const query = `
      SELECT 
        schemaname,
        tablename,
        attname,
        n_distinct,
        correlation
      FROM pg_stats 
      WHERE schemaname = 'public'
        AND n_distinct > 10
        AND correlation < 0.9
      ORDER BY n_distinct DESC;
    `;

    const result = await this.db.query(query);
    const suggestions: MissingIndex[] = [];

    // Group by table and suggest composite indexes
    const tableColumns = result.rows.reduce((acc, row) => {
      if (!acc[row.tablename]) acc[row.tablename] = [];
      acc[row.tablename].push(row);
      return acc;
    }, {} as Record<string, any[]>);

    for (const [table, columns] of Object.entries(tableColumns)) {
      if (columns.length >= 2) {
        // Suggest composite index for frequently queried columns
        suggestions.push({
          table,
          columns: columns.slice(0, 3).map(c => c.attname),
          type: 'btree',
          reason: 'Composite index for multi-column queries',
          estimatedBenefit: 'high',
        });
      }

      // Suggest partial indexes for selective queries
      for (const column of columns) {
        if (column.n_distinct > 1000) {
          suggestions.push({
            table,
            columns: [column.attname],
            type: 'btree',
            reason: 'High cardinality column benefits from indexing',
            estimatedBenefit: 'medium',
          });
        }
      }
    }

    return suggestions;
  }

  // Find unused indexes
  private async findUnusedIndexes(): Promise<UnusedIndex[]> {
    const query = `
      SELECT 
        schemaname,
        tablename,
        indexname,
        pg_size_pretty(pg_relation_size(indexrelid)) as index_size
      FROM pg_stat_user_indexes 
      WHERE idx_scan = 0 
        AND indexrelid NOT IN (
          SELECT indexrelid FROM pg_constraint WHERE contype IN ('p', 'u')
        );
    `;

    const result = await this.db.query(query);
    return result.rows.map(row => ({
      schema: row.schemaname,
      table: row.tablename,
      name: row.indexname,
      size: row.index_size,
      action: 'DROP INDEX',
    }));
  }

  // Create optimized indexes
  async createOptimizedIndexes(): Promise<void> {
    const analysis = await this.analyzeIndexes();

    // Create missing indexes
    for (const missingIndex of analysis.missingIndexes) {
      await this.createIndex(missingIndex);
    }

    // Report unused indexes for review
    if (analysis.unusedIndexes.length > 0) {
      console.log('Unused indexes found for review:', analysis.unusedIndexes);
    }
  }

  private async createIndex(index: MissingIndex): Promise<void> {
    const indexName = `idx_${index.table}_${index.columns.join('_')}`;
    const columnList = index.columns.join(', ');
    const query = `CREATE INDEX CONCURRENTLY ${indexName} ON ${index.table} (${columnList})`;
    
    await this.db.query(query);
    console.log(`Created index: ${indexName}`);
  }
}
```

### Connection Pool Management
```typescript
// services/connection-manager.ts
import { Pool, PoolConfig } from 'pg';

export class ConnectionManager {
  private pools: Map<string, Pool> = new Map();

  // Create optimized connection pool
  createPool(name: string, config: Partial<PoolConfig> = {}): Pool {
    const defaultConfig: PoolConfig = {
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      
      // Connection pool settings
      max: 20,                    // Maximum number of connections
      min: 5,                     // Minimum number of connections
      idleTimeoutMillis: 30000,   // Close idle connections after 30s
      connectionTimeoutMillis: 10000, // Connection timeout
      
      // Query timeout
      query_timeout: 30000,       // 30 seconds
      
      // SSL configuration
      ssl: process.env.NODE_ENV === 'production' ? {
        rejectUnauthorized: false,
      } : false,
      
      // Application name for monitoring
      application_name: `${name}-pool`,
      
      // Keep-alive settings
      keepAlive: true,
      keepAliveInitialDelayMillis: 10000,
    };

    const poolConfig = { ...defaultConfig, ...config };
    const pool = new Pool(poolConfig);
    
    this.pools.set(name, pool);
    
    // Setup event listeners
    pool.on('connect', (client) => {
      console.log(`New connection established for pool: ${name}`);
    });

    pool.on('error', (err, client) => {
      console.error(`Pool ${name} error:`, err);
    });

    return pool;
  }

  // Get connection pool
  getPool(name: string): Pool | undefined {
    return this.pools.get(name);
  }

  // Execute query with automatic retry
  async queryWithRetry<T>(
    poolName: string,
    query: string,
    params: any[] = [],
    maxRetries: number = 3
  ): Promise<T> {
    const pool = this.getPool(poolName);
    if (!pool) {
      throw new Error(`Pool ${poolName} not found`);
    }

    let lastError: Error;
    
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        const result = await pool.query(query, params);
        return result.rows;
      } catch (error) {
        lastError = error as Error;
        
        if (attempt === maxRetries) {
          throw lastError;
        }
        
        // Exponential backoff
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }

    throw lastError!;
  }

  // Monitor pool performance
  async getPoolStats(): Promise<PoolStats[]> {
    const stats: PoolStats[] = [];

    for (const [name, pool] of this.pools) {
      const idleCount = pool.idleCount;
      const totalCount = pool.totalCount;
      const waitingCount = pool.waitingCount;
      
      stats.push({
        name,
        totalConnections: totalCount,
        idleConnections: idleCount,
        activeConnections: totalCount - idleCount,
        waitingClients: waitingCount,
        utilization: ((totalCount - idleCount) / totalCount) * 100,
      });
    }

    return stats;
  }

  // Close all pools
  async closeAll(): Promise<void> {
    const closePromises = Array.from(this.pools.values()).map(pool => pool.end());
    await Promise.all(closePromises);
    this.pools.clear();
  }
}

// PgBouncer integration
export class PgBouncerManager {
  private config: {
    host: string;
    port: number;
    user: string;
    password: string;
    database: string;
  };

  constructor() {
    this.config = {
      host: process.env.PGBOUNCER_HOST || 'localhost',
      port: parseInt(process.env.PGBOUNCER_PORT || '6432'),
      user: process.env.PGBOUNCER_USER,
      password: process.env.PGBOUNCER_PASSWORD,
      database: process.env.PGBOUNCER_DATABASE,
    };
  }

  // Get PgBouncer statistics
  async getStats(): Promise<PgBouncerStats> {
    const pool = new Pool({
      ...this.config,
      max: 1,
    });

    const result = await pool.query('SHOW STATS;');
    await pool.end();

    const stats = result.rows;
    
    return {
      totalConnections: parseInt(stats.find(s => s.database === 'total')?.xact_count || '0'),
      totalQueries: parseInt(stats.find(s => s.database === 'total')?.query_count || '0'),
      averageQueryTime: parseFloat(stats.find(s => s.database === 'total')?.avg_query_time || '0'),
      poolUtilization: this.calculatePoolUtilization(stats),
    };
  }

  private calculatePoolUtilization(stats: any[]): number {
    // Calculate pool utilization based on active connections
    const totalStats = stats.find(s => s.database === 'total');
    if (!totalStats) return 0;

    const maxConnections = parseInt(process.env.MAX_CONNECTIONS || '100');
    const activeConnections = parseInt(totalStats.cl_active || '0');
    
    return (activeConnections / maxConnections) * 100;
  }
}
```

### Advanced Performance Monitoring
```typescript
// services/performance-monitor.ts
export class PerformanceMonitor {
  constructor(private db: Database) {}

  // Get comprehensive performance metrics
  async getPerformanceMetrics(): Promise<PerformanceMetrics> {
    const [
      systemMetrics,
      queryMetrics,
      indexMetrics,
      connectionMetrics,
      lockMetrics,
    ] = await Promise.all([
      this.getSystemMetrics(),
      this.getQueryMetrics(),
      this.getIndexMetrics(),
      this.getConnectionMetrics(),
      this.getLockMetrics(),
    ]);

    return {
      system: systemMetrics,
      queries: queryMetrics,
      indexes: indexMetrics,
      connections: connectionMetrics,
      locks: lockMetrics,
      timestamp: new Date(),
    };
  }

  // System-level performance metrics
  private async getSystemMetrics(): Promise<SystemMetrics> {
    const query = `
      SELECT 
        (SELECT count(*) FROM pg_stat_activity WHERE state = 'active') as active_connections,
        (SELECT count(*) FROM pg_stat_activity) as total_connections,
        (SELECT count(*) FROM pg_stat_activity WHERE wait_event IS NOT NULL) as waiting_connections,
        (SELECT sum(xact_commit) + sum(xact_rollback) FROM pg_stat_database) as total_transactions,
        (SELECT sum(tup_returned) + sum(tup_fetched) + sum(tup_inserted) + sum(tup_updated) + sum(tup_deleted) FROM pg_stat_database) as total_tuples,
        (SELECT sum(blks_read) + sum(blks_hit) FROM pg_stat_database) as total_blocks,
        (SELECT sum(blks_hit) / nullif(sum(blks_hit) + sum(blks_read), 0) * 100 FROM pg_stat_database) as cache_hit_rate
    `;

    const result = await this.db.query(query);
    const data = result.rows[0];

    return {
      activeConnections: parseInt(data.active_connections),
      totalConnections: parseInt(data.total_connections),
      waitingConnections: parseInt(data.waiting_connections),
      totalTransactions: parseInt(data.total_transactions),
      totalTuples: parseInt(data.total_tuples),
      totalBlocks: parseInt(data.total_blocks),
      cacheHitRate: parseFloat(data.cache_hit_rate),
    };
  }

  // Query performance metrics
  private async getQueryMetrics(): Promise<QueryMetrics> {
    const query = `
      SELECT 
        count(*) as total_queries,
        sum(mean_time) as total_mean_time,
        avg(mean_time) as avg_mean_time,
        max(mean_time) as max_mean_time,
        sum(calls) as total_calls,
        avg(total_time/calls) as avg_execution_time,
        sum(shared_blks_hit) / nullif(sum(shared_blks_hit) + sum(shared_blks_read), 0) * 100 as avg_hit_rate
      FROM pg_stat_statements
    `;

    const result = await this.db.query(query);
    const data = result.rows[0];

    return {
      totalQueries: parseInt(data.total_queries),
      totalMeanTime: parseFloat(data.total_mean_time),
      avgMeanTime: parseFloat(data.avg_mean_time),
      maxMeanTime: parseFloat(data.max_mean_time),
      totalCalls: parseInt(data.total_calls),
      avgExecutionTime: parseFloat(data.avg_execution_time),
      avgHitRate: parseFloat(data.avg_hit_rate),
    };
  }

  // Index performance metrics
  private async getIndexMetrics(): Promise<IndexMetrics> {
    const query = `
      SELECT 
        count(*) as total_indexes,
        sum(idx_scan) as total_index_scans,
        avg(idx_scan) as avg_index_scans,
        count(*) FILTER (WHERE idx_scan = 0) as unused_indexes,
        sum(pg_relation_size(indexrelid)) as total_index_size
      FROM pg_stat_user_indexes
    `;

    const result = await this.db.query(query);
    const data = result.rows[0];

    return {
      totalIndexes: parseInt(data.total_indexes),
      totalIndexScans: parseInt(data.total_index_scans),
      avgIndexScans: parseFloat(data.avg_index_scans),
      unusedIndexes: parseInt(data.unused_indexes),
      totalIndexSize: parseInt(data.total_index_size),
    };
  }

  // Connection metrics
  private async getConnectionMetrics(): Promise<ConnectionMetrics> {
    const query = `
      SELECT 
        count(*) FILTER (WHERE state = 'active') as active,
        count(*) FILTER (WHERE state = 'idle') as idle,
        count(*) FILTER (WHERE state = 'idle in transaction') as idle_in_transaction,
        count(*) FILTER (WHERE wait_event IS NOT NULL) as waiting,
        count(*) as total
      FROM pg_stat_activity
    `;

    const result = await this.db.query(query);
    const data = result.rows[0];

    return {
      active: parseInt(data.active),
      idle: parseInt(data.idle),
      idleInTransaction: parseInt(data.idle_in_transaction),
      waiting: parseInt(data.waiting),
      total: parseInt(data.total),
    };
  }

  // Lock metrics
  private async getLockMetrics(): Promise<LockMetrics> {
    const query = `
      SELECT 
        count(*) FILTER (WHERE granted = false) as waiting_locks,
        count(*) FILTER (WHERE granted = true) as granted_locks,
        count(*) as total_locks,
        mode,
        count(*) as lock_count
      FROM pg_locks
      GROUP BY mode
      ORDER BY lock_count DESC
    `;

    const result = await this.db.query(query);

    return {
      waitingLocks: result.rows.reduce((sum, row) => sum + (row.mode.includes('AccessShare') ? 0 : parseInt(row.waiting_locks || '0')), 0),
      grantedLocks: result.rows.reduce((sum, row) => sum + parseInt(row.granted_locks || '0'), 0),
      totalLocks: result.rows.reduce((sum, row) => sum + parseInt(row.total_locks || '0'), 0),
      lockTypes: result.rows.map(row => ({
        mode: row.mode,
        count: parseInt(row.lock_count),
      })),
    };
  }

  // Performance alerts
  async checkPerformanceAlerts(): Promise<PerformanceAlert[]> {
    const metrics = await this.getPerformanceMetrics();
    const alerts: PerformanceAlert[] = [];

    // Check connection usage
    if (metrics.connections.active > metrics.connections.total * 0.8) {
      alerts.push({
        type: 'high_connection_usage',
        severity: 'warning',
        message: 'High connection usage detected',
        value: metrics.connections.active,
        threshold: metrics.connections.total * 0.8,
      });
    }

    // Check cache hit rate
    if (metrics.system.cacheHitRate < 90) {
      alerts.push({
        type: 'low_cache_hit_rate',
        severity: 'warning',
        message: 'Low cache hit rate detected',
        value: metrics.system.cacheHitRate,
        threshold: 90,
      });
    }

    // Check for unused indexes
    if (metrics.indexes.unusedIndexes > 0) {
      alerts.push({
        type: 'unused_indexes',
        severity: 'info',
        message: 'Unused indexes detected',
        value: metrics.indexes.unusedIndexes,
        threshold: 0,
      });
    }

    // Check for waiting locks
    if (metrics.locks.waitingLocks > 0) {
      alerts.push({
        type: 'waiting_locks',
        severity: 'warning',
        message: 'Waiting locks detected',
        value: metrics.locks.waitingLocks,
        threshold: 0,
      });
    }

    return alerts;
  }
}
```

## Testing Strategies

### Performance Testing
```typescript
// tests/performance.test.ts
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { QueryOptimizer } from '../services/query-optimizer';
import { PerformanceMonitor } from '../services/performance-monitor';

describe('Database Performance', () => {
  let optimizer: QueryOptimizer;
  let monitor: PerformanceMonitor;

  beforeAll(() => {
    optimizer = new QueryOptimizer(db);
    monitor = new PerformanceMonitor(db);
  });

  it('should analyze query performance', async () => {
    const query = 'SELECT * FROM users WHERE email = $1';
    const analysis = await optimizer.analyzeQuery(query, ['test@example.com']);

    expect(analysis.executionTime).toBeDefined();
    expect(analysis.totalCost).toBeDefined();
    expect(analysis.plan).toBeDefined();
  });

  it('should provide optimization suggestions', async () => {
    const slowQuery = `
      SELECT u.*, p.* 
      FROM users u 
      JOIN posts p ON u.id = p.author_id 
      WHERE u.created_at > '2023-01-01'
    `;
    
    const analysis = await optimizer.analyzeQuery(slowQuery);
    const optimizations = await optimizer.generateOptimizations(analysis);

    expect(optimizations.length).toBeGreaterThan(0);
    expect(optimizations[0].type).toBeDefined();
    expect(optimizations[0].description).toBeDefined();
  });

  it('should monitor performance metrics', async () => {
    const metrics = await monitor.getPerformanceMetrics();

    expect(metrics.system.activeConnections).toBeGreaterThanOrEqual(0);
    expect(metrics.system.cacheHitRate).toBeGreaterThanOrEqual(0);
    expect(metrics.queries.avgMeanTime).toBeGreaterThanOrEqual(0);
  });

  it('should detect performance issues', async () => {
    const alerts = await monitor.checkPerformanceAlerts();

    expect(Array.isArray(alerts)).toBe(true);
    alerts.forEach(alert => {
      expect(alert.type).toBeDefined();
      expect(alert.severity).toBeDefined();
      expect(alert.message).toBeDefined();
    });
  });
});
```

## Best Practices

### Query Optimization
- Use EXPLAIN ANALYZE for query performance analysis
- Optimize WHERE clauses and JOIN conditions
- Use appropriate data types for columns
- Consider materialized views for complex queries
- Implement proper indexing strategies

### Connection Management
- Use connection pooling effectively
- Set appropriate connection limits
- Monitor connection usage patterns
- Implement connection retry logic
- Use PgBouncer for high-traffic applications

### Performance Monitoring
- Monitor key performance metrics continuously
- Set up alerts for performance degradation
- Regular performance audits and reviews
- Use pg_stat_statements for query analysis
- Monitor system resource utilization

### Scaling Strategies
- Implement read replicas for read-heavy workloads
- Use partitioning for large tables
- Consider sharding for very large datasets
- Optimize for your specific workload patterns
- Plan for capacity growth


---

## Tool Usage Guidelines

### Execute Tool
**Purpose**: Full execution rights for validation, testing, building, and git operations

#### Allowed Commands
**All assessment commands plus**:
- `npm run build`, `npm run dev` - Build and development
- `npm install`, `pnpm install` - Dependency management
- `git add`, `git commit`, `git checkout` - Git operations
- Build tools, compilers, and package managers

#### Caution Commands (Ask User First)
- `git push` - Push to remote repository
- `npm publish` - Publish to package registry
- `docker push` - Push to container registry

---

### Edit & MultiEdit Tools
**Purpose**: Modify source code to implement fixes and features

**Best Practices**:
1. **Read before editing** - Always read files first to understand context
2. **Preserve formatting** - Match existing code style
3. **Atomic changes** - Each edit should be a complete, working change
4. **Test after editing** - Run tests to verify changes work

---

### Create Tool
**Purpose**: Generate new files including source code

#### Allowed Paths (Full Access)
- `/src/**` - All source code directories
- `/tests/**` - Test files
- `/docs/**` - Documentation

#### Prohibited Paths
- `.env` - Actual secrets (only `.env.example`)
- `.git/**` - Git internals (use git commands)

**Security**: Action droids have full modification rights to implement fixes and features.

---
## Task File Integration

### Input Format
**Reads**: `/tasks/tasks-[prd-id]-[domain].md` from assessment droid

### Output Format
**Updates**: Same file with status markers

**Status Markers**:
- `[ ]` - Pending
- `[~]` - In Progress
- `[x]` - Completed
- `[!]` - Blocked

**Example Update**:
```markdown
- [x] 1.1 Fix authentication bug
  - **Status**: ✅ Completed
  - **Completed**: 2025-01-12 11:45
  - **Changes**: Added input validation, error handling
  - **Tests**: ✅ All tests passing (12/12)
```

---

## Integration with Other Droids

### Works Best With:
- **Drizzle ORM Specialist**: Query optimization and schema design
- **Valkey Caching Droid**: Database query result caching
- **Performance Droid**: Overall application performance
- **Security Droid**: Database security optimization

### Performance Flow:
1. **Application Request**: Database query from application
2. **Connection Pool**: Efficient connection management
3. **Query Optimization**: Optimal query execution
4. **Caching Layer**: Query result caching with Valkey
5. **Monitoring**: Performance tracking and alerting

---

**Version**: 2.0.0 (Optimized for AI token efficiency)
**Specialization**: PostgreSQL 18 performance optimization and advanced tuning
