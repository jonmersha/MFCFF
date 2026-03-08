import 'package:flutter/material.dart';
import 'package:mfco/widgets/dashboard/extraction_rate_card.dart';
import 'package:mfco/widgets/dashboard/movement_summary.dart';
import 'package:mfco/widgets/dashboard/stats_grid.dart';
import 'package:mfco/widgets/dashboard/welcome_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final Color kDeepGreen = const Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          // Logic to reload data from API
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeHeader(),
              const SizedBox(height: 20),
              const StatsGrid(),
              const SizedBox(height: 25),
              const Text(
                "Production Efficiency",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ExtractionRateCard(),
              const SizedBox(height: 25),
              const Text(
                "Recent Stock Movements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const MovementSummary(),
            ],
          ),
        ),
      ),
    );
  }
}
