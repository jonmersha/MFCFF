import 'package:flutter/material.dart';
import 'package:mfco/models/inventory/warehouse_model.dart';
import 'package:mfco/widgets/factory_core/create_warehouse_form.dart';
import 'package:mfco/widgets/factory_core/warehouse_card.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);
  late Future<List<Warehouse>> _warehousesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _warehousesFuture = _apiService
          .get(ApiConstants.warehouses)
          .then(
            (data) =>
                (data as List).map((json) => Warehouse.fromJson(json)).toList(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Setup"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: FutureBuilder<List<Warehouse>>(
        future: _warehousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No Warehouses Found"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => WarehouseCard(
              warehouse: snapshot.data![index],
              kDeepGreen: kDeepGreen,
              onRefresh: _refreshData,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDeepGreen,
        icon: Icon(Icons.add, color: kGolden),
        label: const Text(
          "ADD WAREHOUSE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => CreateWarehouseForm(
            kDeepGreen: kDeepGreen,
            onSaved: _refreshData,
          ),
        ),
      ),
    );
  }
}
