// import 'dart:convert';
//
// class GoodsReceivingNote {
//   final int id;
//   final String tracker;
//   final int purchaseOrder;
//   final String poTracker;
//   final String supplierName;
//   final String warehouseName;
//   final DateTime receivedDate;
//   final int receivedBy;
//   final String receivedByName;
//   final int itemCount;
//   final double totalReceivedValue;
//   final String remarks;
//   final String status;
//
//   GoodsReceivingNote({
//     required this.id,
//     required this.tracker,
//     required this.purchaseOrder,
//     required this.poTracker,
//     required this.supplierName,
//     required this.warehouseName,
//     required this.receivedDate,
//     required this.receivedBy,
//     required this.receivedByName,
//     required this.itemCount,
//     required this.totalReceivedValue,
//     required this.remarks,
//     required this.status,
//   });
//
//   factory GoodsReceivingNote.fromJson(Map<String, dynamic> json) {
//     return GoodsReceivingNote(
//       id: json['id'],
//       tracker: json['tracker'] ?? '',
//       purchaseOrder: json['purchase_order'],
//       poTracker: json['po_tracker'] ?? '',
//       supplierName: json['supplier_name'] ?? 'Unknown',
//       warehouseName: json['warehouse_name'] ?? 'Main',
//       receivedDate: DateTime.parse(json['received_date']),
//       receivedBy: json['received_by'],
//       receivedByName: json['received_by_name'] ?? '',
//       itemCount: json['item_count'] ?? 0,
//       totalReceivedValue: (json['total_received_value'] as num).toDouble(),
//       remarks: json['remarks'] ?? '',
//       status: json['status'] ?? 'Draft',
//     );
//   }
// }