import 'package:flutter/material.dart';
import 'package:mfco/models/Core/company_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreateCompanyForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final Company? existingCompany;

  const CreateCompanyForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    this.existingCompany,
  });

  @override
  State<CreateCompanyForm> createState() => _CreateCompanyFormState();
}

class _CreateCompanyFormState extends State<CreateCompanyForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int? _selectedCityId;
  List<dynamic> _cities = [];
  bool _isLoadingCities = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCities();

    // Pre-fill fields if editing
    if (widget.existingCompany != null) {
      _nameController.text = widget.existingCompany!.name;
      _descController.text = widget.existingCompany!.description ?? "";
      _selectedCityId = widget.existingCompany!.city; // Set existing city ID
    }
  }

  // Uses your generic get method to populate the dropdown
  Future<void> _fetchCities() async {
    try {
      final data = await _apiService.get(ApiConstants.cities);
      if (mounted) {
        setState(() {
          _cities = data;
          _isLoadingCities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCities = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error fetching cities")));
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final payload = {
      "name": _nameController.text.trim(),
      "description": _descController.text.trim(),
      "city": _selectedCityId, // Sending the ID to Django
      "status": "active",
    };

    try {
      final response = widget.existingCompany != null
          ? await _apiService.put(
              "${ApiConstants.companies}${widget.existingCompany!.tracker}/",
              payload,
            )
          : await _apiService.post(ApiConstants.companies, payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        widget.onSaved();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.existingCompany != null
                    ? "Edit Company"
                    : "Register Company",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: _inputStyle("Name", Icons.business),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // --- DYNAMIC CITY DROPDOWN ---
              _isLoadingCities
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      value: _selectedCityId,
                      decoration: _inputStyle("City", Icons.location_city),
                      items: _cities.map((city) {
                        return DropdownMenuItem<int>(
                          value: city['id'], // The backend PK
                          child: Text(city['name']), // Displayed name
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCityId = val),
                      validator: (v) => v == null ? "Select a city" : null,
                    ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputStyle("Description", Icons.notes),
              ),
              const SizedBox(height: 24),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: widget.kDeepGreen),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: widget.kDeepGreen),
        onPressed: _isSaving ? null : _handleSave,
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("SAVE", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
