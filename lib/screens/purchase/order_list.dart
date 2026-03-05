import 'package:flutter/material.dart';
import 'package:mfco/screens/purchase/purchase_order_details.dart';
import '../../models/purchase/purchase_order_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key}); // Removed kDeepGreen parameter

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  final ApiService _apiService = ApiService();
  List<PurchaseOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final List<dynamic> data = await _apiService.get(ApiConstants.purchaseOrders);
      if (mounted) {
        setState(() {
          _orders = data.map((json) => PurchaseOrder.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Error loading orders: ${e.toString()}", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access global theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Uses theme background
      appBar: AppBar(
        title: const Text("Purchase Orders"),
        // No need to set backgroundColor here if defined in AppBarTheme
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
        color: primaryColor,
        onRefresh: _fetchOrders,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(_orders[index], primaryColor);
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(PurchaseOrder order, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PODetailPage(order: order)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.tracker,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _buildStatusBadge(order.status, primaryColor),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.business, size: 20, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(order.supplierName,
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  const Spacer(),
                  Text("${order.itemCount} Items",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 20, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(order.warehouseName,
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  const Spacer(),
                  Text(
                    "\$${order.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color primaryColor) {
    // Logic for specific status colors (Completed is Green, others are Warning/Orange)
    Color badgeColor = status == 'Completed' ? primaryColor : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}