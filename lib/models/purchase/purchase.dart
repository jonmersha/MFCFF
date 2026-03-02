// lib/models/purchase_models.dart

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

class PurchaseOrder {
  final int id;
  final String tracker;
  final int destinationStore; // Warehouse ID
  final int supplier;
  final DateTime orderDate;
  final String status;
  final List<PurchaseOrderItem> items;

  PurchaseOrder({
    required this.id,
    required this.tracker,
    required this.destinationStore,
    required this.supplier,
    required this.orderDate,
    required this.status,
    required this.items,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    id: json['id'],
    tracker: json['tracker'],
    destinationStore: json['destination_store'],
    supplier: json['supplier'],
    orderDate: DateTime.parse(json['order_date']),
    status: json['status'],
    items: (json['items'] as List)
        .map((i) => PurchaseOrderItem.fromJson(i))
        .toList(),
  );
}

class PurchaseOrderItem {
  final int id;
  final String tracker;
  final int productId;
  final int quantity;
  final double unitPrice;
  final String status;

  PurchaseOrderItem({
    required this.id,
    required this.tracker,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.status,
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) => PurchaseOrderItem(
    id: json['id'],
    tracker: json['tracker'],
    productId: json['product'],
    quantity: json['quantity'],
    unitPrice: double.parse(json['unit_price'].toString()),
    status: json['status'],
  );
}