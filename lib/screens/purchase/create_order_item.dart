import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreatePurchaseItemPage extends StatefulWidget {
  const CreatePurchaseItemPage({super.key});

  @override
  State<CreatePurchaseItemPage> createState() => _CreatePurchaseItemPageState();
}

class _CreatePurchaseItemPageState extends State<CreatePurchaseItemPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Selection IDs (In a real app, fetch these from APIs)
  String? _selectedSupplier;
  String? _selectedWarehouse;
  String? _selectedProduct;
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _forceNew = false;
  bool _isSaving = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    // Matches your AddPurchaseItemSerializer fields
    final Map<String, dynamic> data = {
      "supplier": _selectedSupplier, // ID
      "warehouse": _selectedWarehouse, // ID
      "product": _selectedProduct, // ID
      "quantity": int.parse(_qtyController.text),
      "unit_price": double.parse(_priceController.text),
      "force_new_order": _forceNew,
    };

    try {
      // We use POST on the PurchaseOrderItems endpoint
      final http.Response response = await _apiService.post(
          "${ApiConstants.baseUrl}/purchase/items/",
          data
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Added Successfully")));
          Navigator.pop(context, true);
        }
      } else {
        _showError("Failed: ${response.body}");
      }
    } catch (e) {
      _showError("Error: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item to Order")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("This will add an item to a pending order or create a new one automatically.",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            // For brevity, using simple text fields for IDs.
            // In production, use Dropdowns populated from APIs.
            _buildField("Supplier ID", (val) => _selectedSupplier = val),
            _buildField("Warehouse ID", (val) => _selectedWarehouse = val),
            _buildField("Product ID", (val) => _selectedProduct = val),

            TextFormField(
              controller: _qtyController,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Unit Price"),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title: const Text("Force New Order Number?"),
              value: _forceNew,
              onChanged: (val) => setState(() => _forceNew = val!),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], minimumSize: const Size(double.infinity, 50)),
              onPressed: _isSaving ? null : _submit,
              child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("ADD TO ORDER", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, Function(String) onSave) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: onSave,
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }
}