import 'package:flutter/material.dart';
import '../../models/purchase/order_item_model.dart';
import '../../models/purchase/purchase_order_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class PODetailPage extends StatefulWidget {
  final PurchaseOrder order;

  const PODetailPage({super.key, required this.order});

  @override
  State<PODetailPage> createState() => _PODetailPageState();
}

class _PODetailPageState extends State<PODetailPage> {
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;

  /// Logic to Create GRN and Post to Inventory
  Future<void> _handleReceiving() async {
    setState(() => _isProcessing = true);
    try {
      // 1. Create the GRN
      final grnResponse = await _apiService.post(ApiConstants.grns, {
        "purchase_order": widget.order.id,
        "remarks": "Received via Mobile App",
      });

      if (grnResponse.statusCode == 201) {
        // 2. Post to Inventory (Using the custom action in your Django ViewSet)
        final postResponse = await _apiService.post(
            "${ApiConstants.purchaseOrders}${widget.order.tracker}/confirm_order/",
            {}
        );

        if (postResponse.statusCode == 200 && mounted) {
          _showSnackBar("Inventory Updated Successfully!", Colors.green);
          Navigator.pop(context, true); // Return to list and refresh
        }
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(theme, primaryColor),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ITEMS (${widget.order.itemCount})",
                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 12),
                  ...widget.order.items.map((item) => _buildItemCard(item, primaryColor)).toList(),
                  const SizedBox(height: 80), // Padding for bottom button
                ],
              ),
            ),
          ],
        ),
      ),
      // Action button only shows if the order is still Pending
      bottomSheet: widget.order.status == 'Pending' ? _buildBottomAction(primaryColor) : null,
    );
  }

  Widget _buildHeader(ThemeData theme, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Text(widget.order.tracker, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            "\$${widget.order.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoColumn(Icons.person, "Supplier", widget.order.supplierName),
              _infoColumn(Icons.store, "Warehouse", widget.order.warehouseName),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white60, size: 20),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildItemCard(PurchaseOrderItem item, Color primaryColor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Icon(Icons.inventory, color: primaryColor),
        ),
        title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item.quantity} units x \$${item.unitPrice}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("\$${item.lineTotal}", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            Text(item.status, style: TextStyle(fontSize: 10, color: item.status == 'Received' ? Colors.green : Colors.orange)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handleReceiving,
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("RECEIVE & UPDATE STOCK"),
      ),
    );
  }

  void _showSnackBar(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
  }
}