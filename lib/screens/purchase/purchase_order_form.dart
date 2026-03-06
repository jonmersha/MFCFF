import 'package:flutter/material.dart';

class CreatePurchaseOrderPage extends StatefulWidget {
  const CreatePurchaseOrderPage({super.key});

  @override
  State<CreatePurchaseOrderPage> createState() => _CreatePurchaseOrderPageState();
}

class _CreatePurchaseOrderPageState extends State<CreatePurchaseOrderPage> {
  final List<Map<String, dynamic>> _items = [];
  String? _supplierId;
  String? _warehouseId;

  // Add Item Dialog
  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Product"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Product Name')),
          TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
          TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Unit Price'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.add({
                  "product": nameCtrl.text, // Ensure this matches your API expected field
                  "quantity": int.tryParse(qtyCtrl.text) ?? 0,
                  "unit_price": double.tryParse(priceCtrl.text) ?? 0.0,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPO() async {
    final payload = {
      "supplier": _supplierId,
      "destination_store": _warehouseId,
      "items": _items, // Nested list sent to Django
    };
    // await _apiService.post(ApiConstants.purchaseOrders, payload);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Purchase Order")),
      body: Column(
        children: [
          // Basic Header Inputs
          Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            TextField(decoration: const InputDecoration(labelText: "Supplier ID"), onChanged: (v) => _supplierId = v),
            TextField(decoration: const InputDecoration(labelText: "Warehouse ID"), onChanged: (v) => _warehouseId = v),
          ])),

          // Item List
          Expanded(child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(_items[i]['product']),
              subtitle: Text("Qty: ${_items[i]['quantity']} | Price: \$${_items[i]['unit_price']}"),
              trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _items.removeAt(i))),
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddItemDialog, child: const Icon(Icons.add)),
      bottomNavigationBar: ElevatedButton(onPressed: _submitPO, child: const Text("Finalize & Submit Order")),
    );
  }
}