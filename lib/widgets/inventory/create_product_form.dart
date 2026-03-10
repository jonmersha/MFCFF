import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../../models/inventory/product_model.dart';
import '../../models/Core/company_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class CreateProductForm extends StatefulWidget {
  final Color kDeepGreen;
  final VoidCallback onSaved;
  final Product? existingProduct;

  const CreateProductForm({super.key, required this.kDeepGreen, required this.onSaved, this.existingProduct});

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _nameCtrl = TextEditingController(), _skuCtrl = TextEditingController(),
      _barcodeCtrl = TextEditingController(), _priceCtrl = TextEditingController(),
      _descCtrl = TextEditingController(), _minStockCtrl = TextEditingController();

  Company? _selectedCompany;
  String? _selectedUoM;
  List<Company> _companies = [];
  List<File> _selectedImages = [];
  bool _isLoading = true, _isSaving = false;

  final List<String> _uomList = ['kg', 'g', 'l', 'ml', 'pcs', 'box'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService().get(ApiConstants.companies);
      setState(() {
        _companies = (data as List).map((j) => Company.fromJson(j)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Prepare multipart request
      final request = await ApiService().createMultipartRequest('POST', ApiConstants.products);
      request.fields.addAll({
        'name': _nameCtrl.text,
        'sku': _skuCtrl.text,
        'barcode': _barcodeCtrl.text,
        'unit_price': _priceCtrl.text,
        'unit_of_measure': _selectedUoM ?? 'pcs',
        'min_stock_level': _minStockCtrl.text,
        'company': _selectedCompany!.id.toString(),
        'description': _descCtrl.text,
      });

      for (var img in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('images', img.path, filename: p.basename(img.path)));
      }

      final response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        widget.onSaved();
      } else {
        throw Exception("Failed to save product");
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Form(
      key: _formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;
        return isWide
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 1, child: _buildImageSection()),
          const VerticalDivider(),
          Expanded(flex: 2, child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _buildFormFields()))
        ])
            : ListView(padding: const EdgeInsets.all(16), children: [_buildImageSection(), _buildFormFields()]);
      }),
    );
  }

  Widget _buildImageSection() => Container(
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text("Camera")),
        OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo_library), label: const Text("Gallery")),
      ]),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: _selectedImages.length,
        itemBuilder: (ctx, i) => Stack(children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_selectedImages[i], fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
          Positioned(right: 0, child: IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => setState(() => _selectedImages.removeAt(i)))),
        ]),
      ),
    ]),
  );

  Widget _buildFormFields() => Column(children: [
    DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Company", border: OutlineInputBorder()),
      items: _companies.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
      onChanged: (v) => setState(() => _selectedCompany = _companies.firstWhere((c) => c.name == v)),
      validator: (v) => v == null ? "Required" : null,
    ),
    const SizedBox(height: 16),
    _textFld(_nameCtrl, "Product Name"),
    Row(children: [Expanded(child: _textFld(_skuCtrl, "SKU")), const SizedBox(width: 16), Expanded(child: _textFld(_barcodeCtrl, "Barcode"))]),
    Row(children: [Expanded(child: _textFld(_priceCtrl, "Price")), const SizedBox(width: 16), Expanded(child: _dropdown("UoM", _uomList, (v) => _selectedUoM = v))]),
    _textFld(_minStockCtrl, "Min Stock Level"),
    _textFld(_descCtrl, "Description", maxLines: 3),
    const SizedBox(height: 24),
    ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: widget.kDeepGreen),
      onPressed: _isSaving ? null : _submit, // Now correctly calls validated submit
      child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("SAVE PRODUCT", style: TextStyle(color: Colors.white)),
    ),
  ]);

  Widget _textFld(TextEditingController ctrl, String label, {int maxLines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
    ),
  );

  Widget _dropdown(String label, List<String> items, Function(String?) onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
    ),
  );

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) setState(() => _selectedImages.add(File(picked.path)));
  }
}