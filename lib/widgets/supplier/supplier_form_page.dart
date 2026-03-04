import 'package:flutter/material.dart';
import '../../models/purchase/purchase.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart'; // Import constants

class SupplierFormPage extends StatefulWidget {
  final Supplier? existingSupplier;
  const SupplierFormPage({super.key, this.existingSupplier});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  String _status = "active";
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.existingSupplier;
    _nameController = TextEditingController(text: s?.name ?? "");
    _contactController = TextEditingController(text: s?.contactPerson ?? "");
    _phoneController = TextEditingController(text: s?.phone ?? "");
    _emailController = TextEditingController(text: s?.email ?? "");
    _addressController = TextEditingController(text: s?.address ?? "");
    _status = s?.status ?? "active";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    // Ensure keys match exactly what the Django Serializer expects
    final Map<String, dynamic> data = {
      "name": _nameController.text.trim(),
      "contact_person": _contactController.text.trim(),
      "phone": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "status": _status,
    };

    try {
      if (widget.existingSupplier == null) {
        // Use Constant: /purchase/suppliers/
        await _apiService.post(ApiConstants.suppliers, data);
      } else {
        // Use Constant + Tracker: /purchase/suppliers/TRACKER_ID/
        await _apiService.put(
            "${ApiConstants.suppliers}${widget.existingSupplier!.tracker}/",
            data
        );
      }

      if (mounted) {
        _showSnackBar("Supplier saved successfully", Colors.green);
        Navigator.pop(context, true); // Return true to trigger refresh in list
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        // Force toString() to avoid subtype errors
        _showSnackBar("Connection Error: ${e.toString()}", Colors.red);
      }
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingSupplier == null ? "New Supplier" : "Edit Supplier"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, "Company Name", Icons.business, isRequired: true),
              const SizedBox(height: 15),
              _buildTextField(_contactController, "Contact Person", Icons.person),
              const SizedBox(height: 15),
              _buildTextField(_phoneController, "Phone Number", Icons.phone, keyboard: TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextField(_emailController, "Email Address", Icons.email, keyboard: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildTextField(_addressController, "Office Address", Icons.location_on, maxLines: 2),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: "Status",
                  prefixIcon: Icon(Icons.info_outline, color: kDeepGreen),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "active", child: Text("Active")),
                  DropdownMenuItem(value: "inactive", child: Text("Inactive")),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDeepGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SAVE SUPPLIER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isRequired = false, TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kDeepGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: isRequired ? (v) => v!.isEmpty ? "$label is required" : null : null,
    );
  }
}