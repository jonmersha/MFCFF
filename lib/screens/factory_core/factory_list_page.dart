import 'package:flutter/material.dart';
import '../../models/Core/factory_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/factory_core/factory_card.dart';
import '../../widgets/factory_core/create_factory_form.dart';

class FactoryListPage extends StatefulWidget {
  const FactoryListPage({super.key});

  @override
  State<FactoryListPage> createState() => _FactoryListPageState();
}

class _FactoryListPageState extends State<FactoryListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);
  late Future<List<Factory>> _factoriesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _factoriesFuture = _apiService
          .get(ApiConstants.factories)
          .then(
            (data) =>
                (data as List).map((json) => Factory.fromJson(json)).toList(),
          );
    });
  }

  void _showCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) =>
          CreateFactoryForm(kDeepGreen: kDeepGreen, onSaved: _refreshData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Factory Management"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: FutureBuilder<List<Factory>>(
        future: _factoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No factories found."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => FactoryCard(
              factory: snapshot.data![index],
              kDeepGreen: kDeepGreen,
              onRefresh: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDeepGreen,
        icon: Icon(Icons.add, color: kGolden),
        label: const Text(
          "ADD FACTORY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: _showCreateForm,
      ),
    );
  }
}
