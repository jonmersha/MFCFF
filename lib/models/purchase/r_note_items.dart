class GrnItem {
  final int? id;
  final String? tracker;
  final int purchaseOrderItem;
  final int product;
  final String? productName;
  final int quantityReceived;
  final double unitPrice;
  final double? lineTotal;

  GrnItem({
    this.id,
    this.tracker,
    required this.purchaseOrderItem,
    required this.product,
    this.productName,
    required this.quantityReceived,
    required this.unitPrice,
    this.lineTotal,
  });

  factory GrnItem.fromJson(Map<String, dynamic> json) {
    return GrnItem(
      id: json['id'],
      tracker: json['tracker'],
      purchaseOrderItem: json['purchase_order_item'],
      product: json['product'],
      productName: json['product_name'],
      quantityReceived: json['quantity_received'],
      // Handles both int and double from API
      unitPrice: (json['unit_price'] as num).toDouble(),
      lineTotal: json['line_total'] != null ? (json['line_total'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'purchase_order_item': purchaseOrderItem,
    'product': product,
    'quantity_received': quantityReceived,
    'unit_price': unitPrice,
  };
}