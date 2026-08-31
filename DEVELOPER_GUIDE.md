# Developer Setup Guide

## Quick Start

### 1. Environment Setup

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit `.env` with your local settings:

```env
DB_HOST=localhost
DB_NAME=campus_lost_found
DB_USER=root
DB_PASS=

APP_DEBUG=false
APP_ENV=development
APP_URL=http://localhost/LOSTANDFOUND
```

### 2. Install Dependencies

```bash
composer install
```

### 3. Database Setup

Create database and import schema:

```bash
mysql -u root
CREATE DATABASE campus_lost_found;
USE campus_lost_found;
SOURCE sql/schema.sql;
```

### 4. Permissions

Ensure upload directory is writable:

```bash
chmod 755 uploads/
mkdir -p logs/
chmod 755 logs/
```

## Using Security Features

### CSRF Protection

All forms automatically include CSRF tokens via the bootstrap:

```php
<?php echo CSRFToken::field(); ?>
```

In your POST handlers, validate the token:

```php
require_once 'config/bootstrap.php';

if (!CSRFToken::validate($_POST['_csrf_token'] ?? '')) {
    die("Security token invalid");
}
```

### Input Validation

Use the Validator class for consistent validation:

```php
$validator = new Validator();

// Email validation
$validator->email($_POST['email'], 'Email');

// Password validation (min 8 chars, 1 uppercase, 1 number)
$validator->password($_POST['password'], 'Password');

// String validation
$validator->string($_POST['name'], 'Name', 2, 100);

// Check for errors
if ($validator->hasErrors()) {
    foreach ($validator->getErrors() as $error) {
        echo $error;
    }
}

// Sanitize input
$email = $validator->sanitizeInput($_POST['email'], 'email');
```

### Error Logging

Log errors instead of displaying them to users:

```php
Logger::error("Login failed", ['email' => $email]);
Logger::info("User action completed");
Logger::warning("Suspicious activity detected");
Logger::debug("Debug information", ['var' => $value]);
```

Check logs in `logs/` directory:
- `error-YYYY-MM-DD.log` - Errors
- `info-YYYY-MM-DD.log` - Info messages
- `php-errors.log` - PHP errors

### Environment Variables

Access environment variables using EnvLoader:

```php
$dbHost = EnvLoader::get('DB_HOST');
$debugMode = EnvLoader::get('APP_DEBUG');
$mailPassword = EnvLoader::get('MAIL_PASSWORD');
```

## File Structure Guide

### config/
- **bootstrap.php** - Main entry point, loads all configurations
- **db.php** - Database connection (use bootstrap.php instead)
- **EnvLoader.php** - Environment variable loader
- **Validator.php** - Input validation helper
- **CSRFToken.php** - CSRF token generation and validation
- **Logger.php** - Error and event logging

### Main Pages
- **index.php** - Login/Register page
- **dashboard.php** - User dashboard
- **browse.php** - Browse items
- **report_item.php** - Report lost/found item
- **my_claims.php** - View user claims
- **peer_chat.php** - Peer messaging

### Admin Pages (admin/)
- **panel.php** - Admin dashboard
- **manage_users.php** - User management
- **manage_items.php** - Item management
- **claim_reviews.php** - Claim reviews
- **exchange_logs.php** - Transaction logs

### Includes
- **auth_check.php** - User authentication check
- **admin_check.php** - Admin role verification
- **sidebar.php** - Navigation sidebar

## Best Practices

### Always use bootstrap.php

Start every PHP file with:
```php
<?php
require_once 'config/bootstrap.php';
```

This ensures:
- Environment variables are loaded
- Logging is configured
- Security headers are set
- Error handling is active

### Form Security

Every form must include:
```html
<form method="POST">
    <?php echo CSRFToken::field(); ?>
    <!-- form fields -->
</form>
```

### Database Queries

Always use prepared statements:
```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();
```

### Input Handling

Never trust user input. Always sanitize and validate:
```php
$validator = new Validator();
$email = $validator->sanitizeInput($_POST['email'], 'email');
$validator->email($email);
```

## Deployment Checklist

- [ ] `.env` file created and configured for production
- [ ] Database credentials stored only in `.env`
- [ ] `APP_DEBUG` set to `false`
- [ ] Error logging directory has write permissions
- [ ] Upload directory has write permissions
- [ ] HTTPS enabled on server
- [ ] `.env` file NOT committed to git
- [ ] `vendor/` directory excluded from git
- [ ] `logs/` directory excluded from git

## Common Issues

### "Database Connection Failed"
- Check `.env` file exists and has correct database credentials
- Verify MySQL server is running
- Check database name matches in `.env`

### "CSRF token invalid"
- Ensure form includes `<?php echo CSRFToken::field(); ?>`
- Verify token validation in POST handler
- Check session is active

### Uploaded files not saving
- Verify `uploads/` directory has write permissions
- Check `MAX_UPLOAD_SIZE` in `.env`
- Ensure file is not too large

### Emails not sending
- Verify MAIL_* settings in `.env`
- For Gmail, use App Password not regular password
- Check server can connect to SMTP port (usually 587)

## Support

For issues, check:
1. Error logs in `logs/` directory
2. Browser console for frontend errors
3. PHP error log in `logs/php-errors.log`
