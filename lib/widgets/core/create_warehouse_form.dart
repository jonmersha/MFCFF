import 'package:flutter/material.dart';
import 'package:mfco/models/inventory/warehouse_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreateWarehouseForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final Warehouse? existingWarehouse;

  const CreateWarehouseForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    this.existingWarehouse,
  });

  @override
  State<CreateWarehouseForm> createState() => _CreateWarehouseFormState();
}

class _CreateWarehouseFormState extends State<CreateWarehouseForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locController = TextEditingController();
  final TextEditingController _capController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  List<dynamic> _factories = [];
  int? _selectedFactoryId;
  bool _isLoadingFactories = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 1. Initialize IDs if editing
    if (widget.existingWarehouse != null) {
      _nameController.text = widget.existingWarehouse!.name;
      _locController.text = widget.existingWarehouse!.location ?? "";
      _capController.text =
          widget.existingWarehouse!.capacity?.toString() ?? "";
      _descController.text = widget.existingWarehouse!.description ?? "";
      _selectedFactoryId = widget.existingWarehouse!.factoryId;
    }
    // 2. Fetch factories from backend
    _fetchFactories();
  }

  Future<void> _fetchFactories() async {
    try {
      final List<dynamic> data = await _apiService.get(ApiConstants.factories);
      if (mounted) {
        setState(() {
          _factories = data;

          // --- CRITICAL FIX FOR ASSERTION ERROR ---
          // Ensure the current ID exists in the fetched list. If not, reset it or pick the first.
          bool exists = _factories.any((f) => f['id'] == _selectedFactoryId);
          if (!exists) {
            _selectedFactoryId = _factories.isNotEmpty
                ? _factories[0]['id']
                : null;
          }

          _isLoadingFactories = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching factories: $e");
      if (mounted) setState(() => _isLoadingFactories = false);
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFactoryId == null) return;

    setState(() => _isSaving = true);

    // Data payload matches your backend's expected schema
    final data = {
      "name": _nameController.text.trim(),
      "location": _locController.text.trim(),
      "capacity": int.tryParse(_capController.text.trim()) ?? 0,
      "description": _descController.text.trim(),
      "factory": _selectedFactoryId, // Sending the factory ID (int)
      "status": widget.existingWarehouse?.status ?? "active",
    };

    try {
      final response = widget.existingWarehouse == null
          ? await _apiService.post(ApiConstants.warehouses, data)
          : await _apiService.put(
              "${ApiConstants.warehouses}${widget.existingWarehouse!.tracker}/",
              data,
            );

      if (response.statusCode == 201 || response.statusCode == 200) {
        widget.onSaved();
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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 24,
        left: 24,
        right: 24,
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
              Text(
                widget.existingWarehouse == null
                    ? "Register Warehouse"
                    : "Update Warehouse",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _field(_nameController, "Warehouse Name", Icons.warehouse),

              // --- DYNAMIC FACTORY DROPDOWN ---
              _isLoadingFactories
                  ? const LinearProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<int>(
                        value: _selectedFactoryId,
                        isExpanded: true,
                        decoration: _inputDecoration(
                          "Parent Factory",
                          Icons.factory,
                        ),
                        // Maps Factory JSON to Dropdown Items
                        items: _factories.map((f) {
                          return DropdownMenuItem<int>(
                            value: f['id'],
                            child: Text(f['name'] ?? 'Unnamed Factory'),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedFactoryId = val),
                        validator: (v) => v == null ? "Select a factory" : null,
                      ),
                    ),

              _field(_locController, "Location/City", Icons.map),
              _field(
                _capController,
                "Capacity (Units)",
                Icons.inventory_2,
                isNum: true,
              ),
              _field(_descController, "Description", Icons.notes, maxLines: 3),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
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
                      : const Text(
                          "SAVE WAREHOUSE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helpers
  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: widget.kDeepGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _field(
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
        decoration: _inputDecoration(label, icon),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }
}
