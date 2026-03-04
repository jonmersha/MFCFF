// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'package:intl/intl.dart';

// class PurchasePage extends StatefulWidget {
//   @override
//   _PurchasePageState createState() => _PurchasePageState();
// }

// class _PurchasePageState extends State<PurchasePage> {
//   final ApiService api = ApiService();
//   final DateFormat dateFormat = DateFormat('MMM d, yyyy');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(),
//           SliverToBoxAdapter(child: _buildSummaryRibbon()),
//           SliverPadding(
//             padding: EdgeInsets.all(16),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 _buildSectionHeader("Pending Grain Arrivals"),
//                 _buildPOTrackingCard("PO-2026-001", "Amhara Farmers Coop", "Silo A", 25000, "In Transit"),
//                 _buildPOTrackingCard("PO-2026-004", "Global Grain Ltd", "Silo B", 45000, "At Gate"),
//                 SizedBox(height: 20),
//                 _buildSectionHeader("Recent Receipts (GRN)"),
//                 _buildRecentGRNTile("GRN-8821", "Local Farm Union", "20,000 kg", "Passed QC"),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120.0,
//       floating: false,
//       pinned: true,
//       backgroundColor: Color(0xFF5D4037),
//       flexibleSpace: FlexibleSpaceBar(
//         title: Text("Procurement & Intake", style: TextStyle(fontSize: 16)),
//         background: Container(color: Color(0xFF5D4037)),
//       ),
//       actions: [
//         IconButton(icon: Icon(Icons.history), onPressed: () {}),
//       ],
//     );
//   }

//   Widget _buildSummaryRibbon() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildStatItem("12", "Active POs"),
//           VerticalDivider(),
//           _buildStatItem("320.5 MT", "Exp. Wheat"),
//           VerticalDivider(),
//           _buildStatItem("4", "Trucks Today"),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String val, String label) {
//     return Column(
//       children: [
//         Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown)),
//         Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Widget _buildPOTrackingCard(String po, String supplier, String target, int qty, String status) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 0,
//       shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(po, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
//                   child: Text(status, style: TextStyle(color: Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: Icon(Icons.local_shipping, color: Colors.brown, size: 30),
//               title: Text(supplier, style: TextStyle(fontWeight: FontWeight.w600)),
//               subtitle: Text("Target: $target | Qty: $qty kg"),
//             ),
//             Divider(),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     child: Text("View Details"),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
//                     onPressed: () => _openReceiveGrainForm(context),
//                     child: Text("RECEIVE GRAIN", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown)),
//     );
//   }

//   Widget _buildRecentGRNTile(String grn, String supplier, String weight, String qc) {
//     return ListTile(
//       leading: Icon(Icons.check_circle, color: Colors.green),
//       title: Text(grn),
//       subtitle: Text("$supplier • $weight"),
//       trailing: Text(qc, style: TextStyle(color: Colors.grey, fontSize: 12)),
//     );
//   }

//   void _openReceiveGrainForm(BuildContext context) {
//     // Navigation to GRN Form
//   }
// }
import 'package:flutter/material.dart';
import '../../widgets/purchase/procurement_header.dart';
import '../../widgets/purchase/intake_summary_ribbon.dart';
import '../../widgets/purchase/po_tracking_card.dart';

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
