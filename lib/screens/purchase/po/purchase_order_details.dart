// import 'package:flutter/material.dart';
// import '../../../models/purchase/po/order_item_model.dart';
// import '../../../models/purchase/po/purchase_order_model.dart';
//
// class PODetailPage extends StatelessWidget {
//   final PurchaseOrder order;
//
//   const PODetailPage({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//
//     return Column(
//       children: [
//
//         /// HEADER
//         _buildHeader(theme),
//
//         const Divider(height: 1),
//
//         /// ITEMS
//         Expanded(
//           child: _buildItems(theme),
//         ),
//
//         /// FOOTER
//         _buildFooter(theme),
//       ],
//     );
//   }
//
//   Widget _buildHeader(ThemeData theme) {
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       color: theme.cardColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           /// ORDER NUMBER + STATUS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 order.tracker,
//                 style: theme.textTheme.headlineSmall
//                     ?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               _statusBadge(order.status)
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           /// INFO GRID
//           Wrap(
//             spacing: 40,
//             runSpacing: 12,
//             children: [
//               _info("Supplier", order.supplierName, theme),
//               _info("Warehouse", order.warehouseName, theme),
//               _info("Order Date",
//                   order.orderDate.toString().split(' ')[0], theme),
//               _info("Items", order.itemCount.toString(), theme),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _info(String label, String value, ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: theme.textTheme.bodySmall
//                 ?.copyWith(color: Colors.grey)),
//         const SizedBox(height: 2),
//         Text(value,
//             style: theme.textTheme.bodyLarge
//                 ?.copyWith(fontWeight: FontWeight.w600)),
//       ],
//     );
//   }
//
//   Widget _buildItems(ThemeData theme) {
//
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//
//         /// TABLE HEADER
//         Row(
//           children: const [
//             Expanded(flex: 4, child: Text("Product")),
//             Expanded(child: Text("Qty")),
//             Expanded(child: Text("Price")),
//             Expanded(child: Text("Total")),
//           ],
//         ),
//
//         const Divider(),
//
//         ...order.items.map((item) => _itemRow(item, theme)).toList()
//       ],
//     );
//   }
//
//   Widget _itemRow(PurchaseOrderItem item, ThemeData theme) {
//
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//
//           Expanded(
//             flex: 4,
//             child: Text(item.productName),
//           ),
//
//           Expanded(
//             child: Text(item.quantity.toString()),
//           ),
//
//           Expanded(
//             child: Text("\$${item.unitPrice.toStringAsFixed(2)}"),
//           ),
//
//           Expanded(
//             child: Text(
//               "\$${item.lineTotal.toStringAsFixed(2)}",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: theme.primaryColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFooter(ThemeData theme) {
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         border: Border(top: BorderSide(color: theme.dividerColor)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//
//           Text(
//             "Grand Total",
//             style: theme.textTheme.titleLarge,
//           ),
//
//           Text(
//             "\$${order.totalAmount.toStringAsFixed(2)}",
//             style: theme.textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: theme.primaryColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _statusBadge(String status) {
//
//     Color color =
//     status == "Completed" ? Colors.green : Colors.orange;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../models/purchase/po/order_item_model.dart';
import '../../../models/purchase/po/purchase_order_model.dart';

class PODetailPage extends StatelessWidget {

  final PurchaseOrder order;

  const PODetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [

          /// HEADER
          _buildHeader(context, theme),

          const Divider(height: 1),

          /// ITEMS
          Expanded(
            child: _buildItems(context, theme),
          ),

          /// FOOTER
          _buildFooter(theme),
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// HEADER
  /// ---------------------------------------------------------

  Widget _buildHeader(BuildContext context, ThemeData theme) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ORDER NUMBER + ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Text(
                    order.tracker,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  _statusBadge(order.status),
                ],
              ),

              /// ADD ITEM BUTTON
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Item"),
                onPressed: () {
                  _addItem(context);
                },
              )
            ],
          ),

          const SizedBox(height: 16),

          /// INFO GRID
          Wrap(
            spacing: 40,
            runSpacing: 12,
            children: [
              _info("Supplier", order.supplierName, theme),
              _info("Warehouse", order.warehouseName, theme),
              _info("Order Date",
                  order.orderDate.toString().split(' ')[0], theme),
              _info("Items", order.itemCount.toString(), theme),
            ],
          )
        ],
      ),
    );
  }

  Widget _info(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// ---------------------------------------------------------
  /// ITEMS LIST
  /// ---------------------------------------------------------

  Widget _buildItems(BuildContext context, ThemeData theme) {

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        /// TABLE HEADER
        Row(
          children: const [
            Expanded(flex: 4, child: Text("Product")),
            Expanded(child: Text("Qty")),
            Expanded(child: Text("Price")),
            Expanded(child: Text("Total")),
            Expanded(child: Text("Status")),
            SizedBox(width: 80)
          ],
        ),

        const Divider(),

        ...order.items.map((item) => _itemRow(context, item, theme)).toList()
      ],
    );
  }

  Widget _itemRow(
      BuildContext context,
      PurchaseOrderItem item,
      ThemeData theme,
      ) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [

          /// PRODUCT
          Expanded(
            flex: 4,
            child: Text(item.productName),
          ),

          /// QTY
          Expanded(
            child: Text(item.quantity.toString()),
          ),

          /// PRICE
          Expanded(
            child: Text("\$${item.unitPrice.toStringAsFixed(2)}"),
          ),

          /// TOTAL
          Expanded(
            child: Text(
              "\$${item.lineTotal.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),

          /// STATUS DROPDOWN
          Expanded(
            child: DropdownButton<String>(
              value: item.status,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(value: "Confirmed", child: Text("Confirmed")),
                DropdownMenuItem(value: "Received", child: Text("Received")),
              ],
              onChanged: (value) {
                _updateItemStatus(context, item, value!);
              },
            ),
          ),

          /// ACTIONS
          Row(
            children: [

              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () {
                  _editItem(context, item);
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () {
                  _deleteItem(context, item);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// FOOTER
  /// ---------------------------------------------------------

  Widget _buildFooter(ThemeData theme) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            "Grand Total",
            style: theme.textTheme.titleLarge,
          ),

          Text(
            "\$${order.totalAmount.toStringAsFixed(2)}",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// STATUS BADGE
  /// ---------------------------------------------------------

  Widget _statusBadge(String status) {

    Color color =
    status == "Completed" ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ---------------------------------------------------------
  /// ACTION HANDLERS
  /// ---------------------------------------------------------

  void _addItem(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Open Add Item Form")),
    );

    /// open add item page
  }

  void _editItem(BuildContext context, PurchaseOrderItem item) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit ${item.productName}")),
    );
  }

  void _deleteItem(BuildContext context, PurchaseOrderItem item) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Delete ${item.productName}")),
    );
  }

  void _updateItemStatus(
      BuildContext context,
      PurchaseOrderItem item,
      String status,
      ) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.productName} → $status")),
    );

    /// call API to update status
  }
}