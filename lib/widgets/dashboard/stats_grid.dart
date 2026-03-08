import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GridView.count(
      // 4 columns for landscape, 2 for portrait
      crossAxisCount: isLandscape ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      // Adjust ratio so cards don't look too tall in landscape
      childAspectRatio: isLandscape ? 1.8 : 1.5,
      children: const [
        StatCard("Daily Sales", "42,500", Icons.trending_up, Colors.green),
        StatCard("Pending POs", "12", Icons.hourglass_empty, Colors.orange),
        StatCard("Active Silos", "08", Icons.storage, Color(0xFF1B5E20)),
        StatCard("Staff On-duty", "24", Icons.people, Colors.blue),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const StatCard(this.title, this.value, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isLandscape ? 24 : 28), // Slightly smaller icons in landscape
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
                fontSize: isLandscape ? 16 : 18,
                fontWeight: FontWeight.bold
            ),
          ),
          Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey)
          ),
        ],
      ),
    );
  }
}