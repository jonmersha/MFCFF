import 'package:flutter/material.dart';

import '../../models/purchase/purchase.dart';
import '../../services/api_service.dart';
import '../../widgets/supplier/supplier_form_page.dart';

class SupplierDetailsPage extends StatelessWidget {
  final Supplier supplier;
  const SupplierDetailsPage({super.key, required this.supplier});

  void _deleteSupplier(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this supplier?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService().delete('/purchase/suppliers/${supplier.tracker}/');
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierFormPage(existingSupplier: supplier))),
          ),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteSupplier(context)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _infoTile("Tracker ID", supplier.tracker),
          _infoTile("Company Name", supplier.name),
          _infoTile("Contact Person", supplier.contactPerson),
          _infoTile("Phone", supplier.phone),
          _infoTile("Email", supplier.email),
          _infoTile("Address", supplier.address),
          _infoTile("Status", supplier.status.toUpperCase()),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Divider(),
      ]),
    );
  }
}