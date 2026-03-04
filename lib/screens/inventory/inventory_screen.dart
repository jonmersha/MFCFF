import 'package:flutter/material.dart';
import '../../widgets/silos/silo_card.dart'; // Ensure this path is correct

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Silo Management",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kDeepGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // FIXED: Wrapped the list in a Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryHeader(),
            const SizedBox(height: 20),
            const Text(
              "Storage Units",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return SiloCard(
                  siloId: "SILO-0${index + 1}",
                  grainType: index < 2 ? "Hard Wheat" : "Premium Flour",
                  percent: 0.25 * (index + 1),
                  weight: "${(index + 1) * 120} MT",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kDeepGreen,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: kDeepGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Wheat On-Hand",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            "1,240.5 MT",
            style: TextStyle(
              color: kGolden, // Secondary Golden Color
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
