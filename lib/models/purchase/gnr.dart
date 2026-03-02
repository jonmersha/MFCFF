class GoodsReceivingNote {
  final int id;
  final String tracker;
  final int purchaseOrder;
  final String receivedBy;
  final DateTime receivedDate;
  final List<GRNItem> grnItems;

  GoodsReceivingNote({
    required this.id,
    required this.tracker,
    required this.purchaseOrder,
    required this.receivedBy,
    required this.receivedDate,
    required this.grnItems,
  });

  factory GoodsReceivingNote.fromJson(Map<String, dynamic> json) => GoodsReceivingNote(
    id: json['id'],
    tracker: json['tracker'],
    purchaseOrder: json['purchase_order'],
    receivedBy: json['received_by'],
    receivedDate: DateTime.parse(json['received_date']),
    grnItems: (json['grn_items'] as List)
        .map((i) => GRNItem.fromJson(i))
        .toList(),
  );
}

class GRNItem {
  final int poItem; // PurchaseOrderItem ID
  final int quantityReceived;

  GRNItem({required this.poItem, required this.quantityReceived});

  factory GRNItem.fromJson(Map<String, dynamic> json) => GRNItem(
    poItem: json['po_item'],
    quantityReceived: json['quantity_received'],
  );
}