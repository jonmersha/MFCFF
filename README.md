
# Milki Mobile ERP App

## Overview

Milki Mobile ERP is a **Flutter-based mobile application** designed to provide employees and managers of **Milki Food Complex** with real-time access to operational workflows.

The application connects to the **Milki ERP backend APIs** and allows staff to perform tasks such as:

* Managing inventory
* Processing purchase orders
* Recording goods receiving
* Tracking sales orders
* Managing customers and suppliers
* Monitoring stock movements
* Viewing operational dashboards

The mobile app enables **field staff, warehouse personnel, and managers** to interact with the system anytime and anywhere.

---

# Features

## Inventory Management

The mobile application provides tools for warehouse staff to manage stock.

Capabilities include:

* View warehouse inventory
* Track stock levels in real time
* Monitor inventory movements
* View product details
* Track stock changes

---

## Purchase Order Management

Users can manage procurement activities directly from their mobile device.

Features:

* Create purchase orders
* Add items to purchase orders
* Update order status
* Track supplier orders
* Monitor order progress

---

## Goods Receiving

Warehouse staff can register received goods.

Features:

* Record goods received from suppliers
* Verify quantities received
* Update inventory automatically
* Attach notes or remarks
* Track receiving history

---

## Sales Order Management

Sales teams can manage customer orders through the app.

Features:

* Create sales orders
* Track order status
* View customer details
* Monitor payment status
* Review order history

---

## Customer & Supplier Management

The mobile app provides quick access to customer and supplier information.

Features:

* View customer profiles
* View supplier information
* Access contact details
* Track transaction history

---

## Role-Based Access

The system supports **role-based access control** to ensure users only see what they are authorized to access.

Example roles include:

* Admin
* Warehouse Staff
* Sales Staff
* Procurement Officers
* Finance Staff

---

# Technology Stack

The mobile application is built using modern technologies.

| Layer             | Technology                                               |
| ----------------- | -------------------------------------------------------- |
| Mobile Framework  | Flutter                                                  |
| Language          | Dart                                                     |
| State Management  | Provider / Riverpod / Bloc (depending on implementation) |
| API Communication | REST APIs                                                |
| Authentication    | Token-based authentication                               |
| Backend           | Django / REST API                                        |
| Database          | MySQL / PostgreSQL                                       |

---

# Application Architecture

The Flutter application follows a **modular and scalable architecture**.

```
lib
│
├ core
│   ├ constants
│   ├ services
│   └ utilities
│
├ models
│   ├ inventory
│   ├ purchase
│   ├ sales
│   └ users
│
├ providers
│
├ screens
│   ├ dashboard
│   ├ inventory
│   ├ purchase_orders
│   ├ goods_receiving
│   ├ sales_orders
│   └ customers
│
├ widgets
│
└ main.dart
```

---

# Key Screens

The mobile app includes the following major screens.

### Dashboard

Provides a quick overview of:

* Inventory status
* Pending orders
* Recent transactions
* Alerts

---

### Inventory Screen

Allows users to:

* View available stock
* Check product details
* Track inventory movements

---

### Purchase Orders

Used to:

* Create purchase orders
* Add items
* Update order status
* Track supplier deliveries

---

### Goods Receiving

Used by warehouse staff to:

* Record incoming products
* Verify quantities
* Update stock

---

### Sales Orders

Allows sales staff to:

* Create orders
* Track order status
* View customer orders

---

### Customer Management

Provides access to:

* Customer profiles
* Contact information
* Order history

---

# Installation

## 1. Clone the repository

```bash
git clone https://github.com/your-org/milki-mobile-app.git
cd milki-mobile-app
```

---

## 2. Install dependencies

```bash
flutter pub get
```

---

## 3. Configure API Endpoint

Update the API base URL in:

```
lib/core/constants/api_constants.dart
```

Example:

```dart
const String baseUrl = "http://your-backend-server/api/";
```

---

## 4. Run the application

```bash
flutter run
```

---

# Environment Requirements

Before running the application, ensure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or Physical Device

Check Flutter installation:

```bash
flutter doctor
```

---

# Permissions

The mobile app may require the following permissions:

* Internet access
* Camera (for future barcode scanning)
* Storage access (for file uploads)
* Location (for logistics features)

---

# Future Enhancements

Planned improvements for the mobile app include:

* Barcode scanning for inventory
* Offline mode for warehouse operations
* Push notifications for order updates
* Delivery tracking with GPS
* Mobile dashboards with analytics
* Image upload for proof of delivery

---

# Contributors

Milki System Development Team

* Backend Developers
* Mobile Developers
* System Analysts
* ERP Consultants

---

# License

This project is proprietary software developed for **Milki Food Complex**.

Unauthorized distribution or modification is not permitted.

