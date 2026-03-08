import 'package:flutter/material.dart';
import 'package:mfco/widgets/purchase/po_tiles.dart';

import '../../models/purchase/po/purchase_order_model.dart';

class POListView extends StatelessWidget {
  final List<PurchaseOrder> orders;
  final int? selectedOrderId;
  final bool isMasterDetail;
  final Future<void> Function() onRefresh;
  final Function(PurchaseOrder) onOrderSelected;

  const POListView({
    super.key,
    required this.orders,
    required this.onRefresh,
    required this.onOrderSelected,
    this.selectedOrderId,
    this.isMasterDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final order = orders[index];
          return PurchaseOrderTile(
            order: order,
            isSelected: isMasterDetail && selectedOrderId == order.id,
            onTap: () => onOrderSelected(order),
          );
        },
      ),
    );
  }
}