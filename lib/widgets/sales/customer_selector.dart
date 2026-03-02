import 'package:flutter/material.dart';

class CustomerSelector extends StatelessWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kDeepGreen = Color(0xFF1B5E20);

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCustomerAvatar("B", "Bole Bakery", kDeepGreen),
          _buildCustomerAvatar("U", "Union Coop", kDeepGreen),
          _buildCustomerAvatar("M", "Merkato Dist.", kDeepGreen),
          _buildCustomerAvatar("A", "Abyssinia", kDeepGreen),
          _buildCustomerAvatar("S", "Sheger Bread", kDeepGreen),

          // Action button to add new wholesaler
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.add, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Add New",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAvatar(String initial, String label, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: themeColor.withOpacity(0.1),
            child: Text(
              initial,
              style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
