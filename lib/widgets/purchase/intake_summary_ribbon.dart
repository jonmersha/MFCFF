import 'package:flutter/material.dart';

class IntakeSummaryRibbon extends StatelessWidget {
  const IntakeSummaryRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("12", "Active POs"),
          const SizedBox(height: 30, child: VerticalDivider()),
          _buildStatItem("320.5 MT", "Exp. Wheat"),
          const SizedBox(height: 30, child: VerticalDivider()),
          _buildStatItem("4", "Trucks Today"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFFB8860B),
          ),
        ), // Dark Golden
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
