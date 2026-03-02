// import 'package:flutter/material.dart';

// class WarehouseListPage extends StatefulWidget {
//   const WarehouseListPage({super.key});

//   @override
//   State<WarehouseListPage> createState() => _WarehouseListPageState();
// }

// class _WarehouseListPageState extends State<WarehouseListPage> {
//   final Color kDeepGreen = const Color(0xFF1B5E20);
//   final Color kGolden = const Color(0xFFFFC107);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Warehouse Setup"),
//         backgroundColor: kDeepGreen,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: 3,
//         itemBuilder: (context, index) {
//           return _buildWarehouseCard(
//             index == 0 ? "Main Silo Cluster" : "Finished Goods Depot",
//             index == 0 ? "RAW MATERIALS" : "FINISHED GOODS",
//             "Parent Factory: Milki Flour Mill A",
//             index == 0 ? Icons.shelves : Icons.inventory_2,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: kDeepGreen,
//         icon: Icon(Icons.add, color: kGolden),
//         label: const Text(
//           "ADD WAREHOUSE",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onPressed: () => _showCreateWarehouseSheet(context),
//       ),
//     );
//   }

//   Widget _buildWarehouseCard(
//     String name,
//     String type,
//     String factory,
//     IconData icon,
//   ) {
//     bool isRaw = type == "RAW MATERIALS";
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: isRaw ? kDeepGreen : kGolden, size: 30),
//         title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(factory, style: const TextStyle(fontSize: 12)),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: isRaw ? Colors.green.shade50 : Colors.amber.shade50,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 type,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: isRaw ? kDeepGreen : Colors.orange.shade900,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: const Icon(Icons.more_vert),
//         isThreeLine: true,
//       ),
//     );
//   }

//   void _showCreateWarehouseSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) => _CreateWarehouseForm(kDeepGreen: kDeepGreen),
//     );
//   }
// }

// class _CreateWarehouseForm extends StatefulWidget {
//   final Color kDeepGreen;
//   const _CreateWarehouseForm({required this.kDeepGreen});

//   @override
//   State<_CreateWarehouseForm> createState() => _CreateWarehouseFormState();
// }

// class _CreateWarehouseFormState extends State<_CreateWarehouseForm> {
//   String? selectedFactory;
//   String selectedType = "Raw Materials";

//   final List<String> factories = ["Milki Flour Mill A", "Milki Pasta Plant"];
//   final List<String> types = [
//     "Raw Materials",
//     "Work in Progress",
//     "Finished Goods",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         top: 20,
//         left: 20,
//         right: 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "New Warehouse Registration",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),

//           DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               labelText: "Select Parent Factory",
//               prefixIcon: Icon(Icons.factory, color: widget.kDeepGreen),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             items: factories
//                 .map((f) => DropdownMenuItem(value: f, child: Text(f)))
//                 .toList(),
//             onChanged: (val) => setState(() => selectedFactory = val),
//           ),

//           const SizedBox(height: 15),
//           _field("Warehouse Name (e.g., Silo 01)", Icons.warehouse),

//           const Text(
//             "Storage Category",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: types
//                 .map(
//                   (t) => ChoiceChip(
//                     label: Text(
//                       t,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: selectedType == t ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     selected: selectedType == t,
//                     selectedColor: widget.kDeepGreen,
//                     onSelected: (selected) {
//                       if (selected) setState(() => selectedType = t);
//                     },
//                   ),
//                 )
//                 .toList(),
//           ),

//           const SizedBox(height: 25),
//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: widget.kDeepGreen,
//               ),
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 "SAVE WAREHOUSE",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _field(String label, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: widget.kDeepGreen, size: 20),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mfco/models/inventory/warehouse_model.dart';
import 'package:mfco/widgets/core/create_warehouse_form.dart';
import 'package:mfco/widgets/core/warehouse_card.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);
  late Future<List<Warehouse>> _warehousesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _warehousesFuture = _apiService
          .get(ApiConstants.warehouses)
          .then(
            (data) =>
                (data as List).map((json) => Warehouse.fromJson(json)).toList(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Setup"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: FutureBuilder<List<Warehouse>>(
        future: _warehousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No Warehouses Found"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => WarehouseCard(
              warehouse: snapshot.data![index],
              kDeepGreen: kDeepGreen,
              onRefresh: _refreshData,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDeepGreen,
        icon: Icon(Icons.add, color: kGolden),
        label: const Text(
          "ADD WAREHOUSE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => CreateWarehouseForm(
            kDeepGreen: kDeepGreen,
            onSaved: _refreshData,
          ),
        ),
      ),
    );
  }
}
