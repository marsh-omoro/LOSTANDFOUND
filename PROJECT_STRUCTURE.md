# Project Structure Guide

## 📁 Directory Organization

```
LOSTANDFOUND/
├── config/                      # Configuration & helper classes
│   ├── bootstrap.php           # Main entry point (REQUIRED in all files)
│   ├── db.php                  # Database connection
│   ├── EnvLoader.php           # Environment variable loader
│   ├── Validator.php           # Input validation helper
│   ├── CSRFToken.php           # CSRF token protection
│   ├── Logger.php              # Error logging
│   └── mail_config.php         # Email configuration
│
├── includes/                    # Reusable PHP includes
│   ├── auth_check.php          # User authentication check
│   ├── admin_check.php         # Admin role verification
│   └── sidebar.php             # Navigation sidebar
│
├── admin/                       # Admin panel pages
│   ├── panel.php               # Main admin dashboard
│   ├── manage_users.php        # User management
│   ├── manage_items.php        # Item management
│   ├── claim_reviews.php       # Claim review system
│   └── exchange_logs.php       # Transaction logs
│
├── assets/                      # Frontend assets
│   ├── *.png, *.jpg           # Images
│   ├── *.css                  # Stylesheets
│   └── *.js                   # JavaScript files
│
├── uploads/                     # User uploaded files
│   └── .gitkeep               # Placeholder (keeps folder tracked)
│
├── logs/                        # Application logs
│   ├── error-YYYY-MM-DD.log   # Error logs
│   ├── info-YYYY-MM-DD.log    # Info logs
│   ├── php-errors.log         # PHP errors
│   └── .gitkeep               # Placeholder
│
├── sql/                         # Database schemas
│   └── schema.sql             # Database schema
│
├── tests/                       # Unit tests
│   ├── ValidatorTest.php      # Validator tests
│   └── test_mail.php          # Email tests
│
├── vendor/                      # Composer dependencies (git ignored)
│   ├── phpmailer/
│   ├── phpunit/               # Added in v1.1.0
│   └── ...
│
├── .env                        # Environment variables (git ignored, create from .env.example)
├── .env.example                # Template for .env (git tracked)
├── .gitignore                  # Git ignore rules
│
├── index.php                   # Login/Register page
├── dashboard.php               # User dashboard
├── browse.php                  # Browse items
├── report_item.php             # Report item form
├── item_detail.php             # Item details
├── my_claims.php               # My claims
├── my_reports.php              # My reports
├── claim_modal.php             # Claim modal
├── claim_submit.php            # Submit claim
├── access_logic.php            # Authentication logic
├── register_process.php        # Registration handler
├── logout.php                  # Logout handler
├── peer_chat.php               # Peer messaging
├── mark_notifications_read.php # Mark notifications read
├── delete_item.php             # Delete item handler
├── verify.php                  # Email verification
│
├── composer.json               # PHP dependencies
├── composer.lock               # Locked dependency versions
│
├── README.md                   # Project overview (UPDATED)
├── SECURITY.md                 # Security documentation (NEW)
├── DEVELOPER_GUIDE.md          # Developer guide (NEW)
├── CONTRIBUTING.md            # Contributing guide (NEW)
├── API.md                      # API documentation (NEW)
├── CHANGELOG.md                # Version history (NEW)
└── IMPLEMENTATION_SUMMARY.md   # This implementation (NEW)
```

---

## 📄 File Descriptions

### Core Configuration Files

| File | Purpose | Usage |
|------|---------|-------|
| `config/bootstrap.php` | Main entry point | `require_once 'config/bootstrap.php';` |
| `config/EnvLoader.php` | Load .env variables | Used by bootstrap |
| `config/Validator.php` | Input validation | `$v = new Validator();` |
| `config/CSRFToken.php` | CSRF protection | `CSRFToken::field()` |
| `config/Logger.php` | Error logging | `Logger::error(...)` |
| `config/db.php` | Database connection | Loaded by bootstrap |

### Main Pages

| File | Purpose | Route |
|------|---------|-------|
| `index.php` | Login/Register | `/` |
| `dashboard.php` | User dashboard | `/dashboard.php` |
| `browse.php` | Browse items | `/browse.php` |
| `report_item.php` | Report form | `/report_item.php` |
| `item_detail.php` | Item details | `/item_detail.php?id=X` |
| `my_claims.php` | User claims | `/my_claims.php` |
| `my_reports.php` | User reports | `/my_reports.php` |
| `peer_chat.php` | Messaging | `/peer_chat.php` |

### Handlers (Form Processors)

| File | Purpose | Input |
|------|---------|-------|
| `access_logic.php` | Login processor | POST /access_logic.php |
| `register_process.php` | Registration processor | POST /register_process.php |
| `claim_submit.php` | Claim processor | POST /claim_submit.php |
| `delete_item.php` | Delete processor | POST /delete_item.php |
| `mark_notifications_read.php` | Notification handler | POST |

### Admin Pages

| File | Purpose | Route |
|------|---------|-------|
| `admin/panel.php` | Admin dashboard | `/admin/panel.php` |
| `admin/manage_users.php` | User management | `/admin/manage_users.php` |
| `admin/manage_items.php` | Item management | `/admin/manage_items.php` |
| `admin/claim_reviews.php` | Claim reviews | `/admin/claim_reviews.php` |
| `admin/exchange_logs.php` | Transaction logs | `/admin/exchange_logs.php` |

### Include Files

| File | Purpose | Usage |
|------|---------|-------|
| `includes/auth_check.php` | Require authentication | `require_once 'includes/auth_check.php';` |
| `includes/admin_check.php` | Require admin role | `require_once 'includes/admin_check.php';` |
| `includes/sidebar.php` | Navigation sidebar | `<?php include 'includes/sidebar.php'; ?>` |

### Documentation

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Overview & setup | Users & developers |
| `DEVELOPER_GUIDE.md` | Development practices | Developers |
| `SECURITY.md` | Security features | Security & admins |
| `CONTRIBUTING.md` | Contributing guide | Contributors |
| `API.md` | API documentation | API users |
| `CHANGELOG.md` | Version history | All |
| `IMPLEMENTATION_SUMMARY.md` | This implementation | Project managers |

---

## 🔄 File Dependencies

```
index.php
├── config/bootstrap.php        (START HERE)
├── config/CSRFToken.php
├── config/Validator.php
└── config/access_logic.php
    ├── config/db.php
    ├── config/Logger.php
    └── config/Validator.php

dashboard.php
├── includes/auth_check.php
│   └── config/bootstrap.php
├── config/Logger.php
└── [other page content]
```

---

## 🚀 Getting Started

### 1. First Time Setup

```bash
cd C:\xampp\htdocs\LOSTANDFOUND

# Copy environment template
cp .env.example .env

# Install PHP dependencies
composer install

# Create logs directory
mkdir logs
```

### 2. Edit Configuration

Edit `.env` with your database credentials:

```env
DB_HOST=localhost
DB_NAME=campus_lost_found
DB_USER=root
DB_PASS=
```

### 3. Start Using

All pages automatically load configuration via `config/bootstrap.php`.

### 4. (Optional) Run Tests

```bash
vendor/bin/phpunit tests/
```

---

## 📋 Usage Examples

### Validate User Input

```php
<?php
require_once 'config/bootstrap.php';

$validator = new Validator();

// Email validation
if (!$validator->email($_POST['email'])) {
    foreach ($validator->getErrors() as $error) {
        echo $error;
    }
}

// String validation
if (!$validator->string($_POST['name'], 'Name', 2, 100)) {
    // Handle error
}
```

### Log Events

```php
<?php
require_once 'config/bootstrap.php';

Logger::error("Database connection failed");
Logger::warning("User attempted to access restricted area");
Logger::info("User logged in: john@example.com");
Logger::debug("Processing payment", ['user_id' => 123]);
```

### CSRF Protection

```php
<!-- In your form -->
<?php echo CSRFToken::field(); ?>

<!-- In your POST handler -->
<?php
require_once 'config/bootstrap.php';

if (!CSRFToken::validate($_POST['_csrf_token'] ?? '')) {
    die("Security token invalid");
}
```

### Environment Variables

```php
<?php
require_once 'config/bootstrap.php';

$dbHost = EnvLoader::get('DB_HOST', 'localhost');
$debugMode = EnvLoader::get('APP_DEBUG') === 'true';
$mailPassword = EnvLoader::get('MAIL_PASSWORD');
```

---

## 🔒 Security Notes

- Always require `config/bootstrap.php` at the top of files
- Always use `Validator` class for input
- Always use prepared statements for database queries
- Always include CSRF tokens in forms
- Never hardcode secrets - use `.env` file
- Check `SECURITY.md` for complete security guide

---

## 📞 Getting Help

1. **Setup Issues** → See `DEVELOPER_GUIDE.md`
2. **Security Questions** → See `SECURITY.md`
3. **API Usage** → See `API.md`
4. **Contributing** → See `CONTRIBUTING.md`
5. **Changes** → See `CHANGELOG.md`

---

**Last Updated:** 2024-01-20
