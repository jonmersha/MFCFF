import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/purchase/grn/gr_note.dart';

class GRNDetailPage extends StatelessWidget {
  final GoodsReceivingNote grn;
  const GRNDetailPage({super.key, required this.grn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "ETB ");

    return Scaffold(
      appBar: AppBar(
        title: Text(grn.tracker!),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Text("PURCHASE ORDER: ${grn.purchaseOrderTracker}",
                      style: const TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 13)),
                  const SizedBox(height: 15),
                  Text(currencyFormat.format(grn.grandTotal),
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _statusChip(grn.status, theme),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logistics Details
                  _infoGrid(theme),

                  const SizedBox(height: 25),
                  const Text("RECEIVED ITEMS",
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(height: 10),

                  // Items Table
                  _buildItemsTable(theme, currencyFormat),

                  const SizedBox(height: 20),

                  // Remarks Section
                  if (grn.remarks.isNotEmpty) ...[
                    const Text("REMARKS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(grn.remarks, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoGrid(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _rowItem(Icons.person_outline, "Received By", grn.receivedByName ?? "N/A"),
          const Divider(),
          _rowItem(Icons.calendar_today_outlined, "Date",
              grn.receivedDate != null ? DateFormat('yMMMMd').format(grn.receivedDate!) : "N/A"),
          const Divider(),
          _rowItem(Icons.confirmation_number_outlined, "PO ID", "#${grn.purchaseOrder}"),
        ],
      ),
    );
  }

  Widget _rowItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildItemsTable(ThemeData theme, NumberFormat currency) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Total')),
        ],
        rows: grn.items.map((item) {
          return DataRow(cells: [
            DataCell(Text(item.productName ?? "Item #${item.product}", style: const TextStyle(fontSize: 12))),
            DataCell(Text(item.quantityReceived.toString())),
            DataCell(Text(currency.format(item.lineTotal ?? 0.0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _statusChip(String status, ThemeData theme) {
    bool isPosted = status.toLowerCase() == 'posted';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isPosted ? Colors.green.shade700 : Colors.orange.shade700,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Text(status.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
    );
  }
}