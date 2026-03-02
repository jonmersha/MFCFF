import 'package:flutter/material.dart';

class ProcurementHeader extends StatelessWidget {
  const ProcurementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kDeepGreen = Color(0xFF1B5E20);
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      backgroundColor: kDeepGreen,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text(
          "Procurement & Intake",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        background: DecoratedBox(decoration: BoxDecoration(color: kDeepGreen)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
