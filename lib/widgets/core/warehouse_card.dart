import 'package:flutter/material.dart';
import 'package:mfco/models/inventory/warehouse_model.dart';
import 'package:mfco/screens/inventory/warehouse_details_page.dart';

class WarehouseCard extends StatelessWidget {
  final Warehouse warehouse;
  final Color kDeepGreen;
  final VoidCallback onRefresh;

  const WarehouseCard({
    super.key,
    required this.warehouse,
    required this.kDeepGreen,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarehouseDetailsPage(warehouse: warehouse),
            ),
          );
          if (result == true) onRefresh();
        },
        leading: Icon(
          Icons.warehouse,
          color: warehouse.status == 'active' ? kDeepGreen : Colors.grey,
          size: 30,
        ),
        title: Text(
          warehouse.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Location: ${warehouse.location ?? 'N/A'}\nStatus: ${warehouse.status}",
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
      ),
    );
  }
}
