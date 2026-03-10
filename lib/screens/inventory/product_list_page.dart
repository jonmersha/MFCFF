import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mfco/screens/inventory/product_details_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/inventory/product_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
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
      _productsFuture = _apiService.get(ApiConstants.products).then((data) =>
          (data as List).map((json) => Product.fromJson(json)).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Catalog"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No products found."));

          return LayoutBuilder(
            builder: (context, constraints) {
              // Responsive logic: 2 (mobile), 3 (tablet), 4/6 (desktop/landscape)
              int columns = 2;
              if (constraints.maxWidth > 1200) columns = 6;
              else if (constraints.maxWidth > 900) columns = 4;
              else if (constraints.maxWidth > 600) columns = 3;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
                    child: ProductGridCard(product: product, kDeepGreen: kDeepGreen),
                  );
                },
              );
            },
          );
        },
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kDeepGreen,
          icon: Icon(Icons.add, color: kGolden),
          label: const Text("CREATE PRODUCT", style: TextStyle(color: Colors.white)),
          onPressed: () {
            // Navigate to a new full-screen page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text("Create New Product")),
                  body: CreateProductForm(
                    kDeepGreen: kDeepGreen,
                    onSaved: () {
                      _refresh();        // Refresh list
                      Navigator.pop(context); // Close the full-screen form
                    },
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final Product product;
  final Color kDeepGreen;
  final PageController _controller = PageController();

  ProductGridCard({super.key, required this.product, required this.kDeepGreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: product.images.isEmpty ? 1 : product.images.length,
                  itemBuilder: (context, index) => product.images.isEmpty
                      ? const Center(child: Icon(Icons.image_not_supported, size: 40))
                      : CachedNetworkImage(
                    imageUrl: product.images[index].image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (ctx, url) => const Center(child: CircularProgressIndicator()),
                  ),
                ),
                if (product.images.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: product.images.length,
                      effect: WormEffect(activeDotColor: kDeepGreen, dotHeight: 6, dotWidth: 6),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("SKU: ${product.sku}", style: const TextStyle(fontSize: 11)),
                Text("\$${product.unitPrice}",
                    style: TextStyle(color: kDeepGreen, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}