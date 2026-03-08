import 'package:flutter/material.dart';
import '../../models/purchase/po/purchase_order_model.dart';

class PurchaseOrderTile extends StatelessWidget {
  final PurchaseOrder order;
  final bool isSelected;
  final VoidCallback onTap;

  const PurchaseOrderTile({
    super.key,
    required this.order,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Check orientation to decide what to show
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return ListTile(
      dense: !isPortrait, // Shorter/Compact when in Landscape
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.1),
      selectedColor: theme.primaryColor,
      onTap: onTap,
      leading: CircleAvatar(
        radius: isPortrait ? 20 : 16,
        backgroundColor: isSelected ? theme.primaryColor : Colors.grey.shade200,
        child: Icon(
          Icons.inventory_2,
          color: isSelected ? Colors.white : theme.primaryColor,
          size: isPortrait ? 20 : 16,
        ),
      ),
      title: Text(
        order.tracker,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isPortrait ? 16 : 13,
        ),
      ),
      subtitle: Text(
        order.supplierName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: isPortrait ? 14 : 12),
      ),
      // ONLY SHOW TRAILING IF PORTRAIT
      trailing: isPortrait
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(status: order.status),
          const SizedBox(height: 4),
          Text(
            "\$${order.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      )
          : null,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color col = status == 'Completed' ? theme.primaryColor : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: col.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, color: col, fontWeight: FontWeight.bold),
      ),
    );
  }
}