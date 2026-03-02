// import 'package:flutter/material.dart';
// import 'package:mfco/screens/core/company_detail.dart';
// import '../../models/Core/company_model.dart';
// import '../../services/api_service.dart';
// import '../../core/constants/api_constants.dart';

// class CompanyListPage extends StatefulWidget {
//   const CompanyListPage({super.key});

//   @override
//   State<CompanyListPage> createState() => _CompanyListPageState();
// }

// class _CompanyListPageState extends State<CompanyListPage> {
//   final ApiService _apiService = ApiService();
//   final Color kDeepGreen = const Color(0xFF1B5E20);
//   final Color kGolden = const Color(0xFFFFC107);
//   late Future<List<Company>> _companiesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//   }

//   // Refreshes the list by calling the generic get method
//   void _refreshData() {
//     setState(() {
//       _companiesFuture = _apiService.get(ApiConstants.companies).then((data) {
//         // Mapping the generic List<dynamic> to List<Company>
//         return data.map((json) => Company.fromJson(json)).toList();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text("Company Setup"),
//         backgroundColor: kDeepGreen,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
//         ],
//       ),
//       body: FutureBuilder<List<Company>>(
//         future: _companiesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text("No companies found in Milki ERP."),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) =>
//                 _buildCompanyCard(snapshot.data![index]),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: kDeepGreen,
//         icon: Icon(Icons.add, color: kGolden),
//         label: const Text(
//           "ADD COMPANY",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onPressed: () => _showCreateForm(),
//       ),
//     );
//   }

//   void _showCreateForm() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) => CreateCompanyForm(
//         kDeepGreen: kDeepGreen,
//         onSaved: _refreshData, // Passing the reference to refresh the list
//       ),
//     );
//   }

//   Widget _buildCompanyCard(Company company) {
//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         onTap: () async {
//           // Wait for potential refresh if user deletes or updates
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CompanyDetailsPage(company: company),
//             ),
//           );
//           _refreshData(); // Refresh list when coming back
//         },
//         leading: CircleAvatar(
//           backgroundColor: kDeepGreen.withOpacity(0.1),
//           backgroundImage: company.logo != null
//               ? NetworkImage(company.logo!)
//               : null,
//           child: company.logo == null
//               ? Icon(Icons.business, color: kDeepGreen)
//               : null,
//         ),
//         title: Text(
//           company.name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text("City: ${company.cityName}\nStatus: ${company.status}"),
//         isThreeLine: true,
//       ),
//     );
//   }
// }

// class CreateCompanyForm extends StatefulWidget {
//   final Color kDeepGreen;
//   final VoidCallback onSaved;
//   final Company?
//   existingCompany; // If null, we are Creating. If not null, we are Editing.

//   const CreateCompanyForm({
//     super.key,
//     required this.kDeepGreen,
//     required this.onSaved,
//     this.existingCompany,
//   });

//   @override
//   State<CreateCompanyForm> createState() => CreateCompanyFormState();
// }

// class CreateCompanyFormState extends State<CreateCompanyForm> {
//   final _formKey = GlobalKey<FormState>();
//   final ApiService _apiService = ApiService();

//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();

//   int? _selectedCityId;
//   bool _isSaving = false;
//   bool _isEditMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _isEditMode = widget.existingCompany != null;

//     if (_isEditMode) {
//       // Pre-fill fields with existing data
//       _nameController.text = widget.existingCompany!.name;
//       _descController.text = widget.existingCompany!.description ?? "";
//       _selectedCityId = widget.existingCompany!.city; // Using the integer ID
//     } else {
//       _selectedCityId = 1; // Default for new company
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descController.dispose();
//     super.dispose();
//   }

//   void _handleSave() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isSaving = true);

//     try {
//       // 1. Prepare Payload (Matches your POST/PUT requirements)
//       final Map<String, dynamic> payload = {
//         "name": _nameController.text.trim(),
//         "description": _descController.text.trim(),
//         "city": _selectedCityId, // Sending Integer ID
//         "status": "active",
//       };

//       dynamic response;

//       if (_isEditMode) {
//         // 2. Perform UPDATE (PUT)
//         // URL uses the tracker string: /core/companies/CMP-XXXXX/
//         response = await _apiService.put(
//           "${ApiConstants.companies}${widget.existingCompany!.tracker}/",
//           payload,
//         );
//       } else {
//         // 3. Perform CREATE (POST)
//         response = await _apiService.post(ApiConstants.companies, payload);
//       }

//       // Check for success (200 for OK, 201 for Created)
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         widget.onSaved(); // Refresh the list
//         if (mounted) {
//           Navigator.pop(context, true); // Close the sheet and return success
//           _showSnackBar(
//             _isEditMode ? "Company Updated!" : "Company Registered!",
//             widget.kDeepGreen,
//           );
//         }
//       } else {
//         throw Exception("Server Error: ${response.body}");
//       }
//     } catch (e) {
//       _showSnackBar("Operation failed: $e", Colors.red);
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   void _showSnackBar(String msg, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard
//         top: 24,
//         left: 24,
//         right: 24,
//       ),
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _isEditMode ? "Edit Company" : "Register Company",
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (_isEditMode)
//                     const Chip(
//                       label: Text("EDIT MODE"),
//                       backgroundColor: Colors.amber,
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // Name Field
//               _buildTextField(
//                 controller: _nameController,
//                 label: "Trade Name",
//                 icon: Icons.business_outlined,
//                 validator: (v) => v!.isEmpty ? "Enter company name" : null,
//               ),

//               // City Dropdown (Integer Based)
//               DropdownButtonFormField<int>(
//                 value: _selectedCityId,
//                 decoration: _inputStyle(
//                   "Operational City",
//                   Icons.location_city,
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 1, child: Text("Assela")),
//                   DropdownMenuItem(value: 2, child: Text("Adama")),
//                   DropdownMenuItem(value: 3, child: Text("Addis Ababa")),
//                 ],
//                 onChanged: (val) => setState(() => _selectedCityId = val),
//                 validator: (v) => v == null ? "Select a city" : null,
//               ),
//               const SizedBox(height: 20),

//               // Description Field
//               _buildTextField(
//                 controller: _descController,
//                 label: "Company Bio / Description",
//                 icon: Icons.description_outlined,
//                 maxLines: 3,
//               ),

//               const SizedBox(height: 32),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: widget.kDeepGreen,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: _isSaving ? null : _handleSave,
//                   child: _isSaving
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : Text(
//                           _isEditMode ? "UPDATE CHANGES" : "SAVE COMPANY",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- UI Helpers ---

//   InputDecoration _inputStyle(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, color: widget.kDeepGreen, size: 22),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: widget.kDeepGreen, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         validator: validator,
//         decoration: _inputStyle(label, icon),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../models/Core/company_model.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../widgets/core/company_card.dart'; // Import Custom Widget
import '../../widgets/core/create_company_form.dart'; // Import Custom Form

class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  final Color kGolden = const Color(0xFFFFC107);
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _companiesFuture = _apiService.get(ApiConstants.companies).then((data) {
        return data.map((json) => Company.fromJson(json)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Company Setup"),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: FutureBuilder<List<Company>>(
        future: _companiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text("No companies found."));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => CompanyCard(
              company: snapshot.data![index],
              kDeepGreen: kDeepGreen,
              onRefresh: _refreshData,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kDeepGreen,
        icon: Icon(Icons.add, color: kGolden),
        label: const Text(
          "ADD COMPANY",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: _showCreateForm,
      ),
    );
  }

  void _showCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) =>
          CreateCompanyForm(kDeepGreen: kDeepGreen, onSaved: _refreshData),
    );
  }
}
