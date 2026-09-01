# Contributing to Lost & Found System

Thank you for your interest in contributing! This guide will help you get started.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Assume good intent
- Report issues privately

## Getting Started

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR-USERNAME/LOSTANDFOUND.git
cd LOSTANDFOUND
```

### 2. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
git checkout -b bugfix/issue-description
```

Use:
- `feature/` for new features
- `bugfix/` for bug fixes
- `docs/` for documentation
- `refactor/` for code improvements

### 3. Set Up Development Environment

```bash
composer install
cp .env.example .env
# Configure .env with your local settings
```

## Development Workflow

### Making Changes

1. **Write Code**
   - Follow PSR-12 coding standards
   - Keep methods small and focused
   - Add comments for complex logic

2. **Test Your Changes**
   ```bash
   vendor/bin/phpunit tests/
   ```

3. **Validate Security**
   - Use Validator class for input validation
   - Always use prepared statements
   - Include CSRF tokens in forms

4. **Run Linting** (when available)
   ```bash
   vendor/bin/phpcs --standard=PSR12 src/
   ```

### Commit Messages

Use clear, descriptive commit messages:

```
Add feature: Brief description of change

- More detailed explanation of what changed
- Why this change was needed
- Any related issue numbers (Fixes #123)
```

Examples:
```
Add CSRF protection to login form

Implement CSRFToken class and add token validation
to access_logic.php to prevent cross-site requests.

Fixes #45
```

### Before Committing

1. Pull latest changes
   ```bash
   git pull origin main
   ```

2. Test everything
   ```bash
   vendor/bin/phpunit tests/
   ```

3. Check code quality
   ```bash
   # Review your changes
   git diff
   ```

4. Add and commit
   ```bash
   git add .
   git commit -m "Your message"
   ```

## Pull Request Process

### 1. Push Your Branch

```bash
git push origin feature/your-feature-name
```

### 2. Open Pull Request

On GitHub:
- **Title**: Clear, concise description
- **Description**: Explain what changed and why
- **Screenshots**: If UI changes were made
- **Related Issues**: Link any related issues

Template:
```markdown
## Description
Briefly describe your changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
Describe how to test your changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests pass locally
- [ ] No security vulnerabilities
- [ ] Documentation updated
```

### 3. Code Review

- Address review comments promptly
- Be open to suggestions
- Ask questions if unclear
- Update your PR after making changes

## Coding Standards

### PHP Code Style

```php
<?php
// Class names: PascalCase
class UserValidator {}

// Method names: camelCase
public function validateEmail() {}

// Constants: UPPER_SNAKE_CASE
const MAX_LENGTH = 255;

// Variables: $camelCase
$userEmail = '';

// Indentation: 4 spaces (no tabs)
if ($condition) {
    // Code here
}

// Braces on same line
public function doSomething() {
    return true;
}
```

### Security Standards

✅ **DO:**
```php
// Use prepared statements
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$id]);

// Validate input
$validator = new Validator();
$validator->email($email);

// Sanitize output
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// Log errors
Logger::error("Error message");

// Use CSRF tokens
<?php echo CSRFToken::field(); ?>
```

❌ **DON'T:**
```php
// String concatenation in SQL
$sql = "SELECT * FROM users WHERE id = " . $id;

// Filter_var without validation
$email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);

// Direct output without escaping
echo $_GET['name'];

// Exposing errors to users
die("Error: " . $e->getMessage());

// Hardcoding secrets
$password = 'secretpassword123';
```

## Testing Guidelines

### Writing Tests

Create test files in `tests/` directory:

```php
<?php

use PHPUnit\Framework\TestCase;
require_once __DIR__ . '/../config/Validator.php';

class ValidatorTest extends TestCase
{
    public function testEmailValidation()
    {
        $validator = new Validator();
        $this->assertTrue($validator->email('test@example.com'));
        $this->assertFalse($validator->email('invalid'));
    }
}
```

### Running Tests

```bash
# Run all tests
vendor/bin/phpunit

# Run specific test file
vendor/bin/phpunit tests/ValidatorTest.php

# Run with coverage
vendor/bin/phpunit --coverage-html coverage/
```

### Test Coverage

Aim for:
- 80%+ coverage for core classes
- 100% coverage for security-critical code
- All public methods tested

## Documentation

### Code Comments

```php
/**
 * Validates user email address
 *
 * @param string $email The email to validate
 * @param string $fieldName Name for error messages
 * @return bool True if valid, false otherwise
 */
public function email($email, $fieldName = 'Email')
{
    // Implementation
}
```

### README Updates

Update README.md if:
- Adding new features
- Changing installation steps
- Modifying API endpoints

### DEVELOPER_GUIDE Updates

Update DEVELOPER_GUIDE.md if:
- Adding new helper classes
- Changing configuration
- Adding security features

## Issue Reporting

### Bug Reports

Include:
- Clear title describing the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots/logs
- Environment (PHP version, OS, etc.)

### Feature Requests

Include:
- Clear description of the feature
- Use cases and benefits
- Proposed implementation approach
- Any potential security concerns

## Review Checklist for Maintainers

- [ ] Code follows standards
- [ ] Tests pass
- [ ] No security vulnerabilities
- [ ] Documentation updated
- [ ] Backwards compatible
- [ ] No hardcoded secrets
- [ ] Proper error handling
- [ ] Commits are atomic

## Getting Help

- **Questions**: Open a Discussion
- **Bugs**: Open an Issue with bug label
- **Features**: Open an Issue with enhancement label
- **Security**: Email security@lostandfound.local

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

## License

By contributing, you agree your code is licensed under MIT License.

## Questions?

Feel free to ask in:
- GitHub Issues
- GitHub Discussions
- Pull Request comments

Happy contributing! 🎉
