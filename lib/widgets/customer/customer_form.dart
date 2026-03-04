import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../models/sales/customer_model.dart';
import '../../services/api_service.dart';
//
class CustomerFormPage extends StatefulWidget {
  final Customer? existingCustomer;
  const CustomerFormPage({super.key, this.existingCustomer});

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  String _status = "active";
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.existingCustomer;
    _nameController = TextEditingController(text: c?.name ?? "");
    _phoneController = TextEditingController(text: c?.phone ?? "");
    _emailController = TextEditingController(text: c?.email ?? "");
    _addressController = TextEditingController(text: c?.address ?? "");
    _status = c?.status ?? "active";
  }

  // Future<void> _save() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() => _isSaving = true);
  //
  //   final data = {
  //     "name": _nameController.text.trim(),
  //     "phone": _phoneController.text.trim(),
  //     "email": _emailController.text.trim(),
  //     "address": _addressController.text.trim(),
  //     "status": _status,
  //   };
  //
  //   try {
  //     if (widget.existingCustomer == null) {
  //       await _apiService.post(ApiConstants.customers, data);
  //     } else {
  //       await _apiService.put("${ApiConstants.customers}${widget.existingCustomer!.tracker}/", data);
  //     }
  //     if (mounted) Navigator.pop(context, true);
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() => _isSaving = false);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  //     }
  //   }
  // }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    // Adjusted keys for Customer (Removed contact_person as per your curl example)
    final Map<String, dynamic> data = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "status": _status,
    };

    try {
      if (widget.existingCustomer == null) {
        // Use Customer Constant: /sales/customers/
        await _apiService.post(ApiConstants.customers, data);
      } else {
        // Use Customer Constant + Tracker: /sales/customers/CUS-XXXX/
        await _apiService.put(
            "${ApiConstants.customers}${widget.existingCustomer!.tracker}/",
            data
        );
      }

      if (mounted) {
        _showSnackBar("Customer saved successfully", Colors.green);
        Navigator.pop(context, true); // Triggers refresh in the List/Details page
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        // Force toString() to prevent the "subtype of String" crash
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
      appBar: AppBar(title: Text(widget.existingCustomer == null ? "Register Customer" : "Update Customer")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? "Required" : null),
              const SizedBox(height: 15),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()), keyboardType: TextInputType.phone),
              const SizedBox(height: 15),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email Address", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder()), maxLines: 2),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [DropdownMenuItem(value: "active", child: Text("Active")), DropdownMenuItem(value: "inactive", child: Text("Inactive"))],
                onChanged: (val) => setState(() => _status = val!),
                decoration: const InputDecoration(labelText: "Status", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("SAVE CUSTOMER", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}