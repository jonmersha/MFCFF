import 'package:flutter/material.dart';
import '../../models/Core/factory_model.dart';
import '../../screens/core/factory_details_page.dart';

class FactoryCard extends StatelessWidget {
  final Factory factory;
  final Color kDeepGreen;
  final VoidCallback onRefresh;

  const FactoryCard({
    super.key,
    required this.factory,
    required this.kDeepGreen,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryDetailsPage(factory: factory),
            ),
          );
          // If the details page returns true (deleted or updated), refresh the list
          if (result == true) onRefresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: kDeepGreen.withOpacity(0.1),
                child: Icon(Icons.factory_rounded, color: kDeepGreen, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factory.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Owner: ${factory.companyName}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      "Location: ${factory.cityName}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
