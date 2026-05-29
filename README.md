# Gift / Souvenir Collection API (NestJS + MongoDB)

REST API for Project 6 — handmade Cambodian gifts & souvenirs.

## Prerequisites

- Node.js 18+
- **MongoDB** running locally or MongoDB Atlas connection string

## Quick start

```bash
cd backend
npm install
npm run start:dev
```

**API:** `http://localhost:3000/api`

**MongoDB URI** (optional, default shown):

```bash
# Windows PowerShell
$env:MONGODB_URI="mongodb://127.0.0.1:27017/gift_souvenir"
$env:JWT_SECRET="your-secret-key"
npm run start:dev
```

Database `gift_souvenir` is created automatically. Sample data is seeded on first run.

## Authentication (JWT)

1. Register or login to get a token:

```http
POST /api/auth/login
Content-Type: application/json

{ "email": "customer@test.com", "password": "password123" }
```

2. Use the token on protected routes:

```http
Authorization: Bearer <access_token>
```

## Test accounts

| Email | Password | Role |
|-------|----------|------|
| customer@test.com | password123 | customer |
| artisan1@test.com | password123 | artisan |
| artisan2@test.com | password123 | artisan |

## IDs

MongoDB uses string IDs (24-char hex). Every document includes an `id` field in JSON responses.

Example: `GET /api/products/674a1b2c3d4e5f6789012345`

## Main endpoints

| Method | Path | Auth |
|--------|------|------|
| GET | `/home` | — |
| POST | `/auth/register` | — |
| POST | `/auth/login` | — |
| GET | `/products/:id` | — |
| GET | `/artisans/:id` | — |
| GET | `/collections/:id` | — |
| GET | `/artisans/map` | — |
| GET | `/artisans/nearby?lat=&lng=` | — |
| GET | `/coupons/active` | — |
| GET | `/gift-quiz/questions` | — |
| POST | `/gift-quiz/recommend` | — |
| GET | `/favorites` | JWT |
| POST | `/orders` | JWT |
| POST | `/chat` | JWT |
| POST | `/reviews` | JWT |

## Order example

```json
POST /api/orders
Authorization: Bearer <token>

{
  "items": [{ "product_id": "<mongo_product_id>", "quantity": 2 }],
  "gift_wrap": true,
  "personal_message": "Happy Khmer New Year!",
  "delivery_date": "2026-04-15",
  "coupon_code": "WELCOME10"
}
```

## Reset database

Drop the MongoDB database to re-seed:

```bash
mongosh gift_souvenir --eval "db.dropDatabase()"
```

Restart the server.
