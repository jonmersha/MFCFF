import 'package:flutter/material.dart';
import '../../models/Core/company_model.dart';
import '../../screens/factory_core/detail_pages/company_detail.dart';

class CompanyCard extends StatelessWidget {
  final Company company;
  final Color kDeepGreen;
  final VoidCallback onRefresh;

  const CompanyCard({
    super.key,
    required this.company,
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
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyDetailsPage(company: company),
            ),
          );
          onRefresh(); // Refresh list when returning from details
        },
        leading: CircleAvatar(
          backgroundColor: kDeepGreen.withOpacity(0.1),
          backgroundImage: company.logo != null
              ? NetworkImage(company.logo!)
              : null,
          child: company.logo == null
              ? Icon(Icons.business, color: kDeepGreen)
              : null,
        ),
        title: Text(
          company.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("City: ${company.cityName}\nStatus: ${company.status}"),
        isThreeLine: true,
      ),
    );
  }
}
