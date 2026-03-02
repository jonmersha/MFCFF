import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Factory Overview",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        Text(
          DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
