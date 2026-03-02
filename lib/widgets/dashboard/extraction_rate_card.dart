import 'package:flutter/material.dart';

class ExtractionRateCard extends StatelessWidget {
  const ExtractionRateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "Current Extraction Rate",
            style: TextStyle(color: Colors.white70),
          ),
          const Text(
            "78.4%",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.78,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Target: 80.0%",
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
