# Milki System ERP

## Overview

Milki System is a **Centralized Enterprise Resource Planning (ERP) platform** designed for **Milki Food Complex** to manage and automate core operational processes across multiple factory locations and warehouses.

The system integrates critical business functions such as **inventory management, procurement, sales, logistics, finance tracking, and user management** into a single unified platform.

The goal of this system is to eliminate fragmented workflows and manual record keeping, enabling **real-time operational visibility, better decision making, and improved accountability across departments**. 

---

# Business Problem

Milki Food Complex operates across several factories and warehouses with increasing operational complexity. Currently many processes are handled manually or through disconnected tools.

Key operational challenges include:

* Lack of centralized visibility of inventory across warehouses
* Manual tracking of stock movements and orders
* Poor traceability of order lifecycle
* Limited linkage between shipments and payments
* Difficulty managing product categories and pricing
* Weak accountability due to undefined workflows
* Lack of real-time reporting and dashboards

The Milki System ERP addresses these challenges by providing a **centralized digital platform** for managing the full operational lifecycle. 

---

# System Objectives

The primary objectives of the system include:

* Centralize operational workflows across departments
* Improve inventory visibility across warehouses and factories
* Automate procurement and sales processes
* Enable real-time tracking of orders and shipments
* Improve financial monitoring and payment tracking
* Enhance employee accountability through role-based workflows
* Provide dashboards and reports for management decision-making

---

# Core Modules

The ERP system consists of the following modules.

## 1. Inventory Management

Manages product stock across factories and warehouses.

Features:

* Multi-warehouse inventory tracking
* Real-time stock visibility
* Inventory movement tracking
* Product lifecycle management
* Stock alerts and reconciliation

---

## 2. Procurement Management

Handles purchasing of raw materials and goods from suppliers.

Features:

* Supplier registration and management
* Purchase requisitions
* Purchase order generation
* Goods receiving
* Purchase tracking and reporting

Workflow:

```
Purchase Request
      ↓
Approval
      ↓
Purchase Order
      ↓
Vendor Fulfillment
      ↓
Goods Receipt
      ↓
Inventory Update
```

---

## 3. Sales & Order Management

Manages customer orders and product sales.

Features:

* Customer order creation
* Order lifecycle tracking
* Pricing and quantity management
* Order fulfillment tracking
* Payment status monitoring

Order Lifecycle:

```
Draft → Confirmed → Shipped → Delivered → Paid
```

---

## 4. Logistics & Shipment Tracking

Supports product dispatch and delivery operations.

Features:

* Shipment planning
* Route assignment
* Delivery tracking
* Shipment status updates
* Proof of delivery

---

## 5. Finance & Payment Tracking

Tracks financial transactions related to orders and purchases.

Features:

* Payment recording
* Outstanding payment monitoring
* Aging reports
* Financial alerts

---

## 6. Customer Relationship Management (CRM)

Manages customer interactions and support.

Features:

* Customer profile management
* Customer communication tracking
* Complaint management
* Engagement reporting

---

## 7. Human Resource Management (HRM)

Handles employee data and workforce management.

Features:

* Employee profiles
* Attendance tracking
* Leave management
* Performance tracking
* Payroll base data export

---

## 8. User & Role Management

Controls system access and user permissions.

Features:

* Role-based access control
* Permission management
* User activity logging
* Segregation of duties enforcement
* Security auditing

---

# System Architecture

The system follows a **modular architecture**, allowing each business domain to function independently while remaining integrated.

Example architecture:

```
Frontend (Web / Mobile)
        │
        │
REST API Layer
        │
        │
Backend Services
        │
 ├ Inventory Service
 ├ Procurement Service
 ├ Sales Service
 ├ Finance Service
 ├ HR Service
 └ CRM Service
        │
        │
Database Layer
```

---

# Database Overview

The system uses a **relational database structure** with core entities such as:

### Core Entities

* Company
* Factory
* Warehouses
* Products
* Inventory
* Inventory Movement
* Purchase Orders
* Sales Orders
* Suppliers
* Customers
* System Users
* Roles and Permissions
* Audit Logs

Example tables from the schema:

* `Company`
* `Factory`
* `Warehouses`
* `Products`
* `Inventory`
* `Inventory_Movement`
* `Purchase_Order`
* `Sales_Order`
* `Suppliers`
* `Customers`
* `System_Users`

The schema also implements **authorization tracking and audit trails** for accountability. 

---

# Security Features

The system includes several security mechanisms:

* Role-based access control
* User permission management
* Audit logging of system actions
* Login monitoring
* Segregation of duty enforcement
* Authorization tracking for sensitive operations

---

# Non-Functional Requirements

The system is designed to support enterprise-level reliability.

Key characteristics:

* Web-based and mobile-responsive interface
* Scalable architecture
* Secure authentication and encryption
* Multilingual support (Amharic / English)
* REST API integration capability
* Backup and disaster recovery readiness

---

# Future Enhancements

Planned future improvements include:

* AI-based inventory forecasting
* Mobile field sales applications
* Barcode and scanner integration
* Integration with financial platforms
* Sustainability and compliance tracking
* Export logistics modules

---

# Installation

Example setup steps:

```bash
git clone https://github.com/your-org/milki-system.git
cd milki-system
```

Database setup:

```bash
mysql -u root -p < milki2.sql
```

Run backend service:

```bash
python manage.py runserver
```

Run frontend:

```bash
flutter run
```

---

# Project Structure

Example project layout:

```
milki-system
│
├ backend
│   ├ inventory
│   ├ procurement
│   ├ sales
│   ├ finance
│   └ users
│
├ frontend
│   ├ mobile_app
│   └ web_app
│
├ database
│   └ milki2.sql
│
├ docs
│   └ business_requirements.md
│
└ README.md
```

---

# Stakeholders

The primary stakeholders include:

* Executive Management
* Warehouse Staff
* Procurement Officers
* Sales & Marketing Team
* Logistics Coordinators
* Finance Department
* HR Department
* System Administrators

---

# License

This project is proprietary and intended for internal use by **Milki Food Complex**.


