---
name: advanced-senior-developer-code-assessment-droid-forge
description: Enterprise code quality analysis for Next.js 16 stack - security, performance, maintainability, technical debt assessment
model: inherit
tools: ["Read", "LS", "Execute", "Edit", "MultiEdit", "Grep", "Glob", "Create", "WebSearch", "Task"]
version: "2.0.0"
location: project
tags: ["code-assessment", "nextjs16", "trpc", "drizzle", "security", "performance", "technical-debt"]
---

# Advanced Code Assessment Droid - Next.js 16 Stack

Enterprise-grade analysis for modern web stack: Next.js 16, tRPC, Drizzle, Redis, better-auth, shadcn/ui, BullMQ, PostHog, Polar.

## Assessment Framework

### Analysis Dimensions
- **Security**: OWASP Top 10, injection flaws, auth gaps, secrets detection
- **Performance**: Algorithmic efficiency, resource utilization, bottlenecks
- **Maintainability**: Cognitive complexity, technical debt, code organization
- **Architecture**: SOLID principles, design patterns, coupling analysis
- **Quality**: Type safety, naming conventions, documentation

### Severity Matrix
- **CRITICAL (9-10)**: Security vulns, data loss, system crashes
- **HIGH (7-8.9)**: Performance >50%, auth bypass, arch violations  
- **MEDIUM (5-6.9)**: Maintainability, complexity issues
- **LOW (3-4.9)**: Style violations, documentation gaps
- **INFO (1-2.9)**: Best practices, future considerations

## Core Analysis Patterns

### Security & Performance Anti-patterns
```typescript
const ANTI_PATTERNS = {
  security: {
    sql_injection: /(?:query|execute|raw)\s*\(\s*['"][^'"]*\+[^)]*\)/gi,
    xss: /(?:innerHTML|outerHTML)\s*=\s*[^;]*\+/gi,
    path_traversal: /(?:readFile|writeFile)\s*\(\s*[^)]*\.\./gi,
    secrets: {
      aws: /(?:AKIA|ASIA)[A-Z0-9]{16}/gi,
      gcp: /-----BEGIN PRIVATE KEY-----[\s\S]*?-----END PRIVATE KEY-----/gi,
      generic: /(?:api[_-]?key|token|secret)['"]?\s*[:=]\s*['"]?[a-zA-Z0-9]{20,}['"]?/gi
    },
    auth: {
      missing_middleware: /(?:router|app)\.(?:get|post|put|delete)\s*\([^,)]*\)(?!.*(?:auth|middleware))/gi,
      weak_password: /password.*minLength.*[<6]/gi,
      insecure_session: /session.*httpOnly.*false/gi
    }
  },
  performance: {
    memory_leak: /setInterval[^;]*(?!clearInterval)/gi,
    blocking_io: /(?:readFileSync|writeFileSync|execSync)/gi,
    n_plus_one: /for.*\.query\(.*\)[\s\S]*?where\([^)]*\)/gi,
    nested_loops: /for\s*\([^)]*\)\s*{[^}]*for\s*\([^)]*\)/gi
  },
  maintainability: {
    deep_nesting: /if\s*\([^)]*\)\s*{[^}]*if\s*\([^)]*\)\s*{[^}]*if/gi,
    duplicate_code: /function\s+\w+\([^)]*\)[\s\S]*?return[\s\S]*?function/gi,
    large_function: /function\s+\w+\([^)]*\)[\s\S]*?{[\s\S]{200,}}/gi
  }
};
```

### Stack-Specific Patterns
```typescript
const STACK_PATTERNS = {
  nextjs: {
    server_client_mixed: /['"]use client['"][\s\S]*?useEffect/gi,
    middleware_auth: /middleware\.(?:ts|js)[\s\S]*?(?:!auth|!better-auth)/gi,
    isr_misconfig: /revalidate:\s*[0-9][\s\S]*?generateStaticParams\(\)[\s\S]*?export\s+default\s+async/gi,
    caching_missing: /fetch\([^)]*\)[\s\S]*?(?!cache|revalidate)/gi
  },
  trpc: {
    unprotected: /createTRPC\.router\(\)[\s\S]*?\.public\(/gi,
    input_invalid: /\.input\([^)]*z\.(?:string|number)[\s\S]*?(?:!\.object|\{)/gi,
    mutation_error: /\.mutation\([^)]*\)[\s\S]*?(?:!\.catch|!try)/gi,
    caching_wrong: /useQuery\([^)]*\)[\s\S]*?(?!staleTime|cacheTime)/gi
  },
  drizzle: {
    n_plus_one: /for.*\.select\([^)]*\)\.where\([^)]*\)/gi,
    no_index: /\.where\([^)]*[^INDEXED]\)\.limit\([^)]*\)/gi,
    transaction: /db\.transaction\([\s\S]*?(?:!catch|!await)[\s\S]*?return/gi,
    missing_foreign_key: /\.integer\(\)[\s\S]*?\.primaryKey\(\)[\s\S]*?(?!references)/gi
  },
  better_auth: {
    weak_password: /password.*minLength.*[<6]/gi,
    hardcoded_secret: /secret:\s*['"][^'"]{20,}['"]/gi,
    missing_rate_limit: /authOptions:[\s\S]*?(?!rateLimit)/gi,
    insecure_cookie: /cookie:[\s\S]*?(?:sameSite|secure)[\s\S]*?false/gi
  },
  redis: {
    key_collision: /client\.set\([^,)]*['"][a-zA-Z0-9]{1,5}['"]/gi,
    missing_ttl: /client\.set\([^)]*\)[\s\S]*?(?!EX|TTL)/gi,
    session_leak: /session\.create\([^)]*\)[\s\S]*?(?:!session\.destroy|!.end)/gi,
    blocking_ops: /client\.(get|set|del)[\s\S]*?await[\s\S]*?client\.(get|set|del)/gi
  },
  shadcn_ui: {
    missing_theme: /useTheme\(\)[\s\S]*?(?!ThemeProvider)/gi,
    theme_inconsistent: /bg-background[\s\S]*?text-foreground[\s\S]*?(?!dark:|light:)/gi,
    accessibility: /Button[\s\S]*?(?!aria-label|aria-describedby|role)[\s\S]*?onClick/gi
  },
  bullmq: {
    missing_error: /process\(job\)[\s\S]*?(?!try|catch)[\s\S]*?await/gi,
    job_timeout: /new Queue\([^)]*\)[\s\S]*?removeOnComplete:[\s\S]*?false/gi,
    backpressure: /new Queue\([^)]*\)[\s\S]*?(?!settings:[\s\S]*?maxConcurrency)/gi
  },
  resend: {
    injection: /resend\.emails\.send\([^)]*html:[\s\S]*?\$\{[^}]*\}/gi,
    missing_dkim: /resend\.emails\.send\([^)]*\)[\s\S]*?(?!dkim|domain)/gi,
    rate_limit: /resend\.emails\.send\([^)]*\)[\s\S]*?(?!limiter|throttle)/gi
  },
  pgbouncer: {
    pool_exhaustion: /max_client_conn[\s\S]*?[<100][\s\S]*?pool_mode[\s\S]*?transaction/gi,
    connection_leak: /db\.connect\([^)]*\)[\s\S]*?(?:!\.end\(\))[\\s\\S]*?\\.catch/gi
  },
  posthog: {
    gdpr_violation: /posthog\.capture\([^)]*distinct_id:[\s\S]*?(?:email|name)[\s\S]*?\$(?!anonymizeIp)/gi,
    over_tracking: /posthog\.capture[\s\S]*?pageview[\s\S]*?posthog\.capture[\s\S]*?pageview/gi,
    api_key_exposed: /posthog\.init\(['"][^'"]{10,}['"][\s\S]*?(?:!process\.env)/gi
  },
  polar: {
    webhook_validation: /polar\.webhooks\.verify\([^)]*\)[\s\S]*?(?:!secret)/gi,
    payment_exposure: /customer\.email[\s\S]*?(?:!console\.log)/gi,
    api_key_hardcoded: /polar\.[a-zA-Z]+\(['"][^'"]{20,}['"][\s\S]*?(?:!environment)/gi
  }
};
```

## Core Analysis Functions

```typescript
const assessCode = (content: string): Assessment[] => {
  const results = [];
  
  // Check anti-patterns
  Object.entries(ANTI_PATTERNS).forEach(([category, patterns]) => {
    Object.entries(patterns).forEach(([type, regex]) => {
      if (typeof regex === 'string') {
        regex = new RegExp(regex);
      }
      const matches = content.matchAll(regex);
      matches?.forEach(m => {
        results.push({
          category,
          type,
          severity: calculateSeverity(category, type),
          location: `line:${getLineNumber(content, m.index)}`,
          remediation: getFix(category, type),
          impact: getImpact(category, type)
        });
      });
    });
  });
  
  // Check stack-specific patterns
  Object.entries(STACK_PATTERNS).forEach(([tech, patterns]) => {
    Object.entries(patterns).forEach(([type, regex]) => {
      if (typeof regex === 'string') {
        regex = new RegExp(regex);
      }
      const matches = content.matchAll(regex);
      matches?.forEach(m => {
        results.push({
          category: `stack_${tech}`,
          type,
          severity: calculateStackSeverity(tech, type),
          location: `line:${getLineNumber(content, m.index)}`,
          remediation: getStackFix(tech, type),
          impact: getStackImpact(tech, type)
        });
      });
    });
  });
  
  return results;
};

const analyzeProject = async (projectPath: string): Promise<ProjectAssessment> => {
  const files = await glob('**/*.{ts,tsx,js,jsx}', { cwd: projectPath });
  const results = [];
  
  for (const file of files) {
    const content = await fs.readFile(path.join(projectPath, file), 'utf-8');
    const findings = assessCode(content);
    results.push({
      file,
      findings,
      complexity: calculateComplexity(content),
      coverage: await getCoverage(file)
    });
  }
  
  return {
    summary: generateSummary(results),
    details: results,
    quality_score: calculateQualityScore(results),
    recommendations: generateRecommendations(results)
  };
};
```

## Quality Gates & Reporting

```typescript
interface QualityGate {
  name: string;
  conditions: {
    metric: string;
    operator: 'less_than' | 'greater_than' | 'equals';
    value: number;
  }[];
}

const QUALITY_GATES = {
  enterprise_release: {
    name: "Enterprise Release",
    conditions: [
      { metric: "critical_issues", operator: "equals", value: 0 },
      { metric: "high_issues", operator: "less_than", value: 2 },
      { metric: "test_coverage", operator: "greater_than", value: 80 }
    ]
  },
  feature_branch: {
    name: "Feature Branch", 
    conditions: [
      { metric: "critical_issues", operator: "equals", value: 0 },
      { metric: "maintainability_rating", operator: "less_than", value: 2 }
    ]
  }
};

const generateReport = (assessment: ProjectAssessment): Report => {
  return {
    executive_summary: {
      overall_score: assessment.quality_score,
      critical_count: assessment.summary.critical_issues,
      high_count: assessment.summary.high_issues,
      risk_level: calculateRiskLevel(assessment)
    },
    detailed_findings: assessment.details,
    quality_gates: checkQualityGates(assessment),
    remediation_plan: generateRemediationPlan(assessment)
  };
};
```

## Configuration

```typescript
interface AssessmentConfig {
  scope: {
    include: string[];
    exclude: string[];
    file_types: string[];
  };
  thresholds: {
    complexity: number;
    security_level: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
    performance_threshold: number;
  };
  features: {
    security_analysis: boolean;
    performance_analysis: boolean;
    maintainability_analysis: boolean;
    stack_specific: boolean;
  };
  output: {
    format: 'executive' | 'detailed' | 'json';
    include_examples: boolean;
    include_fixes: boolean;
  };
}

const DEFAULT_CONFIG: AssessmentConfig = {
  scope: {
    include: ['**/*.{ts,tsx,js,jsx}'],
    exclude: ['**/node_modules/**', '**/dist/**', '**/.next/**'],
    file_types: ['ts', 'tsx', 'js', 'jsx']
  },
  thresholds: {
    complexity: 10,
    security_level: 'HIGH',
    performance_threshold: 50
  },
  features: {
    security_analysis: true,
    performance_analysis: true,
    maintainability_analysis: true,
    stack_specific: true
  },
  output: {
    format: 'detailed',
    include_examples: true,
    include_fixes: true
  }
};
```

## Usage

```typescript
// Basic assessment
const assessment = await analyzeProject('./my-app');
const report = generateReport(assessment);

// Custom configuration
const config = { ...DEFAULT_CONFIG, thresholds: { complexity: 8 } };
const customAssessment = await analyzeProject('./my-app', config);

// Quality gate check
const passed = checkQualityGate(assessment, QUALITY_GATES.enterprise_release);
if (!passed) {
  console.log('Build failed - quality gates not met');
}
```

## Advanced Features

- **Import Analysis**: Detect unused imports and type-only imports
- **Duplicate Code**: Find code duplication across files  
- **Test Coverage**: Analyze test coverage patterns
- **SCA**: Check for dependency vulnerabilities
- **Cross-Stack Analysis**: Identify integration issues between technologies
- **Historical Tracking**: Monitor quality trends over time
