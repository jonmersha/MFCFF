// lib/models/sales_models.dart

class Customer {
  final int id;
  final String tracker;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String status;

  Customer({
    required this.id,
    required this.tracker,
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    tracker: json['tracker'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    status: json['status'],
  );
}

class SalesOrder {
  final int id;
  final String tracker;
  final int customerId;
  final String orderStatus;
  final DateTime orderDate;
  final String paymentStatus;
  final List<SalesItem> items;

  SalesOrder({
    required this.id,
    required this.tracker,
    required this.customerId,
    required this.orderStatus,
    required this.orderDate,
    required this.paymentStatus,
    required this.items,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
    id: json['id'],
    tracker: json['tracker'],
    customerId: json['customer'],
    orderStatus: json['order_status'],
    orderDate: DateTime.parse(json['order_date']),
    paymentStatus: json['payment_status'],
    items: (json['items'] as List? ?? [])
        .map((i) => SalesItem.fromJson(i))
        .toList(),
  );
}

class SalesItem {
  final int id;
  final String tracker;
  final int productId;
  final int sourceWarehouseId;
  final int quantity;
  final double price;
  final double totalPrice;
  final String status;

  SalesItem({
    required this.id,
    required this.tracker,
    required this.productId,
    required this.sourceWarehouseId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.status,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) => SalesItem(
    id: json['id'],
    tracker: json['tracker'],
    productId: json['product_name'],
    sourceWarehouseId: json['source_whouse'],
    quantity: json['quantity'],
    price: double.parse(json['price'].toString()),
    totalPrice: double.parse(json['total_price'].toString()),
    status: json['status'],
  );
}

class SalesTransaction {
  final int id;
  final String tracker;
  final int saleItemId;
  final DateTime transactionDate;
  final double amount;
  final String paymentMethod;
  final String? bankReference;
  final String paymentStatus;

  SalesTransaction({
    required this.id,
    required this.tracker,
    required this.saleItemId,
    required this.transactionDate,
    required this.amount,
    required this.paymentMethod,
    this.bankReference,
    required this.paymentStatus,
  });

  factory SalesTransaction.fromJson(Map<String, dynamic> json) => SalesTransaction(
    id: json['id'],
    tracker: json['tracker'],
    saleItemId: json['sale_item'],
    transactionDate: DateTime.parse(json['transaction_date']),
    amount: double.parse(json['amount'].toString()),
    paymentMethod: json['payment_method'],
    bankReference: json['bank_reference'],
    paymentStatus: json['payment_status'],
  );
}