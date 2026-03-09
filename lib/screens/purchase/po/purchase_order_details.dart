//
// import 'package:flutter/material.dart';
// import '../../../models/purchase/po/order_item_model.dart';
// import '../../../models/purchase/po/purchase_order_model.dart';
// import '../../../services/api_service.dart';
// import '../../../core/constants/api_constants.dart';
// import 'add_item.dart';
//
// class PODetailPage extends StatefulWidget {
//   final PurchaseOrder initialOrder;
//   final VoidCallback? onOrderUpdated;
//   final  bool showAppBar;
//
//   const PODetailPage({
//     super.key,
//     required this.initialOrder,
//     this.onOrderUpdated,
//     this.showAppBar=true
//   });
//
//   @override
//   State<PODetailPage> createState() => _PODetailPageState();
// }
//
// class _PODetailPageState extends State<PODetailPage> {
//   late PurchaseOrder _order;
//   bool _isRefreshing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _order = widget.initialOrder;
//   }
//
//   @override
//   void didUpdateWidget(covariant PODetailPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Syncs internal state if the parent rebuilds this widget with new data
//     if (widget.initialOrder != oldWidget.initialOrder) {
//       setState(() => _order = widget.initialOrder);
//     }
//   }
//
//   Future<void> _refreshOrder() async {
//     setState(() => _isRefreshing = true);
//     try {
//       final ApiService api = ApiService();
//       final data = await api.getUpdate("${ApiConstants.purchaseOrders}/${_order.id}");
//       if (!mounted) return;
//       setState(() {
//         _order = PurchaseOrder.fromJson(data);
//       });
//       widget.onOrderUpdated?.call(); // Refresh parent master list
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//       }
//     } finally {
//       if (mounted) setState(() => _isRefreshing = false);
//     }
//   }
//
//   void _addItem(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddItemToOrderPage(
//           orderId: _order.id,
//           supplierId: _order.supplier,
//           supplierName: _order.supplierName,
//           warehouseName: _order.warehouseName,
//           orderTracker: _order.tracker,
//         ),
//       ),
//     );
//
//     if (result == true) await _refreshOrder();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: widget.showAppBar
//           ? AppBar(title: Text("Order: ${_order.tracker}"))
//           : null,
//       body: _isRefreshing
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           _buildHeader(theme),
//           const Divider(height: 1),
//           Expanded(child: _buildItems(theme)),
//           _buildFooter(theme),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(ThemeData theme) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       color: theme.cardColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(_order.tracker, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.add),
//                 label: const Text("Add Item"),
//                 onPressed: () => _addItem(context),
//               )
//             ],
//           ),
//           const SizedBox(height: 16),
//           Wrap(spacing: 40, runSpacing: 12, children: [
//             _info("Supplier", _order.supplierName, theme),
//             _info("Warehouse", _order.warehouseName, theme),
//             _info("Order Date", _order.orderDate.toString().split(' ')[0], theme),
//             _info("Items", _order.items.length.toString(), theme),
//           ])
//         ],
//       ),
//     );
//   }
//
//   Widget _info(String label, String value, ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
//         Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
//       ],
//     );
//   }
//
//   Widget _buildItems(ThemeData theme) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _order.items.length + 1,
//       itemBuilder: (context, index) {
//         if (index == 0) return _tableHeader();
//         final item = _order.items[index - 1];
//         return _itemRow(item, theme);
//       },
//     );
//   }
//
//   Widget _tableHeader() => const Padding(
//     padding: EdgeInsets.only(bottom: 8),
//     child: Row(children: [
//       Expanded(flex: 4, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
//       Expanded(child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
//       Expanded(child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
//       Expanded(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
//       SizedBox(width: 40)
//     ]),
//   );
//
//   Widget _itemRow(PurchaseOrderItem item, ThemeData theme) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(children: [
//         Expanded(flex: 4, child: Text(item.productName)),
//         Expanded(child: Text(item.quantity.toString())),
//         Expanded(child: Text("\$${item.unitPrice.toStringAsFixed(2)}")),
//         Expanded(
//             child: Text("\$${item.lineTotal.toStringAsFixed(2)}",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor))
//         ),
//         IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
//       ]),
//     );
//   }
//
//   Widget _buildFooter(ThemeData theme) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(color: theme.cardColor, border: Border(top: BorderSide(color: theme.dividerColor))),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Text("Grand Total", style: theme.textTheme.titleLarge),
//         Text("\$${_order.totalAmount.toStringAsFixed(2)}",
//             style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
//       ]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mfco/screens/purchase/po/update_items.dart';
import '../../../models/purchase/po/order_item_model.dart';
import '../../../models/purchase/po/purchase_order_model.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import 'add_item.dart';
// Ensure this matches your file name

class PODetailPage extends StatefulWidget {
  final PurchaseOrder initialOrder;
  final VoidCallback? onOrderUpdated;
  final bool showAppBar;

  const PODetailPage({
    super.key,
    required this.initialOrder,
    this.onOrderUpdated,
    this.showAppBar = true,
  });

  @override
  State<PODetailPage> createState() => _PODetailPageState();
}

class _PODetailPageState extends State<PODetailPage> {
  late PurchaseOrder _order;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
  }

  @override
  void didUpdateWidget(covariant PODetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialOrder != oldWidget.initialOrder) {
      setState(() => _order = widget.initialOrder);
    }
  }

  Future<void> _refreshOrder() async {
    setState(() => _isRefreshing = true);
    try {
      final ApiService api = ApiService();
      final data = await api.getUpdate("${ApiConstants.purchaseOrders}/${_order.id}");
      if (!mounted) return;
      setState(() {
        _order = PurchaseOrder.fromJson(data);
      });
      widget.onOrderUpdated?.call();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  void _addItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddItemToOrderPage(
          orderId: _order.id,
          supplierId: _order.supplier,
          supplierName: _order.supplierName,
          warehouseName: _order.warehouseName,
          orderTracker: _order.tracker,
        ),
      ),
    );
    if (result == true) await _refreshOrder();
  }

  // Navigates to the edit/delete page for a specific item
  void _editItem(PurchaseOrderItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditItem(
          itemId: item.id,
          initialItem: item,
          supplierName: _order.supplierName,
          warehouseName: _order.warehouseName,
          orderTracker: _order.tracker,
        ),
      ),
    );
    if (result == true) await _refreshOrder();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text("Order: ${_order.tracker}")) : null,
      body: _isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
         _buildHeader(theme),
          const Divider(height: 1),
          Expanded(child: _buildItems(theme)),
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(_order.tracker, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(""),
                onPressed: () => _addItem(context),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 40, runSpacing: 12, children: [
            _info("Supplier", _order.supplierName, theme),
            _info("Warehouse", _order.warehouseName, theme),
            _info("Order Date", _order.orderDate.toString().split(' ')[0], theme),
            _info("Items", _order.items.length.toString(), theme),
          ])
        ],
      ),
    );
  }

  Widget _info(String label, String value, ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
      Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ],
  );

  Widget _buildItems(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _order.items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _tableHeader();
        return _itemRow(_order.items[index - 1], theme);
      },
    );
  }

  Widget _tableHeader() => const Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Expanded(flex: 4, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
      SizedBox(width: 40)
    ]),
  );

  Widget _itemRow(PurchaseOrderItem item, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(flex: 4, child: Text(item.productName)),
        Expanded(child: Text(item.quantity.toString())),
        Expanded(child: Text("\$${item.unitPrice.toStringAsFixed(2)}")),
        Expanded(child: Text("\$${item.lineTotal.toStringAsFixed(2)}",
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor))),
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () => _editItem(item), // Navigate to Edit Page
        ),
      ]),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: theme.cardColor, border: Border(top: BorderSide(color: theme.dividerColor))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Grand Total", style: theme.textTheme.titleLarge),
        Text("\$${_order.totalAmount.toStringAsFixed(2)}", style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold, color: theme.primaryColor)),
      ]),
    );
  }
}