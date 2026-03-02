class Supplier {
  final int id;
  final String tracker;
  final String name;
  final String? contactPerson; // Mapped from contact_person
  final String? phone;
  final String? email;
  final String? address;
  final String status;

  Supplier({
    required this.id,
    required this.tracker,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    required this.status,
  });

  // Factory method to create a Supplier from JSON
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      tracker: json['tracker'],
      name: json['name'],
      contactPerson: json['contact_person'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      status: json['status'] ?? 'active',
    );
  }

  // Method to convert Supplier to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "contact_person": contactPerson,
      "phone": phone,
      "email": email,
      "address": address,
      "status": status,
    };
  }
}
