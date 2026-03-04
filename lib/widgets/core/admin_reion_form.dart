import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../models/Core/admin_region_model.dart';

class CreateAdminRegionForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final AdminRegion? existingRegion; // If null, we create. If not null, we update.

  const CreateAdminRegionForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    this.existingRegion,
  });

  @override
  State<CreateAdminRegionForm> createState() => _CreateAdminRegionFormState();
}

class _CreateAdminRegionFormState extends State<CreateAdminRegionForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nameController;
  late String _selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if updating, otherwise defaults
    _nameController = TextEditingController(text: widget.existingRegion?.name ?? "");
    _selectedStatus = widget.existingRegion?.status ?? "active";
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final Map<String, dynamic> data = {
      "name": _nameController.text.trim(),
      "status": _selectedStatus,
    };

    try {
      final bool isUpdate = widget.existingRegion != null;
      final String url = isUpdate
          ? "${ApiConstants.regions}${widget.existingRegion!.tracker}/"
          : ApiConstants.regions;

      // 1. Execute call - response will be of type http.Response
      final http.Response response = isUpdate
          ? await _apiService.put(url, data)
          : await _apiService.post(url, data);

      // 2. Check the HTTP status code
      // Django returns 200 for OK (PUT) and 201 for Created (POST)
      if (response.statusCode == 200 || response.statusCode == 201) {
        _onSuccess();
      } else {
        // If server returns 400, 404, or 500
        _showSnackBar("Server Error: ${response.statusCode}", Colors.orange);
      }

    } catch (e) {
      if (mounted) {
        // toString() ensures we don't get a 'subtype of String' error here
        _showSnackBar("Connection Error: ${e.toString()}", Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onSuccess() {
    if (mounted) {
      _showSnackBar("Region saved successfully!", Colors.green);
      widget.onSaved(); // Triggers the refresh in parent
     // Navigator.pop(context, true);
    }
  }


  void _showSnackBar(dynamic message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.toString()), // Forces String conversion
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
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
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text(
                widget.existingRegion == null ? "Register New Region" : "Update Region Details",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Region Name (e.g. Oromia)", Icons.public),
                validator: (v) => v!.isEmpty ? "Please enter a name" : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: _inputDecoration("Operation Status", Icons.info_outline),
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
                  ),
                  onPressed: _isSaving ? null : _handleSave,
                  child: _isSaving
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                    widget.existingRegion == null ? "CREATE REGION" : "UPDATE REGION",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: widget.kDeepGreen),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: widget.kDeepGreen, width: 2)),
  );
}