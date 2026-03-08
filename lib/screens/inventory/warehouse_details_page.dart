import 'package:flutter/material.dart';
import 'package:mfco/models/inventory/warehouse_model.dart';
import 'package:mfco/widgets/factory_core/create_warehouse_form.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class WarehouseDetailsPage extends StatelessWidget {
  final Warehouse warehouse;
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  WarehouseDetailsPage({super.key, required this.warehouse});

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Warehouse"),
        content: Text("Are you sure you want to delete ${warehouse.name}?"),
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
        final response = await _apiService.delete(
          "${ApiConstants.warehouses}${warehouse.tracker}/",
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          if (context.mounted) Navigator.pop(context, true);
        }
      } catch (e) {
        if (context.mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Details"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => CreateWarehouseForm(
                kDeepGreen: kDeepGreen,
                onSaved: () {
                  Navigator.pop(ctx); // Close sheet
                  Navigator.pop(context, true); // Return to list and refresh
                },
                existingWarehouse: warehouse,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.tag, "Tracker", warehouse.tracker),
            _infoRow(Icons.warehouse, "Name", warehouse.name),
            _infoRow(
              Icons.location_on,
              "Location",
              warehouse.location ?? "Not Set",
            ),
            _infoRow(
              Icons.speed,
              "Capacity",
              "${warehouse.capacity ?? 0} units",
            ),
            const Divider(),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(warehouse.description ?? "No description provided."),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => ListTile(
    leading: Icon(icon, color: kDeepGreen),
    title: Text(
      label,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    subtitle: Text(
      value,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
