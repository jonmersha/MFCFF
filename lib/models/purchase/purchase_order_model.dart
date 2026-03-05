import 'order_item_model.dart';

class PurchaseOrder {
  final int id;
  final String tracker;
  final int supplier;
  final String supplierName;
  final int destinationStore;
  final String warehouseName;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final int itemCount;
  final List<PurchaseOrderItem> items;

  PurchaseOrder({
    required this.id,
    required this.tracker,
    required this.supplier,
    required this.supplierName,
    required this.destinationStore,
    required this.warehouseName,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.itemCount,
    required this.items,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'],
      tracker: json['tracker'],
      supplier: json['supplier'],
      supplierName: json['supplier_name'],
      destinationStore: json['destination_store'],
      warehouseName: json['warehouse_name'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      itemCount: json['item_count'],
      items: (json['items'] as List)
          .map((i) => PurchaseOrderItem.fromJson(i))
          .toList(),
    );
  }
}
