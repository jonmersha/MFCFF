// import 'package:flutter/material.dart';
// import '../../models/inventory/product_model.dart';
// import '../../models/Core/company_model.dart';
// import '../../services/api_service.dart';
// import '../../core/constants/api_constants.dart';

// class CreateProductForm extends StatefulWidget {
//   final Color kDeepGreen;
//   final VoidCallback onSaved;
//   final Product? existingProduct;

//   const CreateProductForm({
//     super.key,
//     required this.kDeepGreen,
//     required this.onSaved,
//     this.existingProduct,
//   });

//   @override
//   State<CreateProductForm> createState() => _CreateProductFormState();
// }

// class _CreateProductFormState extends State<CreateProductForm> {
//   final _formKey = GlobalKey<FormState>();
//   final ApiService _apiService = ApiService();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _uomController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();

//   Company? _selectedCompany;
//   List<Company> _companies = [];
//   bool _isLoading = true;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.existingProduct != null) {
//       _nameController.text = widget.existingProduct!.name;
//       _priceController.text = widget.existingProduct!.unitPrice.toString();
//       _uomController.text = widget.existingProduct!.unitOfMeasure;
//       _descController.text = widget.existingProduct!.description ?? "";
//     }
//     _fetchCompanies();
//   }

//   Future<void> _fetchCompanies() async {
//     try {
//       final data = await _apiService.get(ApiConstants.companies);
//       setState(() {
//         _companies = (data as List).map((j) => Company.fromJson(j)).toList();
//         if (widget.existingProduct != null) {
//           _selectedCompany = _companies.firstWhere(
//             (c) => c.id == widget.existingProduct!.companyId,
//           );
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate() || _selectedCompany == null) return;

//     setState(() => _isSaving = true);
//     final payload = {
//       "name": _nameController.text.trim(),
//       "unit_price": double.parse(_priceController.text),
//       "unit_of_measure": _uomController.text.trim(),
//       "company": _selectedCompany!.id,
//       "description": _descController.text.trim(),
//       "status": "active",
//     };

//     try {
//       final res = widget.existingProduct == null
//           ? await _apiService.post(ApiConstants.products, payload)
//           : await _apiService.put(
//               "${ApiConstants.products}${widget.existingProduct!.tracker}/",
//               payload,
//             );

//       if (res.statusCode == 200 || res.statusCode == 201) widget.onSaved();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         top: 24,
//         left: 24,
//         right: 24,
//       ),
//       child: _isLoading
//           ? const SizedBox(
//               height: 200,
//               child: Center(child: CircularProgressIndicator()),
//             )
//           : Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       widget.existingProduct == null
//                           ? "Register Product"
//                           : "Edit Product",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     DropdownButtonFormField<Company>(
//                       value: _selectedCompany,
//                       items: _companies
//                           .map(
//                             (c) =>
//                                 DropdownMenuItem(value: c, child: Text(c.name)),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => _selectedCompany = v),
//                       decoration: _inputStyle("Owner Company", Icons.business),
//                     ),
//                     const SizedBox(height: 15),
//                     _buildField(
//                       _nameController,
//                       "Product Name",
//                       Icons.inventory,
//                     ),
//                     _buildField(
//                       _priceController,
//                       "Unit Price",
//                       Icons.attach_money,
//                       isNum: true,
//                     ),
//                     _buildField(
//                       _uomController,
//                       "Unit of Measure (kg, pcs)",
//                       Icons.straighten,
//                     ),
//                     _buildField(
//                       _descController,
//                       "Description",
//                       Icons.notes,
//                       maxLines: 2,
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: widget.kDeepGreen,
//                         ),
//                         onPressed: _isSaving ? null : _submit,
//                         child: _isSaving
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const Text(
//                                 "SAVE PRODUCT",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   InputDecoration _inputStyle(String label, IconData icon) => InputDecoration(
//     labelText: label,
//     prefixIcon: Icon(icon, color: widget.kDeepGreen),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//   );

//   Widget _buildField(
//     TextEditingController c,
//     String l,
//     IconData i, {
//     bool isNum = false,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: c,
//         maxLines: maxLines,
//         keyboardType: isNum ? TextInputType.number : TextInputType.text,
//         decoration: _inputStyle(l, i),
//         validator: (v) => v!.isEmpty ? "Required" : null,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../models/inventory/product_model.dart';
import '../../models/Core/company_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreateProductForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final Product? existingProduct;

  const CreateProductForm({
    super.key,
    required this.kDeepGreen,
    required this.onSaved,
    this.existingProduct,
  });

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Company? _selectedCompany;
  String? _selectedUoM; // Matches Django UNIT_CHOICES keys
  List<Company> _companies = [];
  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, String>> _uomChoices = [
    {'value': 'kg', 'label': 'Kilogram'},
    {'value': 'g', 'label': 'Gram'},
    {'value': 'l', 'label': 'Liter'},
    {'value': 'ml', 'label': 'Milliliter'},
    {'value': 'pcs', 'label': 'Pieces'},
    {'value': 'box', 'label': 'Box'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      _nameController.text = widget.existingProduct!.name;
      _priceController.text = widget.existingProduct!.unitPrice.toString();
      _selectedUoM = widget.existingProduct!.unitOfMeasure;
      _descController.text = widget.existingProduct!.description ?? "";
    }
    _fetchDependencies();
  }

  Future<void> _fetchDependencies() async {
    try {
      final data = await _apiService.get(ApiConstants.companies);
      setState(() {
        _companies = (data as List).map((j) => Company.fromJson(j)).toList();
        if (widget.existingProduct != null) {
          _selectedCompany = _companies.firstWhere(
            (c) => c.id == widget.existingProduct!.companyId,
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedCompany == null ||
        _selectedUoM == null)
      return;

    setState(() => _isSaving = true);
    final payload = {
      "name": _nameController.text.trim(),
      "unit_price": double.parse(_priceController.text),
      "unit_of_measure": _selectedUoM, // Sending 'kg', 'pcs', etc.
      "company": _selectedCompany!.id,
      "description": _descController.text.trim(),
      "status": "active",
    };

    try {
      final res = widget.existingProduct == null
          ? await _apiService.post(ApiConstants.products, payload)
          : await _apiService.put(
              "${ApiConstants.products}${widget.existingProduct!.tracker}/",
              payload,
            );

      if (res.statusCode == 200 || res.statusCode == 201) {
        widget.onSaved();
        Navigator.pop(context);
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.existingProduct == null
                          ? "Register Product"
                          : "Edit Product",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Company Selector
                    DropdownButtonFormField<Company>(
                      value: _selectedCompany,
                      items: _companies
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.name)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCompany = v),
                      decoration: _inputStyle("Owner Company", Icons.business),
                      validator: (v) => v == null ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    // Unit of Measure Selector (The Backend Correction)
                    DropdownButtonFormField<String>(
                      value: _selectedUoM,
                      items: _uomChoices
                          .map(
                            (uom) => DropdownMenuItem(
                              value: uom['value'],
                              child: Text(uom['label']!),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedUoM = v),
                      decoration: _inputStyle("Unit of Measure", Icons.scale),
                      validator: (v) => v == null ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildField(
                      _nameController,
                      "Product Name",
                      Icons.inventory,
                    ),
                    _buildField(
                      _priceController,
                      "Unit Price (ETB)",
                      Icons.payments,
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

  InputDecoration _inputStyle(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: widget.kDeepGreen),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _buildField(
    TextEditingController c,
    String l,
    IconData i, {
    bool isNum = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: isNum
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: _inputStyle(l, i),
        validator: (v) => v!.isEmpty ? "Required" : null,
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
        onPressed: _isSaving ? null : _submit,
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "SAVE PRODUCT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
