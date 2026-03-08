import 'package:flutter/material.dart';
import '../../../models/Core/admin_region_model.dart';
import '../../../models/Core/city_model.dart';
import 'city_details_page.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../widgets/factory_core/create_city_form.dart';
import '../../../widgets/factory_core/admin_reion_form.dart'; // Ensure correct spelling of your file

class AdminRegionDetailsPage extends StatefulWidget {
  final AdminRegion region;
  const AdminRegionDetailsPage({super.key, required this.region});


  @override
  State<AdminRegionDetailsPage> createState() => _AdminRegionDetailsPageState();
}

class _AdminRegionDetailsPageState extends State<AdminRegionDetailsPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  List<City> _cities = [];
  bool _isLoadingCities = true;
  late AdminRegion _currentRegion;

  @override
  void initState() {
    super.initState();
    _currentRegion = widget.region;
    _fetchCities();
  }

  // --- 1. FETCH CITIES ---
  Future<void> _fetchCities() async {
    setState(() => _isLoadingCities = true);
    try {
      final List<dynamic> data = await _apiService.get(
        "${ApiConstants.cities}?admin_region=${_currentRegion.id}",
      );
      if (mounted) {
        setState(() {
          _cities = data.map((json) => City.fromJson(json)).toList();
          _isLoadingCities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCities = false);
        _showSnackBar("Failed to load cities: $e", Colors.red);
      }
    }
  }

  // --- 2. EDIT REGION FUNCTION ---
  void _editRegion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => CreateAdminRegionForm(
        kDeepGreen: kDeepGreen,
        existingRegion: _currentRegion,
        onSaved: () {
          Navigator.pop(context);
          _refreshRegionDetails(); // Fetch fresh region data
        },
      ),
    );
  }

  // --- 3. REFRESH REGION DATA ---
  // If the name or status changed, we need the updated object from the backend
  Future<void> _refreshRegionDetails() async {
    try {
      final dynamic data = await _apiService.getUpdate(
        "${ApiConstants.regions}${_currentRegion.tracker}/",
      );
      if (mounted) {
        setState(() {
          _currentRegion = AdminRegion.fromJson(data);
        });
        _fetchCities(); // Also refresh the city list
      }
    } catch (e) {
      _showSnackBar("Update failed: $e", Colors.orange);
    }
  }

  // --- 4. ADD CITY FUNCTION ---
  void _addCity() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => CreateCityForm(
        kDeepGreen: kDeepGreen,
        adminRegionId: _currentRegion.id,
        regionName: _currentRegion.name,
        onSaved: () {
          Navigator.pop(context);
          _fetchCities();
        },
      ),
    );
  }

  // --- 5. DELETE REGION FUNCTION ---
  void _confirmDeleteRegion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${_currentRegion.name}? This may affect linked cities."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              try {
                await _apiService.delete("${ApiConstants.regions}${_currentRegion.tracker}/");
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return to list with "true" to trigger refresh
                }
              } catch (e) {
                _showSnackBar("Delete failed: $e", Colors.red);
              }
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildRegionHeaderCard()),
          SliverToBoxAdapter(child: _buildSectionTitle()),
          _isLoadingCities
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : _cities.isEmpty
              ? _buildEmptyCitiesState()
              : _buildCityList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCity,
        backgroundColor: kDeepGreen,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text("ADD CITY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- UI SUB-WIDGETS ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 150.0,
      pinned: true,
      backgroundColor: kDeepGreen,
      foregroundColor: Colors.white,
      actions: [
        IconButton(icon: const Icon(Icons.edit), onPressed: _editRegion),
        IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _confirmDeleteRegion),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(_currentRegion.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        background: Container(color: kDeepGreen.withOpacity(0.8)),
      ),
    );
  }

  Widget _buildRegionHeaderCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _infoRow(Icons.fingerprint, "Tracker ID", _currentRegion.tracker),
              const Divider(),
              _infoRow(Icons.check_circle, "Status", _currentRegion.status.toUpperCase(),
                  color: _currentRegion.status == 'active' ? Colors.green : Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text("$label: ", style: const TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black)),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text("Cities (${_cities.length})",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCityList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final city = _cities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.location_city, color: Colors.blueGrey),
                title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Tracker: ${city.tracker}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CityDetailsPage(city: city)),
                  );
                  if (result == true) _fetchCities();
                },
              ),
            );
          },
          childCount: _cities.length,
        ),
      ),
    );
  }

  Widget _buildEmptyCitiesState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 60, color: Colors.grey[300]),
            const Text("No cities registered in this region.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}