import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../models/Core/city_model.dart';

class CreateCityForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final int adminRegionId; // The ID of the parent region
  final String regionName;
  final City? existingCity; // If null, we are in "Create" mode

  const CreateCityForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    required this.adminRegionId,
    required this.regionName,
    this.existingCity,
  });

  @override
  State<CreateCityForm> createState() => _CreateCityFormState();
}

class _CreateCityFormState extends State<CreateCityForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  String _selectedStatus = "active";
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers if we are editing
    _nameController = TextEditingController(text: widget.existingCity?.name ?? "");
    _descController = TextEditingController(text: widget.existingCity?.description ?? "");
    _selectedStatus = widget.existingCity?.status ?? "active";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Prepare payload
    final Map<String, dynamic> data = {
      "name": _nameController.text.trim(),
      "description": _descController.text.trim(),
      "admin_region": widget.adminRegionId, // Link to the parent region
      "status": _selectedStatus,
    };

    try {
      final response = widget.existingCity == null
          ? await _apiService.post(ApiConstants.cities, data)
          : await _apiService.put(
        "${ApiConstants.cities}${widget.existingCity!.tracker}/",
        data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.existingCity == null
                ? "City created successfully!"
                : "City updated successfully!")),
          );
          widget.onSaved();
        }
      } else {
        throw Exception("Server returned ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24, left: 24, right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Visual handle
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),

              Text(
                widget.existingCity == null ? "Register New City" : "Update City Info",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Region: ${widget.regionName}",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 25),

              _buildTextField(_nameController, "City Name", Icons.location_city, true),
              const SizedBox(height: 16),

              _buildTextField(_descController, "Description", Icons.description_outlined, false, maxLines: 3),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: _inputDecoration("Status", Icons.info_outline),
                items: const [
                  DropdownMenuItem(value: "active", child: Text("Active")),
                  DropdownMenuItem(value: "inactive", child: Text("Inactive")),
                ],
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.kDeepGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: _isSaving ? null : _handleSave,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    widget.existingCity == null ? "CREATE CITY" : "UPDATE CITY",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon),
      validator: isRequired ? (v) => v!.isEmpty ? "$label is required" : null : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: widget.kDeepGreen),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.kDeepGreen, width: 2)),
  );
}