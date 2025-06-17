# 🛒 SwiftUI + Laravel Ecommerce App

This is a simple E-commerce mobile app built with **SwiftUI** for the frontend and **Laravel** as the backend API. The app allows users to browse products, view details, and simulate a shopping experience.

## 📱 iOS Frontend (SwiftUI)

### Features:
- Product listing
- Product detail view
- Add to cart (basic logic)
- Dark/light mode support
- Clean UI with SwiftUI components

### Technologies:
- SwiftUI
- MVVM Architecture
- Combine (if applicable)
- URLSession for networking
- Codable for parsing JSON

## 🔗 Backend (Laravel)

> This repository includes only the iOS frontend.  
> The Laravel backend is assumed to be hosted separately and returns API responses in JSON.

### Example API endpoints expected:
- `/api/products` — get list of products
- `/api/products/{id}` — get product detail

## 📷 Screenshots

nil

## 🚀 Getting Started

### Requirements:
- Xcode 13+
- iOS 15.0+
- Swift 5.5+

### Installation:
1. Clone this repository:
    ```bash
    git clone https://github.com/semsethy/SwiftUI_Laravel_Ecommerce.git
    ```
2. Open `SwiftUI_Laravel_Ecommerce.xcodeproj` in Xcode.
3. Run the app on Simulator or real device.

### Configuration:
Update the base URL in your networking class to match your Laravel API base endpoint.

## 📂 Folder Structure

