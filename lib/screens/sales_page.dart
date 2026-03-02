import 'package:flutter/material.dart';
import 'package:mfco/widgets/sales/customer_selector.dart';
import '../widgets/sales/sales_header.dart';
import '../widgets/sales/product_card.dart';
import '../widgets/sales/order_summary_footer.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final Color kDeepGreen = const Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SalesHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSectionLabel("Active Wholesalers"),
                const CustomerSelector(),
                const SizedBox(height: 20),
                _buildSectionLabel("Product Catalog"),
                const ProductCard(
                  name: "Super Premium Flour",
                  kg: 50,
                  price: 2850.0,
                  stock: 420,
                ),
                const ProductCard(
                  name: "Standard Bread Flour",
                  kg: 50,
                  price: 2600.0,
                  stock: 150,
                ),
                const ProductCard(
                  name: "Wheat Bran (Fine)",
                  kg: 25,
                  price: 850.0,
                  stock: 1200,
                ),
                const ProductCard(
                  name: "Industrial Semolina",
                  kg: 50,
                  price: 3100.0,
                  stock: 0,
                ),
              ],
            ),
          ),
          const OrderSummaryFooter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kDeepGreen,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
        onPressed: () => _openNewOrderModal(context),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  void _openNewOrderModal(BuildContext context) {
    // Logic for SalesOrder form
  }
}
