import 'package:flutter/material.dart';
import '../../models/Core/admin_region_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import 'detail_pages/admin_region_details_page.dart';
import '../../widgets/factory_core/admin_reion_form.dart';

class AdminRegionPage extends StatefulWidget {
  const AdminRegionPage({super.key});

  @override
  State<AdminRegionPage> createState() => _AdminRegionPageState();
}


class _AdminRegionPageState extends State<AdminRegionPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  List<AdminRegion> _regions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      final List<dynamic> data = await _apiService.get(ApiConstants.regions);
      if (mounted) {
        setState(() {
          _regions = data.map((json) => AdminRegion.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => CreateAdminRegionForm(
        kDeepGreen: kDeepGreen,
        onSaved: () {
          Navigator.pop(context);
          _fetchRegions(); // Refresh list after saving
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Administrative Regions"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRegions,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _regions.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _regions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final region = _regions[index];
          return _regionCard(region);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDeepGreen,
        onPressed: _showCreateForm,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _regionCard(AdminRegion region) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: kDeepGreen.withOpacity(0.1),
          child: Icon(Icons.map, color: kDeepGreen),
        ),
        title: Text(
          region.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text("Tracker: ${region.tracker}"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: region.status == "active" ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            region.status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: region.status == "active" ? Colors.green : Colors.red,
            ),
          ),
        ),
        onTap: () {
          // Navigate to Details Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminRegionDetailsPage(region: region),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No regions found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}