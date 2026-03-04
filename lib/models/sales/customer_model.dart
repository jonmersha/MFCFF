import 'dart:convert';

class Customer {
  final int? id;
  final String tracker;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String status;

  Customer({
    this.id,
    required this.tracker,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.status,
  });

  // --- FROM JSON (API -> FLUTTER) ---
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int?,
      // Using '??' as a fallback to prevent "null is not a subtype of String" errors
      tracker: json['tracker'] ?? '',
      name: json['name'] ?? 'Unknown Customer',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'inactive',
    );
  }

  // --- TO JSON (FLUTTER -> API) ---
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "status": status,
    };
  }

  // Helper method to create an empty customer for new forms
  factory Customer.empty() {
    return Customer(
      tracker: '',
      name: '',
      phone: '',
      email: '',
      address: '',
      status: 'active',
    );
  }
}