# 🛒 SwiftUI + Laravel Ecommerce App

A simple full-stack ecommerce application using **SwiftUI** for the iOS frontend and **Laravel** for the backend. This project showcases user authentication, product browsing, and API integration between iOS and a Laravel-based API server.

## 📱 iOS App Features (SwiftUI)

- SwiftUI-based clean UI
- Login & register using Laravel API
- Fetch product list from backend
- Display product details
- Dark mode support

## 🔙 Backend Features (Laravel)

- RESTful API with Laravel 10
- User registration & authentication (API tokens)
- Product listing and detail endpoints
- CORS enabled for frontend access

## 🛠️ Tech Stack

### iOS Frontend:
- Swift 5
- SwiftUI
- Combine
- URLSession for API calls

### Backend:
- Laravel 10
- MySQL (or SQLite)
- Sanctum (for API auth)

## 📦 Installation

### 🔧 Backend (Laravel)

1. Clone the repo:
   ```bash
   git clone https://github.com/semsethy/SwiftUI_Laravel_Ecommerce.git
   cd SwiftUI_Laravel_Ecommerce/backend

### Laravel Backend:

## Install dependencies
```bash
composer install
cp .env.example .env
php artisan key:generate
```

##Run migrations
```bash
php artisan migrate
php artisan db:seed
```

##Serve the backend
```bash
php artisan serve
```


