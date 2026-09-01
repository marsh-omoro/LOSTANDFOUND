# Security Policy

## Overview

This document outlines the security practices and features implemented in the Lost and Found System.

## Security Features

### 1. **SQL Injection Prevention**

All database queries use prepared statements via PDO:

```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
```

✅ **Status**: Implemented across all database operations

### 2. **CSRF Protection**

All forms include CSRF tokens generated server-side:

```php
<?php echo CSRFToken::field(); ?>
```

Tokens are validated on POST handlers:

```php
if (!CSRFToken::validate($_POST['_csrf_token'] ?? '')) {
    die("Security token invalid");
}
```

✅ **Status**: Implemented in auth pages and forms

### 3. **Password Security**

- Passwords are hashed using bcrypt
- Minimum 8 characters with uppercase and numbers required
- Passwords never logged or displayed to users

```php
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);
$isValid = password_verify($userInput, $hashedPassword);
```

✅ **Status**: Implemented in authentication

### 4. **Input Validation & Sanitization**

All user inputs are validated and sanitized:

```php
$validator = new Validator();
$email = $validator->sanitizeInput($_POST['email'], 'email');
$validator->email($email);
```

- Email addresses validated against RFC standards
- HTML entities escaped to prevent XSS
- String lengths enforced
- Numeric validation for numbers

✅ **Status**: Implemented via Validator class

### 5. **Session Security**

- Session IDs regenerated after login
- Session timeout configured in `.env`
- Secure session headers set automatically

```php
session_regenerate_id(true);
```

✅ **Status**: Implemented in auth_check.php

### 6. **XSS Prevention**

HTML entities are escaped in all output:

```php
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');
```

✅ **Status**: Implemented in Validator sanitization

### 7. **Error Handling**

Errors are logged to files, NOT displayed to users:

```php
Logger::error("Login failed", ['email' => $email]);
```

✅ **Status**: Implemented via Logger class

### 8. **Environment Variable Protection**

Sensitive credentials stored in `.env`, never in code:

```php
$dbPass = EnvLoader::get('DB_PASS');
$mailPassword = EnvLoader::get('MAIL_PASSWORD');
```

`.env` file excluded from git:

```
.env
.env.local
```

✅ **Status**: Implemented with EnvLoader

### 9. **HTTP Security Headers**

Security headers automatically set in bootstrap:

```php
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: SAMEORIGIN');
header('X-XSS-Protection: 1; mode=block');
header('Strict-Transport-Security: max-age=31536000; includeSubDomains', false);
```

✅ **Status**: Implemented in config/bootstrap.php

### 10. **Authentication Checks**

All protected pages verify user authentication:

```php
require_once 'includes/auth_check.php';
```

Redirects unauthenticated users to login.

✅ **Status**: Implemented in auth_check.php

## Vulnerability Prevention

### SQL Injection
- ✅ All queries use prepared statements
- ✅ Parameters bound separately from SQL

### Cross-Site Scripting (XSS)
- ✅ HTML entities escaped in output
- ✅ User input never executed as code

### Cross-Site Request Forgery (CSRF)
- ✅ CSRF tokens required on all forms
- ✅ Tokens validated server-side

### Cross-Site Tracking (XST)
- ✅ TRACE method disabled
- ✅ X-Frame-Options header set

### Brute Force Attacks
- ⚠️ Consider implementing rate limiting (future enhancement)

### Session Hijacking
- ✅ Session ID regenerated after login
- ✅ Secure session headers

### Password Attacks
- ✅ Bcrypt hashing with work factor 10
- ✅ Password complexity requirements

## Security Best Practices

### For Developers

1. **Always require bootstrap.php**
   ```php
   require_once 'config/bootstrap.php';
   ```

2. **Validate all user input**
   ```php
   $validator = new Validator();
   $validator->email($_POST['email']);
   ```

3. **Never trust user input**
   - Sanitize before storage
   - Sanitize before output
   - Validate against expected format

4. **Use prepared statements**
   ```php
   $stmt = $pdo->prepare("...");
   $stmt->execute([$param]);
   ```

5. **Include CSRF tokens in forms**
   ```php
   <?php echo CSRFToken::field(); ?>
   ```

6. **Log security events**
   ```php
   Logger::warning("Suspicious activity: " . $message);
   ```

7. **Never log passwords or tokens**
   - Log user identifiers instead
   - Log action types and results

### For Administrators

1. **Regularly rotate credentials**
   - Update `.env` file periodically
   - Change database passwords
   - Rotate API keys

2. **Monitor error logs**
   - Check `logs/error-*.log` regularly
   - Review security-related warnings
   - Investigate suspicious patterns

3. **Keep dependencies updated**
   ```bash
   composer update
   ```

4. **Use HTTPS in production**
   - Redirect HTTP to HTTPS
   - Enable HSTS headers

5. **Set proper file permissions**
   ```bash
   chmod 755 public/
   chmod 700 config/
   chmod 755 logs/
   chmod 755 uploads/
   ```

6. **Regular backups**
   - Daily database backups
   - Version control for code
   - Disaster recovery plan

## Reporting Security Issues

⚠️ **Do NOT create public GitHub issues for security vulnerabilities.**

For security concerns:
1. Email: security@lostandfound.local
2. Include: description, severity, reproduction steps
3. Allow: 90 days for fix before public disclosure

## Security Checklist for Deployment

- [ ] `.env` file created with production credentials
- [ ] `.env` file NOT committed to git
- [ ] `APP_DEBUG` set to `false`
- [ ] Database password is strong (16+ chars, mixed case, numbers, symbols)
- [ ] Database user has minimal required privileges
- [ ] Upload directory has restrictive permissions
- [ ] Error logs cannot be accessed by public
- [ ] HTTPS enabled and configured
- [ ] SSL certificate valid and up-to-date
- [ ] HSTS header configured (Strict-Transport-Security)
- [ ] Dependencies are up-to-date (`composer update`)
- [ ] Regular backup strategy in place
- [ ] Admin accounts have strong passwords
- [ ] Session timeout is configured appropriately

## Compliance

This system implements security practices aligned with:

- **OWASP Top 10** - Common web vulnerabilities
- **CWE/SANS Top 25** - Software weaknesses
- **NIST Cybersecurity Framework** - Risk management

## Future Enhancements

- [ ] Rate limiting for login attempts
- [ ] Two-factor authentication (2FA)
- [ ] API authentication tokens (JWT)
- [ ] Role-based access control (RBAC) expansion
- [ ] Audit logging for admin actions
- [ ] Security scanning in CI/CD pipeline
- [ ] Automated penetration testing
- [ ] Regular security audits

## References

- [OWASP Security Cheat Sheet](https://cheatsheetseries.owasp.org/)
- [PHP Security Guide](https://www.php.net/manual/en/security.php)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Framework](https://www.nist.gov/cyberframework/)
