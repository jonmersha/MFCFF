// // import 'package:flutter/material.dart';
// // import 'package:mfco/screens/purchase/po/purchase_order_details.dart';
// // import '../../../models/purchase/po/purchase_order_model.dart';
// // import '../../../services/api_service.dart';
// // import '../../../core/constants/api_constants.dart';
// // import 'purchase_order_creation.dart';
// //
// // class PurchaseOrderListPage extends StatefulWidget {
// //   const PurchaseOrderListPage({super.key});
// //
// //   @override
// //   State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
// // }
// //
// // class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
// //
// //   final ApiService _apiService = ApiService();
// //
// //   List<PurchaseOrder> _orders = [];
// //   PurchaseOrder? _selectedOrder;
// //
// //   bool _isLoading = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchOrders();
// //   }
// //
// //   Future<void> _fetchOrders() async {
// //
// //     try {
// //
// //       final List<dynamic> data =
// //       await _apiService.get(ApiConstants.purchaseOrders);
// //
// //       if (!mounted) return;
// //
// //       setState(() {
// //
// //         _orders = data.map((e) => PurchaseOrder.fromJson(e)).toList();
// //
// //         if (_orders.isNotEmpty && _selectedOrder == null) {
// //           _selectedOrder = _orders.first;
// //         }
// //
// //         _isLoading = false;
// //       });
// //
// //     } catch (e) {
// //
// //       if (!mounted) return;
// //
// //       setState(() => _isLoading = false);
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error loading orders: $e")),
// //       );
// //     }
// //   }
// //
// //   Future<void> _createOrder() async {
// //
// //     final result = await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const CreatePurchaseOrderPage(),
// //       ),
// //     );
// //
// //     if (result == true) {
// //       _fetchOrders();
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return OrientationBuilder(
// //       builder: (context, orientation) {
// //
// //         final isLandscape = orientation == Orientation.landscape;
// //
// //         return Scaffold(
// //
// //           appBar: AppBar(
// //             title: const Text("Purchase Management"),
// //
// //             /// ADD BUTTON MOVED TO APP BAR
// //             actions: [
// //               IconButton(
// //                 icon: const Icon(Icons.add),
// //                 tooltip: "Create Purchase Order",
// //                 onPressed: _createOrder,
// //               ),
// //             ],
// //           ),
// //
// //           body: _isLoading
// //               ? const Center(child: CircularProgressIndicator())
// //               : isLandscape
// //               ? _buildMasterDetail()
// //               : _buildListOnly(),
// //         );
// //       },
// //     );
// //   }
// //
// //   /// LANDSCAPE → MASTER DETAIL
// //   Widget _buildMasterDetail() {
// //
// //     return Row(
// //       children: [
// //
// //         Container(
// //           width: 350,
// //           decoration: BoxDecoration(
// //             border: Border(
// //               right: BorderSide(color: Colors.grey.shade300),
// //             ),
// //           ),
// //           child: _buildOrderList(isMasterDetail: true),
// //         ),
// //
// //         Expanded(
// //           child: _selectedOrder == null
// //               ? const Center(child: Text("Select an order"))
// //               : PODetailPage(order: _selectedOrder!),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// PORTRAIT → LIST ONLY
// //   Widget _buildListOnly() {
// //     return _buildOrderList(isMasterDetail: false);
// //   }
// //
// //   Widget _buildOrderList({required bool isMasterDetail}) {
// //
// //     return RefreshIndicator(
// //       onRefresh: _fetchOrders,
// //       child: ListView.builder(
// //         itemCount: _orders.length,
// //         itemBuilder: (context, index) {
// //
// //           final order = _orders[index];
// //           final selected = _selectedOrder?.id == order.id;
// //
// //           return ListTile(
// //
// //             selected: isMasterDetail ? selected : false,
// //
// //             title: Text(
// //               order.tracker,
// //               style: const TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //
// //             subtitle: Text(order.supplierName),
// //
// //             trailing: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Text(order.status),
// //                 Text(
// //                   "\$${order.totalAmount.toStringAsFixed(2)}",
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //               ],
// //             ),
// //
// //             onTap: () {
// //
// //               if (isMasterDetail) {
// //
// //                 setState(() {
// //                   _selectedOrder = order;
// //                 });
// //
// //               } else {
// //
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (_) => PODetailPage(order: order),
// //                   ),
// //                 );
// //
// //               }
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:mfco/screens/purchase/po/purchase_order_details.dart';
// import '../../../models/purchase/po/purchase_order_model.dart';
// import '../../../services/api_service.dart';
// import '../../../core/constants/api_constants.dart';
// import 'purchase_order_creation.dart';
//
// class PurchaseOrderListPage extends StatefulWidget {
//   const PurchaseOrderListPage({super.key});
//
//   @override
//   State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
// }
//
// class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
//   final ApiService _apiService = ApiService();
//   List<PurchaseOrder> _orders = [];
//   PurchaseOrder? _selectedOrder;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }
//
//   Future<void> _fetchOrders() async {
//     try {
//       final List<dynamic> data = await _apiService.get(ApiConstants.purchaseOrders);
//       if (!mounted) return;
//       setState(() {
//         _orders = data.map((e) => PurchaseOrder.fromJson(e)).toList();
//         if (_orders.isNotEmpty && _selectedOrder == null) {
//           _selectedOrder = _orders.first;
//         }
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         final isLandscape = orientation == Orientation.landscape;
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Purchase Management"),
//             actions: [
//               IconButton(icon: const Icon(Icons.add), onPressed: _createOrder),
//             ],
//           ),
//           body: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : isLandscape ? _buildMasterDetail() : _buildListOnly(),
//         );
//       },
//     );
//   }
//
//   Widget _buildMasterDetail() {
//     return Row(
//       children: [
//         SizedBox(width: 350, child: _buildOrderList(isMasterDetail: true)),
//         Expanded(
//           child: _selectedOrder == null
//               ? const Center(child: Text("Select an order to view details"))
//               : PODetailPage(order: _selectedOrder!),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildListOnly() => _buildOrderList(isMasterDetail: false);
//
//   Widget _buildOrderList({required bool isMasterDetail}) {
//     final theme = Theme.of(context);
//     return RefreshIndicator(
//       onRefresh: _fetchOrders,
//       child: ListView.separated(
//         separatorBuilder: (_, __) => const Divider(height: 1),
//         itemCount: _orders.length,
//         itemBuilder: (context, index) {
//           final order = _orders[index];
//           final isSelected = isMasterDetail && _selectedOrder?.id == order.id;
//
//           return ListTile(
//             selected: isSelected,
//             selectedTileColor: theme.primaryColor.withOpacity(0.1),
//             selectedColor: theme.primaryColor,
//             leading: CircleAvatar(
//               backgroundColor: isSelected ? theme.primaryColor : Colors.grey.shade200,
//               child: Icon(Icons.inventory_2, color: isSelected ? Colors.white : theme.primaryColor, size: 18),
//             ),
//             title: Text(order.tracker, style: const TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(order.supplierName),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                   _buildStatusBadge(order.status, theme),
//                   Text("\$${order.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             onTap: () {
//               if (isMasterDetail) {
//                 setState(() => _selectedOrder = order);
//               } else {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => PODetailPage(order: order)));
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String status, ThemeData theme) {
//     Color col = status == 'Completed' ? theme.primaryColor : Colors.orange;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(color: col.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
//       child: Text(status, style: TextStyle(fontSize: 10, color: col, fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Future<void> _createOrder() async {
//     final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePurchaseOrderPage()));
//     if (result == true) _fetchOrders();
//   }
// }

import 'package:flutter/material.dart';
import 'package:mfco/screens/purchase/po/purchase_order_creation.dart';
import 'package:mfco/screens/purchase/po/purchase_order_details.dart';

import '../../../core/constants/api_constants.dart';
import '../../../models/purchase/po/purchase_order_model.dart';
import '../../../services/api_service.dart';
import '../../../widgets/purchase/po_list_widget.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  final ApiService _apiService = ApiService();
  List<PurchaseOrder> _orders = [];
  PurchaseOrder? _selectedOrder;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final List<dynamic> data = await _apiService.get(ApiConstants.purchaseOrders);
      if (!mounted) return;
      setState(() {
        _orders = data.map((e) => PurchaseOrder.fromJson(e)).toList();
        if (_orders.isNotEmpty && _selectedOrder == null) {
          _selectedOrder = _orders.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Purchase Management"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreatePurchaseOrderPage())
                  );
                  if (result == true) _fetchOrders();
                },
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : isLandscape
              ? _buildMasterDetail()
              : POListView(
            orders: _orders,
            onRefresh: _fetchOrders,
            onOrderSelected: (order) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PODetailPage(order: order))
            ),
          ),
        );
      },
    );
  }

  Widget _buildMasterDetail() {
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: POListView(
            orders: _orders,
            selectedOrderId: _selectedOrder?.id,
            onRefresh: _fetchOrders,
            isMasterDetail: true,
            onOrderSelected: (order) => setState(() => _selectedOrder = order),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedOrder == null
              ? const Center(child: Text("Select an order to view details"))
              : PODetailPage(order: _selectedOrder!),
        ),
      ],
    );
  }
}