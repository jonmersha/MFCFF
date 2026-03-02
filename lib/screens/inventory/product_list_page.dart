// import 'package:flutter/material.dart';

// class ProductListPage extends StatelessWidget {
//   const ProductListPage({super.key});

//   final Color kDeepGreen = const Color(0xFF1B5E20);
//   final Color kGolden = const Color(0xFFFFC107);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Catalog"),
//         backgroundColor: kDeepGreen,
//         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 5, // Replace with dynamic list from API
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               side: BorderSide(color: Colors.grey.shade200),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               leading: Icon(Icons.category, color: kDeepGreen),
//               title: const Text(
//                 "Premium Wheat Flour",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: const Text(
//                 "SKU: MFC-FL-001 | Category: Finished Goods",
//               ),
//               trailing: const Icon(Icons.edit_outlined, size: 20),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: kDeepGreen,
//         icon: Icon(
//           Icons.add,
//           color: kGolden,
//         ), // Golden icon for the primary action
//         label: const Text(
//           "CREATE PRODUCT",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onPressed: () => _showCreateForm(context),
//       ),
//     );
//   }

//   void _showCreateForm(BuildContext context) {
//     // Logic to open a BottomSheet or Dialog with TextFormFields for
//     // Name, SKU, Category, and Unit of Measure.
//   }
// }

import 'package:flutter/material.dart';
import '../../models/inventory/product_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/inventory/product_card.dart';
import '../../widgets/inventory/create_product_form.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _productsFuture = _apiService
          .get(ApiConstants.products)
          .then(
            (data) =>
                (data as List).map((json) => Product.fromJson(json)).toList(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Catalog"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No products found."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ProductCard(
              product: snapshot.data![index],
              kDeepGreen: kDeepGreen,
              onRefresh: _refresh,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDeepGreen,
        icon: Icon(Icons.add, color: kGolden),
        label: const Text(
          "CREATE PRODUCT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) =>
              CreateProductForm(kDeepGreen: kDeepGreen, onSaved: _refresh),
        ),
      ),
    );
  }
}
