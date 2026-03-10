import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class CreateSalesOrderPage extends StatefulWidget {
  const CreateSalesOrderPage({super.key});

  @override
  State<CreateSalesOrderPage> createState() => _CreateSalesOrderPageState();
}

class _CreateSalesOrderPageState extends State<CreateSalesOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  int? _selectedSupplier;
  int? _selectedWarehouse;
  int? _selectedProduct;

  List<dynamic> _suppliers = [];
  List<dynamic> _warehouses = [];
  List<dynamic> _products = [];

  // Controllers with default quantity of 1
  final _quantityController = TextEditingController(text: "1");
  final _priceController = TextEditingController();
  double _totalPrice = 0.0;

  bool _isLoadingData = true;
  bool _isSubmitting = false;
  bool _forceNewOrder = false;

  @override
  void initState() {
    super.initState();
    _loadAllDependencies();

    // CRITICAL: Listeners to ensure the total updates as you type
    _quantityController.addListener(_updateUIForTotal);
    _priceController.addListener(_updateUIForTotal);
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Function called by listeners to refresh the Total Price display
  void _updateUIForTotal() {
    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    setState(() {
      _totalPrice = qty * price;
    });
  }

  Future<void> _loadAllDependencies() async {
    try {
      final results = await Future.wait([
        _apiService.get(ApiConstants.suppliers),
        _apiService.get(ApiConstants.warehouses),
        _apiService.get(ApiConstants.products),
      ]);

      if (mounted) {
        setState(() {
          _suppliers = results[0];
          _warehouses = results[1];
          _products = results[2];
          _isLoadingData = false;
        });
      }
    } catch (e) {
      _showSnackBar("Error loading data: $e", Colors.red);
    }
  }

  void _onProductChanged(int? productId) {
    if (productId == null) return;
    final product = _products.firstWhere((p) => p['id'] == productId, orElse: () => null);

    if (product != null) {
      setState(() {
        _selectedProduct = productId;
        // Setting .text triggers the listener automatically
        var priceValue = product['unit_price'] ?? product['price'] ?? 0.0;
        _priceController.text = priceValue.toString();
      });
    }
  }

  String _getNameById(List<dynamic> list, int? id) {
    if (id == null) return "Not Selected";
    final item = list.firstWhere((e) => e['id'] == id, orElse: () => null);
    return item != null ? (item['name'] ?? "Unknown") : "Not Selected";
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final payload = {
        "supplier": _selectedSupplier,
        "warehouse": _selectedWarehouse,
        "product": _selectedProduct,
        "quantity": double.parse(_quantityController.text),
        "unit_price": double.parse(_priceController.text),
        "force_new_order": _forceNewOrder,
      };

      await _apiService.post(ApiConstants.purchaseItems, payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar("Submission failed", Colors.red);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("New Purchase Entry")),
      // Using Column + Expanded to keep the footer pinned while the form scrolls
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Logistics"),
                    _buildDropdown("Supplier", _suppliers, _selectedSupplier, (v) => setState(() => _selectedSupplier = v)),
                    _buildDetailLabel("Selected: ${_getNameById(_suppliers, _selectedSupplier)}"),

                    const SizedBox(height: 10),
                    _buildDropdown("Warehouse", _warehouses, _selectedWarehouse, (v) => setState(() => _selectedWarehouse = v)),
                    _buildDetailLabel("Store: ${_getNameById(_warehouses, _selectedWarehouse)}"),

                    const SizedBox(height: 20),
                    _buildSectionTitle("Product Details"),
                    _buildDropdown("Select Product", _products, _selectedProduct, _onProductChanged),
                    _buildDetailLabel("Item: ${_getNameById(_products, _selectedProduct)}"),

                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildTextField(_quantityController, "Qty", Icons.numbers, isNumber: true)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildTextField(_priceController, "Unit Price", Icons.attach_money, isNumber: true)),
                      ],
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Force New Order?", style: TextStyle(fontSize: 14)),
                      value: _forceNewOrder,
                      onChanged: (val) => setState(() => _forceNewOrder = val),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          //Container(color: Colors.black,height: 20,width: 50,)
          _buildSummaryFooter(theme),
          //SizedBox(height: 30,)
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildDetailLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildSummaryFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Line Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("\$${_totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.primaryColor)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("ADD TO PURCHASE ORDER"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<dynamic> items, int? value, Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: const Icon(Icons.list_alt),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map<DropdownMenuItem<int>>((item) {
        return DropdownMenuItem<int>(
          value: item['id'],
          child: Text(item['name'] ?? 'No Name', overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 1.2)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}