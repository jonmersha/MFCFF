import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final int kg, stock;
  final double price;

  const ProductCard({
    super.key,
    required this.name,
    required this.kg,
    required this.price,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: "ETB ");
    bool isOutOfStock = stock <= 0;
    const Color kDeepGreen = Color(0xFF1B5E20);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.bakery_dining, color: kDeepGreen),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$kg kg unit | ${currencyFormat.format(price)}"),
            Text(
              isOutOfStock ? "Out of Stock" : "In Stock: $stock",
              style: TextStyle(
                color: isOutOfStock ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.add_circle,
            color: isOutOfStock ? Colors.grey : kDeepGreen,
          ),
          onPressed: isOutOfStock ? null : () {},
        ),
      ),
    );
  }
}
