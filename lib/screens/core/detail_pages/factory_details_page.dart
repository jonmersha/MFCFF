import 'package:flutter/material.dart';
import '../../../models/Core/factory_model.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../widgets/core/create_factory_form.dart';

class FactoryDetailsPage extends StatefulWidget {
  final Factory factory;

  const FactoryDetailsPage({super.key, required this.factory});

  @override
  State<FactoryDetailsPage> createState() => _FactoryDetailsPageState();
}

class _FactoryDetailsPageState extends State<FactoryDetailsPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  // --- DELETE LOGIC ---
  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text(
          "Are you sure you want to remove ${widget.factory.name}?",
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
        // Using tracker for specific factory endpoint
        final response = await _apiService.delete(
          "${ApiConstants.factories}${widget.factory.tracker}/",
        );
        if (response.statusCode == 204 || response.statusCode == 200) {
          if (mounted) {
            Navigator.pop(
              context,
              true,
            ); // Pop with 'true' to trigger refresh on list
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Factory Deleted")));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- EDIT LOGIC ---
  void _showEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => CreateFactoryForm(
        kDeepGreen: kDeepGreen,
        onSaved: () => Navigator.pop(context, true), // Signal refresh
        existingFactory: widget.factory, // Pass existing data
      ),
    ).then((val) {
      if (val == true)
        Navigator.pop(context, true); // Propagate refresh to list page
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.factory;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Factory Details"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _showEditForm,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: kDeepGreen.withOpacity(0.1),
                child: Icon(Icons.factory, size: 40, color: kDeepGreen),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                f.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 40),

            _buildInfoTile(Icons.business, "Parent Company", f.companyName),
            _buildInfoTile(
              Icons.location_on,
              "City Location",
              "${f.cityName} (${f.cityName != null ? f.cityName : "Unknown"})",
            ),
            _buildInfoTile(
              Icons.speed,
              "Annual Capacity",
              "${f.capacity} Units",
            ),
            _buildInfoTile(
              Icons.check_circle_outline,
              "Status",
              f.status.toUpperCase(),
            ),

            const SizedBox(height: 20),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              f.description ?? "No description available.",
              style: const TextStyle(color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: kDeepGreen),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
