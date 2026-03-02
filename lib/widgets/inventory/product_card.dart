import 'package:flutter/material.dart';
import '../../models/inventory/product_model.dart';
import '../../screens/inventory/product_details_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color kDeepGreen;
  final VoidCallback onRefresh;

  const ProductCard({
    super.key,
    required this.product,
    required this.kDeepGreen,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: product),
            ),
          );
          if (result == true) onRefresh();
        },
        leading: CircleAvatar(
          backgroundColor: kDeepGreen.withOpacity(0.1),
          child: Icon(Icons.inventory_2_outlined, color: kDeepGreen),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Price: ${product.unitPrice} / ${product.unitOfMeasure}\nOwner: ${product.companyName}",
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        isThreeLine: true,
      ),
    );
  }
}
