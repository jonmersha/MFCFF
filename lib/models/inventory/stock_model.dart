class Stock {
  final int id;
  final String tracker;
  final int productId;
  final String productName; // Often added via DRF Serializer MethodField
  final int warehouseId;
  final String warehouseName;
  final int quantity;
  final int lockedAmount;
  final double? totalValue;

  Stock({
    required this.id,
    required this.tracker,
    required this.productId,
    required this.productName,
    required this.warehouseId,
    required this.warehouseName,
    required this.quantity,
    required this.lockedAmount,
    this.totalValue,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    id: json['id'],
    tracker: json['tracker'],
    productId: json['product'],
    productName: json['product_display'] ?? "Unknown Product",
    warehouseId: json['warehouse'],
    warehouseName: json['warehouse_display'] ?? "Main Storage",
    quantity: json['quantity'],
    lockedAmount: json['locked_amount'],
    totalValue: json['total_value'] != null
        ? double.parse(json['total_value'].toString())
        : 0.0,
  );
}
