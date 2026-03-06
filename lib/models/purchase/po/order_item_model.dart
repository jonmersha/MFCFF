class PurchaseOrderItem {
  final int id;
  final String tracker;
  final int purchaseOrder;
  final int product;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String status;

  PurchaseOrderItem({
    required this.id,
    required this.tracker,
    required this.purchaseOrder,
    required this.product,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.status,
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItem(
      id: json['id'],
      tracker: json['tracker'],
      purchaseOrder: json['purchase_order'],
      product: json['product'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      lineTotal: (json['line_total'] as num).toDouble(),
      status: json['status'],
    );
  }
}