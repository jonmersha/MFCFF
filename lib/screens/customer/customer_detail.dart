import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/sales/customer_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/customer/customer_form.dart';

class CustomerDetailsPage extends StatefulWidget {
  final Customer customer;
  const CustomerDetailsPage({super.key, required this.customer});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final ApiService _apiService = ApiService();
  late Customer _currentCustomer;
  bool _isRefreshing = false;
  final Color kDeepGreen = const Color(0xFF1B5E20);

  @override
  void initState() {
    super.initState();
    _currentCustomer = widget.customer;
  }

  Future<void> _refreshCustomerData() async {
    setState(() => _isRefreshing = true);
    try {
      final String endpoint = "${ApiConstants.customers}${_currentCustomer.tracker}/";

      // 1. Fetch data - This currently returns an http.Response based on your ApiService
      final dynamic response = await _apiService.getUpdate(endpoint);

      // 2. Check if it's a Response and decode it
      if (response is http.Response) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (mounted) {
            setState(() {
              _currentCustomer = Customer.fromJson(responseData);
              _isRefreshing = false;
            });
          }
        } else {
          throw Exception("Server returned code: ${response.statusCode}");
        }
      }
      // If your ApiService ALREADY decodes it (unlikely given your put method)
      else if (response is Map<String, dynamic>) {
        setState(() {
          _currentCustomer = Customer.fromJson(response);
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print(e.toString());
        setState(() => _isRefreshing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Refresh failed: ${e.toString()}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  void _onEditPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormPage(existingCustomer: _currentCustomer),
      ),
    );

    // If the form returns 'true', it means the user saved changes
    if (result == true) {
      _refreshCustomerData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            )
          else
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshCustomerData),
          IconButton(icon: const Icon(Icons.edit), onPressed: _onEditPressed),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: kDeepGreen.withOpacity(0.1),
            child: Icon(Icons.person, size: 50, color: kDeepGreen),
          ),
          const SizedBox(height: 12),
          Text(_currentCustomer.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(_currentCustomer.tracker, style: const TextStyle(color: Colors.grey, letterSpacing: 1.1)),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(Icons.phone, "Phone", _currentCustomer.phone),
            const Divider(),
            _buildDetailRow(Icons.email, "Email", _currentCustomer.email),
            const Divider(),
            _buildDetailRow(Icons.location_on, "Address", _currentCustomer.address),
            const Divider(),
            _buildDetailRow(Icons.info, "Status", _currentCustomer.status.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: kDeepGreen, size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value.isNotEmpty ? value : "Not provided", style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}