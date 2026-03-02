import 'package:flutter/material.dart';
import '../../models/inventory/product_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/inventory/create_product_form.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  Future<void> _handleDelete() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text(
          "Delete ${widget.product.name}? This action is permanent.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final res = await _apiService.delete(
          "${ApiConstants.products}${widget.product.tracker}/",
        );
        if (res.statusCode == 200 || res.statusCode == 204) {
          if (mounted) Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => CreateProductForm(
                kDeepGreen: kDeepGreen,
                onSaved: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context, true);
                },
                existingProduct: p,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoTile(
            Icons.label_important_outline,
            "Product Tracker",
            p.tracker,
          ),
          _buildInfoTile(Icons.shopping_bag_outlined, "Product Name", p.name),
          _buildInfoTile(
            Icons.payments_outlined,
            "Unit Price",
            "${p.unitPrice} ETB",
          ),
          _buildInfoTile(
            Icons.scale_outlined,
            "Unit of Measure",
            p.unitOfMeasure,
          ),
          _buildInfoTile(Icons.business_outlined, "Company", p.companyName),
          _buildInfoTile(Icons.info_outline, "Status", p.status.toUpperCase()),
          const Divider(height: 40),
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(p.description ?? "No description available."),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: kDeepGreen),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
