# API Documentation

## Authentication Endpoints

### POST /access_logic.php
Login user with email and password.

**Request:**
```json
{
  "email": "user@strathmore.edu",
  "password": "SecurePassword123",
  "_csrf_token": "token_value"
}
```

**Success Response (302 Redirect):**
- Location: `/dashboard.php` (student) or `/admin/panel.php` (admin)

**Error Responses:**
- `error=invalid` - Invalid email or password
- `error=security` - CSRF token validation failed
- `error=unverified` - Email not verified
- HTTP 500 - Database error

**Security:** ✅ CSRF token required, Password hashed with bcrypt

---

### POST /register_process.php
Register new student account.

**Request:**
```json
{
  "username": "John Doe",
  "email": "john@strathmore.edu",
  "password": "SecurePassword123",
  "confirm_password": "SecurePassword123",
  "course": "BSc. Informatics and Computer Science",
  "year": "Year 1",
  "_csrf_token": "token_value"
}
```

**Success Response (302 Redirect):**
- Location: `/index.php?status=registered`
- Account created, user must sign in

**Error Responses:**
- `error=invalid` - Validation failed
- `error=exists` - Email already registered
- HTTP 500 - Database error

**Validation:**
- Email must end with `@strathmore.edu`
- Password min 8 chars, 1 uppercase, 1 number
- Username required, 2-100 characters
- Course and year required

**Security:** ✅ CSRF token required, Input validated, Passwords hashed

---

### POST /logout.php
Logout current user and destroy session.

**Request:** No parameters required

**Success Response (302 Redirect):**
- Location: `/index.php`

**Security:** ✅ Session destroyed, User authenticated

---

## Item Endpoints

### GET /browse.php
Browse all lost and found items with optional filtering.

**Query Parameters:**
- `category` - Filter by category (optional)
- `status` - Filter by status: `lost`, `found` (optional)
- `search` - Search by item name/description (optional)
- `page` - Pagination (optional, default 1)

**Success Response:**
```json
{
  "items": [
    {
      "id": 1,
      "name": "iPhone 12",
      "description": "Black iPhone with case",
      "category": "Electronics",
      "status": "lost",
      "reported_by": "John Doe",
      "reported_date": "2024-01-15",
      "image_url": "/uploads/item_1.jpg"
    }
  ],
  "total": 45,
  "page": 1,
  "pages": 5
}
```

**Security:** ✅ Authenticated users only

---

### GET /item_detail.php
Get detailed information about a specific item.

**Query Parameters:**
- `id` - Item ID (required)

**Success Response:**
```json
{
  "id": 1,
  "name": "iPhone 12",
  "description": "Black iPhone with case",
  "category": "Electronics",
  "status": "lost",
  "reported_by": {
    "id": 5,
    "name": "John Doe",
    "email": "john@strathmore.edu"
  },
  "reported_date": "2024-01-15",
  "image_url": "/uploads/item_1.jpg",
  "claims_count": 3,
  "can_edit": false,
  "can_delete": false
}
```

**Error Responses:**
- `error=not_found` - Item not found
- `error=invalid` - Invalid item ID

**Security:** ✅ Authenticated users only

---

### POST /report_item.php
Report a lost or found item.

**Request:**
```json
{
  "name": "iPhone 12",
  "description": "Black iPhone with case",
  "category": "Electronics",
  "status": "lost",
  "location_found": "Library entrance",
  "image": "binary_image_data",
  "_csrf_token": "token_value"
}
```

**Success Response (302 Redirect):**
- Location: `/dashboard.php?status=reported`
- Item created with ID in session

**Request:**
```json
{
  "item_id": 1
}
```

**Error Responses:**
- `error=invalid` - Validation failed
- `error=unauthorized` - Not item owner
- HTTP 500 - Upload failed

**Validation:**
- Name required, 2-255 characters
- Description required, 10-1000 characters
- Category required
- Status must be `lost` or `found`
- Image optional, max 5MB, JPG/PNG only

**Security:** ✅ CSRF token required, File upload validated, Owner verification

---

### POST /delete_item.php
Delete an item (owner only).

**Request:**
```json
{
  "item_id": 1,
  "_csrf_token": "token_value"
}
```

**Success Response (302 Redirect):**
- Location: `/dashboard.php?status=deleted`

**Error Responses:**
- `error=not_found` - Item not found
- `error=unauthorized` - Not item owner
- `error=invalid_token` - CSRF validation failed

**Security:** ✅ CSRF token required, Owner verification only

---

## Claim Endpoints

### POST /claim_submit.php
Submit a claim for a lost item.

**Request:**
```json
{
  "item_id": 1,
  "claim_message": "I found this phone at the library",
  "contact_info": "0712345678",
  "_csrf_token": "token_value"
}
```

**Success Response (302 Redirect):**
- Location: `/my_claims.php?status=submitted`
- Claim created, notifications sent

**Error Responses:**
- `error=invalid` - Validation failed
- `error=duplicate` - Already claimed this item
- `error=not_found` - Item not found
- HTTP 500 - Database error

**Validation:**
- item_id must exist
- claim_message required, 10-500 characters
- contact_info required

**Security:** ✅ CSRF token required, Duplicate prevention, Authenticated only

---

### GET /my_claims.php
View current user's claims.

**Query Parameters:**
- `status` - Filter by claim status (optional)
- `page` - Pagination (optional, default 1)

**Success Response:**
```json
{
  "claims": [
    {
      "id": 1,
      "item_id": 5,
      "item_name": "iPhone 12",
      "status": "pending",
      "claimed_date": "2024-01-20",
      "message": "I found this phone",
      "owner_response": null
    }
  ],
  "total": 5,
  "page": 1
}
```

**Claim Status Values:**
- `pending` - Awaiting owner review
- `approved` - Claim approved by owner
- `rejected` - Claim rejected by owner

**Security:** ✅ Authenticated users only, Own claims only

---

## Messaging Endpoints

### GET /peer_chat.php
List conversations or get messages from specific user.

**Query Parameters:**
- `user_id` - Specific user ID (optional)
- `page` - Pagination (optional, default 1)

**Success Response:**
```json
{
  "conversations": [
    {
      "user_id": 3,
      "username": "Jane Smith",
      "last_message": "Okay, I'll check",
      "last_message_date": "2024-01-20T15:30:00Z",
      "unread_count": 2
    }
  ]
}
```

**Security:** ✅ Authenticated users only

---

### POST /peer_chat.php
Send a message to another user.

**Request:**
```json
{
  "recipient_id": 3,
  "message": "Have you found my keys?",
  "_csrf_token": "token_value"
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message_id": 42,
  "sent_date": "2024-01-20T15:35:00Z"
}
```

**Error Responses:**
- `error=invalid` - Validation failed
- `error=recipient_not_found` - User not found
- `error=self_message` - Cannot message yourself

**Validation:**
- recipient_id must exist
- message required, 1-1000 characters

**Security:** ✅ CSRF token required, Authenticated only

---

## Admin Endpoints

### GET /admin/panel.php
Admin dashboard with system statistics.

**Success Response:**
```json
{
  "total_users": 450,
  "total_items": 1200,
  "pending_claims": 25,
  "recent_activity": []
}
```

**Security:** ✅ Admin role required

---

### GET /admin/manage_users.php
List all users with pagination.

**Query Parameters:**
- `page` - Pagination (optional, default 1)
- `role` - Filter by role (optional)

**Success Response:**
```json
{
  "users": [
    {
      "id": 1,
      "username": "John Doe",
      "email": "john@strathmore.edu",
      "role": "student",
      "course": "BICS",
      "created_date": "2024-01-01"
    }
  ],
  "total": 450
}
```

**Security:** ✅ Admin role required

---

### GET /admin/manage_items.php
List all items for moderation.

**Query Parameters:**
- `status` - Filter by status (optional)
- `page` - Pagination (optional, default 1)

**Success Response:**
```json
{
  "items": [
    {
      "id": 1,
      "name": "iPhone 12",
      "status": "lost",
      "reported_by": "John Doe",
      "reported_date": "2024-01-15",
      "flagged": false
    }
  ],
  "total": 1200
}
```

**Security:** ✅ Admin role required

---

### GET /admin/claim_reviews.php
Review pending claims.

**Query Parameters:**
- `status` - Filter by status (optional)
- `page` - Pagination (optional, default 1)

**Success Response:**
```json
{
  "claims": [
    {
      "id": 1,
      "item_name": "iPhone 12",
      "claimant": "Jane Smith",
      "item_owner": "John Doe",
      "status": "pending",
      "message": "I found this phone"
    }
  ],
  "total": 25
}
```

**Security:** ✅ Admin role required

---

## Error Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 302 | Redirect - Use for form submissions |
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - User not authenticated |
| 403 | Forbidden - User not authorized |
| 404 | Not Found - Resource doesn't exist |
| 409 | Conflict - Resource conflict (e.g., duplicate email) |
| 422 | Unprocessable - Validation failed |
| 500 | Internal Server Error - Database or system error |

## Response Format

All responses follow this format:

**Success:**
```json
{
  "success": true,
  "data": { /* actual response data */ }
}
```

**Error:**
```json
{
  "success": false,
  "error": "error_code",
  "message": "Human readable message"
}
```

## Rate Limiting

Currently not implemented. Planned for future release.

## Versioning

API is currently v1. Major changes will increment version.

---

**Last Updated:** 2024-01-20  
**Version:** 1.0
