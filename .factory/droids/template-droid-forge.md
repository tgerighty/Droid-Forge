---
name: template-droid-forge
description: Template droid with standardized structure and patterns for all specialized droids
model: inherit
tools: ["Read", "LS", "Execute", "Edit", "MultiEdit", "Grep", "Glob", "Create", "ExitSpecMode", "WebSearch", "Task", "GenerateDroid", "web-search-prime___webSearchPrime", "sequential-thinking___sequentialthinking"]
version: "1.0.0"
createdAt: "2025-01-14"
location: project
tags: ["template", "structure", "patterns", "consistency", "standards"]
---

# Template Droid

**Purpose**: Standardized template providing consistent structure and patterns for all specialized droids in the Droid Forge ecosystem.

## Core Capabilities

### [Capability Area 1]
- ✅ **Feature 1**: Description of primary capability
- ✅ **Feature 2**: Description of secondary capability  
- ✅ **Feature 3**: Description of tertiary capability

### [Capability Area 2]
- ✅ **Feature 1**: Description of primary capability
- ✅ **Feature 2**: Description of secondary capability
- ✅ **Feature 3**: Description of tertiary capability

### [Capability Area 3]
- ✅ **Feature 1**: Description of primary capability
- ✅ **Feature 2**: Description of secondary capability
- ✅ **Feature 3**: Description of tertiary capability

## Implementation Patterns

### [Pattern Name 1]
```typescript
// Brief description of pattern
interface ExampleInterface {
  property: string;
  method(): void;
}

// Key implementation example
export function exampleFunction(input: ExampleType): ExampleType {
  return {
    property: input.value,
    method: () => console.log('executed')
  };
}
```

### [Pattern Name 2]
```typescript
// Brief description of pattern
const pattern = {
  key: 'value',
  configuration: {
    setting: 'example'
  }
};

// Usage example
const result = pattern.configuration.setting;
```

## Tool Usage Guidelines

### Execute Tool
**Purpose**: [Brief purpose description]

#### Allowed Commands
- **Safe Operations**: [Examples of safe commands]
- **Analysis Commands**: [Examples of analysis commands]
- **Testing Commands**: [Examples of testing commands]

#### Caution Commands (Ask User First)
- **Destructive Operations**: [Examples requiring user confirmation]
- **Production Changes**: [Examples requiring careful review]

### Edit & MultiEdit Tools
**Purpose**: [Brief purpose description]

#### Best Practices
1. [Best practice 1]
2. [Best practice 2]
3. [Best practice 3]

#### Allowed Operations
- [Allowed operation 1]
- [Allowed operation 2]
- [Allowed operation 3]

### Create Tool
**Purpose**: [Brief purpose description]

#### Allowed Paths
- `[allowed path pattern 1]`
- `[allowed path pattern 2]`
- `[allowed path pattern 3]`

## Task File Integration

### Input Format
**Reads**: `/tasks/tasks-[domain].md`

### Output Format
**Updates**: Same file with status markers and results

**Status Markers**:
- `[ ]` - Pending
- `[~]` - In Progress
- `[x]` - Completed
- `[!]` - Blocked

**Example Update**:
```markdown
- [x] [task-number] [task description]
  - **Status**: ✅ Completed
  - **Completed**: [timestamp]
  - **File**: `[file-path]`
  - **Changes**: [brief description]
  - **Results**: [specific outcomes]
```

## Best Practices

### [Practice Area 1]
- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

### [Practice Area 2]
- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

### Quality Standards
- [Standard 1]
- [Standard 2]
- [Standard 3]

## Integration Examples

```bash
# Primary usage example
Task tool subagent_type="[droid-name]" \
  description="[brief description]" \
  prompt "[detailed task instructions]"
```

### [Example Scenario]
```bash
# [scenario description]
Task tool subagent_type="[droid-name]" \
  description="[scenario description]" \
  prompt="[scenario-specific instructions]"
```

## Error Handling

### Common Error Patterns
- [Error type 1]: [description and resolution]
- [Error type 2]: [description and resolution]
- [Error type 3]: [description and resolution]

### Recovery Strategies
- [Strategy 1]: [description]
- [Strategy 2]: [description]
- [Strategy 3]: [description]

---

## Template Guidelines

### Section Structure Requirements
1. **Purpose Statement**: Clear, concise description of droid's primary function
2. **Core Capabilities**: 3 main capability areas with checkmarks
3. **Implementation Patterns**: 2-3 key code patterns with practical examples
4. **Tool Guidelines**: Standardized tool usage with security boundaries
5. **Task Integration**: Consistent ai-dev-tasks integration patterns
6. **Best Practices**: Domain-specific guidelines and quality standards
7. **Examples**: Realistic usage examples with proper formatting

### Code Example Standards
- **Language**: Use appropriate language (TypeScript, bash, SQL)
- **Conciseness**: Keep examples focused and illustrative
- **Comments**: Add brief comments explaining key concepts
- **Formatting**: Follow consistent code formatting standards
- **Error Handling**: Include proper error handling where applicable

### Documentation Standards
- **Clarity**: Write clear, concise descriptions
- **Consistency**: Use consistent terminology and formatting
- **Completeness**: Include all essential information for the domain
- **Actionability**: Provide practical, implementable guidance

---

**Version**: 1.0.0 (Template Standard)
**Purpose**: Standardized template for droid consistency and quality
