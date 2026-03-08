import 'package:flutter/material.dart';
import '../../models/Core/admin_region_model.dart';
import '../../models/Core/city_model.dart';
import '../../models/Core/company_model.dart';
import '../../models/Core/factory_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreateFactoryForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final Factory? existingFactory;

  const CreateFactoryForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    this.existingFactory,
  });

  @override
  State<CreateFactoryForm> createState() => _CreateFactoryFormState();
}

class _CreateFactoryFormState extends State<CreateFactoryForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Company? _selectedCompany;
  City? _selectedCity;
  List<Company> _companies = [];
  List<City> _cities = [];

  bool _isFetching = true;
  bool _isSaving = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.existingFactory != null;
    if (_isEditMode) {
      _nameController.text = widget.existingFactory!.name;
      _capController.text = widget.existingFactory!.capacity.toString();
      _descController.text = widget.existingFactory!.description ?? "";
    }
    _fetchDependencies();
  }

  Future<void> _fetchDependencies() async {
    try {
      final results = await Future.wait([
        _apiService.get(ApiConstants.companies).catchError((e) => []),
        _apiService.get(ApiConstants.cities).catchError((e) => []),
      ]);

      if (mounted) {
        setState(() {
          _companies = (results[0] as List)
              .map((j) => Company.fromJson(j))
              .toList();
          _cities = (results[1] as List).map((j) => City.fromJson(j)).toList();

          // In Edit Mode, find the objects that match the existing IDs
          if (_isEditMode) {
            try {
              _selectedCompany = _companies.firstWhere(
                (c) => c.name == widget.existingFactory!.companyName,
              );
              _selectedCity = _cities.firstWhere(
                (c) => c.name == widget.existingFactory!.cityName,
              );
            } catch (e) {
              debugPrint("Could not pre-match dropdowns: $e");
            }
          }
          _isFetching = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCompany == null || _selectedCity == null) return;

    setState(() => _isSaving = true);

    final payload = {
      "name": _nameController.text.trim(),
      "company": _selectedCompany!.id, // Integer ID
      "city": _selectedCity!.id, // Integer ID
      "capacity": int.tryParse(_capController.text) ?? 0,
      "description": _descController.text.trim(),
      "status": "active",
    };

    try {
      final response = _isEditMode
          ? await _apiService.put(
              "${ApiConstants.factories}${widget.existingFactory!.tracker}/",
              payload,
            )
          : await _apiService.post(ApiConstants.factories, payload);

      if (response.statusCode == 201 || response.statusCode == 200) {
        widget.onSaved();
        if (mounted) Navigator.pop(context, true);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: _isFetching
          ? const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isEditMode ? "Update Factory" : "New Factory Setup",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Company Dropdown
                    DropdownButtonFormField<Company>(
                      value: _selectedCompany,
                      decoration: _inputStyle("Parent Company", Icons.business),
                      items: _companies
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.name)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCompany = val),
                      validator: (v) => v == null ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    // City Dropdown
                    DropdownButtonFormField<City>(
                      value: _selectedCity,
                      decoration: _inputStyle(
                        "Operational City",
                        Icons.location_city,
                      ),
                      items: _cities
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text("${c.name} (${c.regionName})"),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCity = val),
                      validator: (v) => v == null ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildField(_nameController, "Factory Name", Icons.factory),
                    _buildField(
                      _capController,
                      "Annual Capacity",
                      Icons.speed,
                      isNum: true,
                    ),
                    _buildField(
                      _descController,
                      "Description",
                      Icons.notes,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 32),
                    _buildSaveButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  // --- UI Helpers ---
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: widget.kDeepGreen, size: 22),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isNum = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: _inputStyle(label, icon),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.kDeepGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isSaving ? null : _handleSave,
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                _isEditMode ? "UPDATE FACTORY" : "REGISTER FACTORY",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
