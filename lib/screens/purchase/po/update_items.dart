import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/purchase/po/order_item_model.dart';

class EditItem extends StatefulWidget {
  final int itemId;
  final PurchaseOrderItem initialItem;
  final String? supplierName;
  final String? warehouseName;
  final String? orderTracker;

  const EditItem({
    super.key,
    required this.itemId,
    required this.initialItem,
    this.supplierName,
    this.warehouseName,
    this.orderTracker,
  });

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  int? _selectedProduct;
  List<dynamic> _products = [];

  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoadingData = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedProduct = widget.initialItem.id;
    _quantityController.text = widget.initialItem.quantity.toString();
    _priceController.text = widget.initialItem.unitPrice.toString();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final data = await _apiService.get(ApiConstants.products);
      if (!mounted) return;
      setState(() {
        _products = data;
        _isLoadingData = false;
        // Ensure the ID exists in the list to prevent assertion error
        bool exists = _products.any((p) => (p['id'] as num).toInt() == _selectedProduct);
        if (!exists) _selectedProduct = null;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final payload = {
        "product": _selectedProduct,
        "quantity": double.tryParse(_quantityController.text) ?? 0.0,
        "unit_price": double.tryParse(_priceController.text) ?? 0.0,
      };

      await _apiService.put("${ApiConstants.purchaseItems}/${widget.itemId}/", payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteItem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Are you sure you want to remove this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.delete("${ApiConstants.purchaseItems}${widget.initialItem.tracker}/");
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit: ${widget.initialItem.tracker ?? 'Item'}")),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: _selectedProduct,
                    decoration: const InputDecoration(labelText: "Product", border: OutlineInputBorder()),
                    items: _products.map<DropdownMenuItem<int>>((p) => DropdownMenuItem<int>(
                      value: (p['id'] as num).toInt(),
                      child: Text(p['name'] ?? 'Unknown'),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedProduct = v),
                    validator: (v) => v == null ? "Required" : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Quantity", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Unit Price", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _updateItem(),
                    child: const Text("UPDATE ITEM"),
                  ),
                  TextButton(
                    onPressed: () => _deleteItem(),
                    child: const Text("DELETE ITEM", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() => Container(
    color: Colors.blueGrey.shade50,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(child: _buildHeaderInfo("Order", widget.orderTracker)),
        Expanded(child: _buildHeaderInfo("Supplier", widget.supplierName)),
        Expanded(child: _buildHeaderInfo("Warehouse", widget.warehouseName)),
      ],
    ),
  );

  Widget _buildHeaderInfo(String label, String? value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text(value ?? "-", style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}