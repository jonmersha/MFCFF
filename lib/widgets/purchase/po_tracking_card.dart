import 'package:flutter/material.dart';

class POTrackingCard extends StatelessWidget {
  final String po, supplier, target, status;
  final int qty;

  const POTrackingCard({
    super.key,
    required this.po,
    required this.supplier,
    required this.target,
    required this.qty,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    const Color kDeepGreen = Color(0xFF1B5E20);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  po,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Color(0xFFB8860B),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.local_shipping,
                color: kDeepGreen,
                size: 30,
              ),
              title: Text(
                supplier,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text("Target: $target | Qty: $qty kg"),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Details"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDeepGreen,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "RECEIVE GRAIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
