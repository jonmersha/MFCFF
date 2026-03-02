import 'package:flutter/material.dart';

class MovementSummary extends StatelessWidget {
  const MovementSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.swap_vert, color: Color(0xFF1B5E20)),
            ),
            title: Text("Wheat Transfer: Silo A → Mill"),
            subtitle: Text("2,500 kg - COMPLETED"),
            trailing: Text(
              "10:45 AM",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
