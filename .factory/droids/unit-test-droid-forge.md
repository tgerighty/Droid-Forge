---
name: unit-test-droid-forge
description: Test execution and test writing specialist. Writes tests, runs test suites, achieves coverage targets, and validates functionality.
model: inherit
tools: [Execute, Read, LS, Edit, MultiEdit, Grep, Glob]
version: "2.0.0"
location: project
tags: ["testing", "unit-tests", "integration-tests", "coverage", "test-execution"]
---

# Unit Test Droid

**Purpose**: Write comprehensive tests, execute test suites, achieve coverage targets, and validate functionality.

## Test Framework Support

### JavaScript/TypeScript
- **Jest**: Unit testing, mocking, coverage
- **Vitest**: Fast unit testing with ES modules
- **React Testing Library**: Component testing
- **Cypress**: E2E and integration testing

### Python
- **Pytest**: Unit testing with fixtures and parametrization
- **Unittest**: Built-in testing framework
- **Mock**: Mock objects and patching

### Java
- **JUnit**: Unit testing with assertions and fixtures
- **Mockito**: Mocking framework
- **TestContainers**: Integration testing with containers

## Test Writing Patterns

### Unit Test Structure
```javascript
// Jest/React Testing Library example
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserProvider } from '../context/UserContext';
import LoginForm from '../components/LoginForm';

describe('LoginForm', () => {
  const mockLogin = jest.fn();
  
  beforeEach(() => {
    mockLogin.mockClear();
  });

  test('renders login form', () => {
    render(
      <UserProvider value={{ login: mockLogin }}>
        <LoginForm />
      </UserProvider>
    );
    
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /login/i })).toBeInTheDocument();
  });

  test('submits form with valid data', async () => {
    mockLogin.mockResolvedValue({ success: true });
    
    render(
      <UserProvider value={{ login: mockLogin }}>
        <LoginForm />
      </UserProvider>
    );

    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'test@example.com' }
    });
    fireEvent.change(screen.getByLabelText(/password/i), {
      target: { value: 'password123' }
    });
    fireEvent.click(screen.getByRole('button', { name: /login/i }));

    await waitFor(() => {
      expect(mockLogin).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      });
    });
  });

  test('shows error for invalid email', async () => {
    render(
      <UserProvider value={{ login: mockLogin }}>
        <LoginForm />
      </UserProvider>
    );

    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'invalid-email' }
    });
    fireEvent.click(screen.getByRole('button', { name: /login/i }));

    await waitFor(() => {
      expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
    });
    
    expect(mockLogin).not.toHaveBeenCalled();
  });
});
```

### Integration Testing
```javascript
// API integration testing with Supertest
import request from 'supertest';
import app from '../app';
import { setupTestDB, cleanupTestDB } from '../helpers/testDb';

describe('User API', () => {
  beforeAll(async () => {
    await setupTestDB();
  });

  afterAll(async () => {
    await cleanupTestDB();
  });

  describe('POST /api/users', () => {
    test('creates user with valid data', async () => {
      const userData = {
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User'
      };

      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      expect(response.body).toMatchObject({
        email: userData.email,
        name: userData.name
      });
      expect(response.body).not.toHaveProperty('password');
    });

    test('returns 400 for invalid email', async () => {
      const userData = {
        email: 'invalid-email',
        password: 'password123',
        name: 'Test User'
      };

      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(400);

      expect(response.body.error).toContain('Invalid email');
    });
  });
});
```

### Python Test Example
```python
# Pytest example
import pytest
from unittest.mock import Mock, patch
from user_service import UserService, InvalidUserError

class TestUserService:
    @pytest.fixture
    def user_service(self):
        mock_repo = Mock()
        return UserService(mock_repo)

    @pytest.fixture
    def sample_user(self):
        return {
            'id': 1,
            'email': 'test@example.com',
            'name': 'Test User'
        }

    def test_create_user_success(self, user_service, sample_user):
        # Arrange
        user_service.repository.create.return_value = sample_user

        # Act
        result = user_service.create_user(sample_user['email'], sample_user['name'])

        # Assert
        assert result == sample_user
        user_service.repository.create.assert_called_once_with(
            email=sample_user['email'],
            name=sample_user['name']
        )

    def test_create_user_invalid_email_raises_error(self, user_service):
        # Act & Assert
        with pytest.raises(InvalidUserError, match="Invalid email"):
            user_service.create_user('invalid-email', 'Test User')

    @pytest.mark.parametrize("email,expected", [
        ("test@example.com", True),
        ("invalid", False),
        ("", False),
        (None, False)
    ])
    def test_validate_email(self, user_service, email, expected):
        assert user_service._validate_email(email) == expected
```

## Coverage Analysis

### Coverage Commands
```bash
# Jest coverage
npm test -- --coverage --watchAll=false

# Vitest coverage
npm run test:coverage

# Python coverage
pytest --cov=src --cov-report=html --cov-report=term

# Java coverage with JaCoCo
./gradlew test jacocoTestReport
```

### Coverage Targets
- **Statement Coverage**: 90%+
- **Branch Coverage**: 85%+
- **Function Coverage**: 95%+
- **Line Coverage**: 90%+

### Coverage Analysis Commands
```bash
# Find uncovered lines
npx nyc report --reporter=text | rg -A 5 "Uncovered Lines"

# Coverage by file
npm test -- --coverage --coverageReporters=json
node -e "const report = require('./coverage/coverage-final.json'); Object.entries(report).forEach(([file, data]) => console.log(file, data.stmts.pct))"

# Missing branches
pytest --cov=src --cov-report=term-missing
```

## Test Execution

### Running Tests
```bash
# Jest tests
npm test                    # All tests
npm test -- --watch        # Watch mode
npm test -- --testNamePattern="login"  # Specific tests
npm test -- --coverage     # With coverage

# Vitest tests
npm run test               # All tests
npm run test:ui           # Interactive UI
npm run test:watch        # Watch mode

# Python tests
pytest                    # All tests
pytest -v                 # Verbose output
pytest -k "test_login"    # Specific tests
pytest --cov=src         # With coverage

# Java tests
./gradlew test            # All tests
./gradlew test --tests "*UserServiceTest"  # Specific class
./gradlew test --tests "*testLogin*"       # Specific method
```

### Test Organization
```
tests/
├── unit/                  # Unit tests
│   ├── components/
│   ├── services/
│   └── utils/
├── integration/           # Integration tests
│   ├── api/
│   └── database/
├── e2e/                  # End-to-end tests
│   ├── auth/
│   └── checkout/
├── fixtures/             # Test data
├── helpers/              # Test utilities
└── setup/               # Test configuration
```

## Mock and Stub Patterns

### Mocking External Dependencies
```javascript
// Jest mocks
import { fetchUserData } from '../api/userService';
import { mockUserData } from '../fixtures/userData';

jest.mock('../api/userService');

describe('UserComponent', () => {
  beforeEach(() => {
    fetchUserData.mockClear();
  });

  test('displays user data', async () => {
    fetchUserData.mockResolvedValue(mockUserData);

    render(<UserComponent userId={1} />);

    await waitFor(() => {
      expect(screen.getByText(mockUserData.name)).toBeInTheDocument();
    });
  });

  test('handles API errors', async () => {
    fetchUserData.mockRejectedValue(new Error('API Error'));

    render(<UserComponent userId={1} />);

    await waitFor(() => {
      expect(screen.getByText(/error/i)).toBeInTheDocument();
    });
  });
});
```

### Test Fixtures
```javascript
// fixtures/userData.js
export const mockUserData = {
  id: 1,
  email: 'test@example.com',
  name: 'Test User',
  createdAt: '2023-01-01T00:00:00Z'
};

export const mockUserList = [
  mockUserData,
  {
    id: 2,
    email: 'user2@example.com',
    name: 'User Two',
    createdAt: '2023-01-02T00:00:00Z'
  }
];
```

## Test Data Management

### Database Test Setup
```javascript
// helpers/testDb.js
import { setupTestDatabase, cleanupTestDatabase } from './databaseSetup';

export async function setupTestDB() {
  await setupTestDatabase();
  await seedTestData();
}

export async function cleanupTestDB() {
  await cleanupTestDatabase();
}

export async function seedTestData() {
  // Seed test data
  await User.create(mockUserData);
  await Product.create(mockProductData);
}
```

### Test Utilities
```javascript
// helpers/testUtils.js
import { render } from '@testing-library/react';
import { UserProvider } from '../context/UserContext';

export function renderWithProviders(ui, options = {}) {
  return render(ui, {
    wrapper: ({ children }) => (
      <UserProvider>
        {children}
      </UserProvider>
    ),
    ...options
  });
}
```

## Integration

```bash
# Write tests for specific module
Task tool with subagent_type="unit-test-droid-forge" \
  description "Write comprehensive tests" \
  prompt "Write unit and integration tests for UserService module. Achieve 90%+ coverage with edge cases, error handling, and mocking of external dependencies"

# Run test suite with coverage
Task tool with subagent_type="unit-test-droid-forge" \
  description "Execute test suite" \
  prompt "Run complete test suite with coverage report. Identify any failing tests and uncovered code, then write additional tests to improve coverage"

# Update task status
Task tool with subagent_type="task-manager-droid-forge" \
  description "Complete testing tasks" \
  prompt "Mark testing tasks as completed in tasks/tasks-testing.md and update coverage metrics"
```

## Performance Testing

### Load Testing
```bash
# Artillery load testing
artillery run load-test-config.yml

# K6 performance testing
k6 run performance-test.js
```

### Performance Test Example
```javascript
// performance-test.js (k6)
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up to 100 users
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
};

export default function () {
  let response = http.get('https://api.example.com/users');
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  sleep(1);
}
```

## Test Quality Metrics

### Quality Indicators
- **Test Coverage**: Percentage of code covered by tests
- **Assertion Quality**: Specific vs generic assertions
- **Test Isolation**: Independence from external state
- **Error Coverage**: Testing of error conditions
- **Edge Cases**: Boundary and unusual input testing

### Quality Improvement
```bash
# Find tests with weak assertions
rg -n "\.(toBeTruthy|toBeFalsy|toBeUndefined|toBeNull)\(" tests/ --type js

# Find tests without assertions
rg -l "test\|it" tests/ --type js | xargs -I {} sh -c 'echo "=== {} ===" && rg -c "\.toBe\|\.toEqual\|\.toThrow" {}'

# Find large test files
find tests/ -name "*.test.*" -exec wc -l {} + | sort -nr | head -10
```

## Continuous Integration

### CI Configuration
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test -- --coverage
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

### Quality Gates
- All tests must pass
- Coverage thresholds must be met
- No new security vulnerabilities
- Performance regression tests pass

## Common Test Patterns

### Happy Path Testing
- Test expected functionality with valid inputs
- Verify correct behavior under normal conditions
- Ensure proper output and side effects

### Error Testing
- Test error conditions with invalid inputs
- Verify proper error handling and messages
- Test edge cases and boundary conditions

### Integration Testing
- Test component interactions
- Verify API contracts
- Test database operations

### Regression Testing
- Re-test fixed bugs
- Verify no functionality is broken
- Test critical user workflows
