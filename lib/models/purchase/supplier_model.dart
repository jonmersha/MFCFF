class Supplier {
  final int id;
  final String tracker;
  final String name;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String status;

  Supplier({
    required this.id,
    required this.tracker,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.status,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    id: json['id'],
    tracker: json['tracker'],
    name: json['name'],
    contactPerson: json['contact_person'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    status: json['status'],
  );
}
