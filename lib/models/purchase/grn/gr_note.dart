import 'package:mfco/models/purchase/grn/r_note_items.dart';

class GoodsReceivingNote {
  final int? id;
  final String? tracker;
  final int purchaseOrder;
  final String? purchaseOrderTracker;
  final int? receivedBy;
  final String? receivedByName;
  final DateTime? receivedDate;
  final String status;
  final String remarks;
  final List<GrnItem> items;

  GoodsReceivingNote({
    this.id,
    this.tracker,
    required this.purchaseOrder,
    this.purchaseOrderTracker,
    this.receivedBy,
    this.receivedByName,
    this.receivedDate,
    required this.status,
    required this.remarks,
    required this.items,
  });

  factory GoodsReceivingNote.fromJson(Map<String, dynamic> json) {
    return GoodsReceivingNote(
      id: json['id'],
      tracker: json['tracker'],
      purchaseOrder: json['purchase_order'],
      purchaseOrderTracker: json['purchase_order_tracker'],
      receivedBy: json['received_by'],
      receivedByName: json['received_by_name'],
      receivedDate: json['received_date'] != null
          ? DateTime.parse(json['received_date'])
          : null,
      status: json['status'] ?? 'Draft',
      remarks: json['remarks'] ?? '',
      items: json['items'] != null
          ? List<GrnItem>.from(json['items'].map((x) => GrnItem.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'purchase_order': purchaseOrder,
    'remarks': remarks,
    'status': status,
    'items': List<dynamic>.from(items.map((x) => x.toJson())),
  };

  // Helper to calculate Grand Total in the UI
  double get grandTotal {
    return items.fold(0, (sum, item) => sum + (item.quantityReceived * item.unitPrice));
  }
}