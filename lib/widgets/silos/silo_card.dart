import 'package:flutter/material.dart';

class SiloCard extends StatelessWidget {
  final String siloId;
  final String grainType;
  final double percent; // 0.0 to 1.0
  final String weight;

  const SiloCard({
    super.key,
    required this.siloId,
    required this.grainType,
    required this.percent,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    const Color kDeepGreen = Color(0xFF1B5E20);
    const Color kGolden = Color(0xFFFFC107);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            siloId,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            grainType,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const Spacer(),
          // Level Indicator
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: percent > 0.8 ? Colors.red : kDeepGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                weight,
                style: const TextStyle(
                  color: Color(
                    0xFFB8860B,
                  ), // A deeper Dark Golden for readability on white
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
