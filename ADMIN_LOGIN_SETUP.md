# Admin Login Setup Guide

## Issues Fixed

### ✅ Missing Fonts (Web)
The missing Noto fonts warning has been fixed by:
1. Adding Google Fonts link to `web/index.html` with support for:
   - Noto Sans (Regular & Bold)
   - Noto Serif Khmer (for Khmer text support)
2. Updated `pubspec.yaml` with font asset declarations for mobile platforms

### ✅ OpenStreetMap Tiles Warning
This is informational only. The `flutter_map` package warns that OSM public tile servers are not free for production use.
- **For production**: Consider setting up a custom tile server (Mapbox, Thunderforest, etc.)
- **For development**: The current setup is fine

---

## Admin Login Issue - Why It's Not Working

### Root Cause
The app tries to connect to an API server at **`http://localhost:3000/api`** which likely isn't running.

### What Needs to Happen

1. **Backend API Server Must Be Running**
   - Your app makes requests to: `http://localhost:3000/api/auth/login`
   - Ensure your backend server (Node.js, Express, etc.) is running on port 3000

2. **Admin Account Must Exist in Database**
   - An admin user account must exist with:
     - Email: (whatever you're testing with)
     - Password: (correct password)
     - Role: `'admin'`
   - Example admin account:
     ```
     {
       name: "Admin",
       email: "admin@example.com",
       password: "securePassword123",
       role: "admin"
     }
     ```

3. **Login Flow**
   - User enters email and password in login screen
   - App sends POST request to `/api/auth/login`
   - Backend validates credentials and returns user object with `role` field
   - If `role == 'admin'`, app navigates to admin dashboard
   - User details stored in SharedPreferences for persistence

### How to Test Admin Login

#### Step 1: Ensure Backend is Running
```bash
# If using Node.js/Express
npm start
# or
node server.js

# Should show: Server running on http://localhost:3000
```

#### Step 2: Create Test Admin Account
Use a database tool (MongoDB Compass, Postman, etc.) to insert:
```json
{
  "name": "Admin User",
  "email": "admin@gift-store.com",
  "password": "admin123",
  "role": "admin",
  "_id": "admin_id_123"
}
```

#### Step 3: Test Login
1. Open the app in browser
2. Enter admin email and password
3. Should navigate to `/admin` route
4. Admin dashboard should load

### Debugging Login Issues

**If login shows "Incorrect email or password":**
1. Check console (DevTools) for network error details
2. Verify backend server is running (`curl http://localhost:3000/api/health`)
3. Verify admin account exists in database
4. Check that response includes `user.role == 'admin'`

**If admin dashboard doesn't load:**
1. Check that AdminApi.loadAdminData() succeeds
2. Verify authentication token is properly stored in SharedPreferences

---

## API Endpoints Called

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/auth/login` | POST | Login user and get role |
| `/api/admin/data` | GET | Load admin dashboard data |
| `/api/artisans` | GET/POST | Artisan management |
| `/api/products` | GET/POST | Product management |
| `/api/orders` | GET | Order management |

---

## Environment Variables (if needed)

To change API base URL from default localhost:3000, rebuild with:
```bash
flutter build web --dart-define=API_BASE='http://your-api.com/api'
```

Current default: `http://localhost:3000/api`
