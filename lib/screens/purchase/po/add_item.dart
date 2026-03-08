import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

/// Typed Model to ensure ID-based relationships and prevent nulls
class SelectionItem {
  final int id;
  final String name;
  final double price;

  SelectionItem({required this.id, required this.name, required this.price});

  factory SelectionItem.fromJson(Map<String, dynamic> json) {
    final priceValue = json['unit_price'] ?? json['price'] ?? 0.0;
    return SelectionItem(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (priceValue is num) ? priceValue.toDouble() : 0.0,
    );
  }
}

class AddItemToOrderPage extends StatefulWidget {
  final int? orderId;
  final int? supplierId;
  final int? warehouseId;
  final String? supplierName;
  final String? warehouseName;
  final String? orderTracker;

  const AddItemToOrderPage({
    super.key,
    this.orderId,
    this.supplierId,
    this.warehouseId,
    this.supplierName,
    this.warehouseName,
    this.orderTracker,
  });

  @override
  State<AddItemToOrderPage> createState() => _AddItemToOrderPageState();
}

class _AddItemToOrderPageState extends State<AddItemToOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  int? _selectedProduct;
  List<SelectionItem> _products = [];

  final _quantityController = TextEditingController(text: "1");
  final _priceController = TextEditingController();
  double _totalPrice = 0.0;

  bool _isLoadingData = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _quantityController.addListener(_updateUIForTotal);
    _priceController.addListener(_updateUIForTotal);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateUIForTotal() {
    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    setState(() => _totalPrice = qty * price);
  }

  Future<void> _loadProducts() async {
    try {
      final data = await _apiService.get(ApiConstants.products);
      if (!mounted) return;
      setState(() {
        _products = (data as List).map((e) => SelectionItem.fromJson(e)).toList();
        _isLoadingData = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading: $e")));
    }
  }

  void _onProductChanged(int? productId) {
    if (productId == null) return;
    final product = _products.firstWhere((p) => p.id == productId);
    setState(() {
      _selectedProduct = productId;
      _priceController.text = product.price.toStringAsFixed(2);
      _updateUIForTotal(); // Force recalculation
    });
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final payload = {
        "order": widget.orderId,
        "warehouse":widget.warehouseId,// Change "order_id" to "order"
        "supplier": widget.supplierId,    // Change "supplier_id" to "supplier"
        "product": _selectedProduct,      // Change "product_id" to "product"
        "quantity": double.tryParse(_quantityController.text),
        "unit_price": double.tryParse(_priceController.text),

      };
      print(payload);

      await _apiService.post(ApiConstants.purchaseItems, payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission failed: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add to ${widget.orderTracker ?? 'Order'}")),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          /// Header Information
          _buildHeaderSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select Product", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildProductDropdown(),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(child: _buildTextField(_quantityController, "Quantity", Icons.numbers)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField(_priceController, "Unit Price", Icons.attach_money)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          _buildSummaryFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() => Container(
    color: Colors.blueGrey.shade50,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
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

  Widget _buildProductDropdown() => DropdownButtonFormField<int>(
    isExpanded: true,
    value: _selectedProduct,
    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Product"),
    items: _products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
    onChanged: _onProductChanged,
    validator: (v) => v == null ? "Required" : null,
  );

  Widget _buildTextField(TextEditingController c, String l, IconData i) => TextFormField(
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, size: 20), border: const OutlineInputBorder()),
  );

  Widget _buildSummaryFooter(ThemeData theme) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: theme.cardColor, boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)]),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Line Total", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("\$${_totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        ]),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitOrder,
          child: const Text("CONFIRM & ADD ITEM"),
        )),
      ],
    ),
  );
}