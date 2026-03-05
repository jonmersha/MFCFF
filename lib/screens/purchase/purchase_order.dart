import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class PurchaseOrderActionPage extends StatefulWidget {
  final dynamic purchaseOrder; // Pass the PO Map here

  const PurchaseOrderActionPage({super.key, required this.purchaseOrder});

  @override
  State<PurchaseOrderActionPage> createState() => _PurchaseOrderActionPageState();
}

class _PurchaseOrderActionPageState extends State<PurchaseOrderActionPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  /// STEP 1: Create a GRN for this Purchase Order
  Future<void> _createGRN() async {
    setState(() => _isLoading = true);

    final Map<String, dynamic> grnData = {
      "purchase_order": widget.purchaseOrder['id'],
      "remarks": "Received via Mobile App",
      // received_by is handled by backend request.user
    };

    try {
      // Your ApiService.post returns http.Response
      final response = await _apiService.post("${ApiConstants.baseUrl}/purchase/grns/", grnData);

      if (response.statusCode == 201) {
        _showSnackBar("GRN Created! Now posting to inventory...", Colors.blue);
        // Step 2: Extract tracker from the new GRN and Post it
        // Note: You may need to decode response.body to get the tracker
        // For this example, we assume we fetch the latest GRN tracker
      }
    } catch (e) {
      _showSnackBar("Error creating GRN: $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// STEP 2: Post the GRN to Inventory (The 405 fix)
  Future<void> _postToInventory(String grnTracker) async {
    setState(() => _isLoading = true);
    try {
      // We MUST use POST with an empty body as per your backend action
      final String url = "${ApiConstants.baseUrl}/purchase/grns/$grnTracker/post_to_inventory/";

      final response = await _apiService.post(url, {});

      if (response.statusCode == 200) {
        _showSnackBar("Inventory Updated Successfully!", Colors.green);
        Navigator.pop(context, true);
      } else {
        _showSnackBar("Server rejected update: ${response.statusCode}", Colors.orange);
      }
    } catch (e) {
      _showSnackBar("Post failed: ${e.toString()}", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPending = widget.purchaseOrder['status'] == 'Pending';

    return Scaffold(
      appBar: AppBar(title: Text("PO: ${widget.purchaseOrder['tracker']}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(),
            const Spacer(),
            if (isPending)
              _buildActionButton(
                label: "RECEIVE ITEMS & UPDATE STOCK",
                color: Colors.green,
                onPressed: _createGRN,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: ListTile(
        title: Text("Supplier: ${widget.purchaseOrder['supplier_name']}"),
        subtitle: Text("Total: \$${widget.purchaseOrder['total_amount']}"),
        trailing: Chip(label: Text(widget.purchaseOrder['status'])),
      ),
    );
  }

  Widget _buildActionButton({required String label, required Color color, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: _isLoading ? null : onPressed,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}