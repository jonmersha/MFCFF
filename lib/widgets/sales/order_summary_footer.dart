import 'package:flutter/material.dart';

class OrderSummaryFooter extends StatelessWidget {
  const OrderSummaryFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kDeepGreen = Color(0xFF1B5E20);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Draft Order", style: TextStyle(color: Colors.grey)),
              Text(
                "ETB 0.00",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDeepGreen,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Review Order",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
