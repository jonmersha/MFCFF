import 'package:flutter/material.dart';
import '../../models/sales/customer_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/customer/customer_form.dart';
import 'customer_detail.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);

  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.get(ApiConstants.customers);
      if (mounted) {
        setState(() {
          _customers = (data as List).map((json) => Customer.fromJson(json)).toList();
          _filteredCustomers = _customers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar("Error: ${e.toString()}", Colors.red);
      }
    }
  }

  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers = _customers
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()) ||
          c.tracker.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Search Customer...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white70)),
          onChanged: _filterCustomers,
        )
            : const Text("Customer Directory"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _filteredCustomers = _customers;
            }),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchCustomers,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _filteredCustomers.length,
          itemBuilder: (context, index) {
            final customer = _filteredCustomers[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue[50], child: Icon(Icons.person, color: kDeepGreen)),
                title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(customer.phone),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerDetailsPage(customer: customer))
                ).then((_) => _fetchCustomers()),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerFormPage())).then((_) => _fetchCustomers()),
        backgroundColor: kDeepGreen,
        label: const Text("NEW CUSTOMER", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
