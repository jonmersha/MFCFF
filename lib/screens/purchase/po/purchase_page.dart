import 'package:flutter/material.dart';
import '../../../widgets/purchase/procurement_header.dart';
import '../../../widgets/purchase/intake_summary_ribbon.dart';
import '../../../widgets/purchase/po_tracking_card.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          const ProcurementHeader(),
          const SliverToBoxAdapter(child: IntakeSummaryRibbon()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader("Pending Grain Arrivals"),
                const POTrackingCard(
                  po: "PO-2026-001",
                  supplier: "Amhara Farmers Coop",
                  target: "Silo A",
                  qty: 25000,
                  status: "In Transit",
                ),
                const POTrackingCard(
                  po: "PO-2026-004",
                  supplier: "Global Grain Ltd",
                  target: "Silo B",
                  qty: 45000,
                  status: "At Gate",
                ),
                const SizedBox(height: 20),
                _buildSectionHeader("Recent Receipts (GRN)"),
                _buildRecentGRNTile(
                  "GRN-8821",
                  "Local Farm Union",
                  "20,000 kg",
                  "Passed QC",
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: kDeepGreen,
        ),
      ),
    );
  }

  Widget _buildRecentGRNTile(
    String grn,
    String supplier,
    String weight,
    String qc,
  ) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(grn, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("$supplier • $weight"),
      trailing: Text(
        qc,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
