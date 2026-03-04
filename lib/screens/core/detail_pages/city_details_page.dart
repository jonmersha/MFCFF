import 'package:flutter/material.dart';
import '../../../models/Core/city_model.dart';
import '../../../widgets/core/create_city_form.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class CityDetailsPage extends StatefulWidget {
  final City city;
  const CityDetailsPage({super.key, required this.city});

  @override
  State<CityDetailsPage> createState() => _CityDetailsPageState();
}

class _CityDetailsPageState extends State<CityDetailsPage> {
  final ApiService _apiService = ApiService();
  late City _currentCity;
   Color kDeepGreen = Color(0xFF1B5E20);

  @override
  void initState() {
    super.initState();
    _currentCity = widget.city;
  }

  // --- DELETE LOGIC ---
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete City"),
        content: Text("Are you sure you want to delete ${_currentCity.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () async {
              try {
                final response = await _apiService.delete(
                    "${ApiConstants.cities}${_currentCity.tracker}/"
                );
                if (response.statusCode == 204 || response.statusCode == 200) {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context, true); // return to region page and refresh
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- EDIT LOGIC ---
  void _showEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => CreateCityForm(
        kDeepGreen: kDeepGreen,
        adminRegionId: _currentCity.adminRegion,
        regionName: _currentCity.regionName,
        existingCity: _currentCity, // Pass the city here
        onSaved: () {
          Navigator.pop(context);
          // Note: In a real app, you'd fetch the updated city from backend here
          // For now, we return true to refresh the parent list
          Navigator.pop(context, true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCity.name),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.edit_note), onPressed: _showEditForm),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: _confirmDelete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem("City Name", _currentCity.name),
            _detailItem("Region", _currentCity.regionName),
            _detailItem("Tracker", _currentCity.tracker),
            _detailItem("Status", _currentCity.status),
            const SizedBox(height: 20),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_currentCity.description ?? "No description provided."),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}