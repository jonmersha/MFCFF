import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mfco/models/Core/company_model.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../widgets/factory_core/create_company_form.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Company company;
  const CompanyDetailsPage({super.key, required this.company});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final ApiService _apiService = ApiService();
  final Color kDeepGreen = const Color(0xFF1B5E20);
  bool _isUploading = false;

  Future<void> _updateImage(bool isLogo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final url = "${ApiConstants.companies}${widget.company.tracker}/";
      final fieldName = isLogo ? 'logo' : 'banner';

      final response = await _apiService.uploadImage(
        url,
        fieldName,
        pickedFile.path,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${isLogo ? 'Logo' : 'Banner'} updated!")),
          );
          Navigator.pop(context, true); // Return to list and refresh
        }
      } else {
        debugPrint("Server Error Body: ${response.body}");
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final comp = widget.company;
    final String version = DateTime.now().millisecondsSinceEpoch.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(comp.name),
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        actions: [
          if (_isUploading)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: _showEditForm,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER STACK ---
            Stack(
              clipBehavior:
                  Clip.none, // CRITICAL: Allows logo clicks outside the box
              children: [
                // 1. Banner
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: comp.banner != null
                        ? DecorationImage(
                            image: NetworkImage("${comp.banner!}?v=$version"),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: comp.banner == null
                      ? const Icon(Icons.business, size: 80, color: Colors.grey)
                      : null,
                ),

                // 2. Banner Edit Overlay
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _updateImage(false),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // 3. Logo Container (Hanging off bottom)
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () =>
                        _updateImage(true), // Makes the whole logo clickable
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(blurRadius: 8, color: Colors.black12),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            backgroundImage: comp.logo != null
                                ? NetworkImage("${comp.logo!}?v=$version")
                                : null,
                            child: comp.logo == null
                                ? Icon(
                                    Icons.apartment,
                                    color: kDeepGreen,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        // 4. Logo Pencil Icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: kDeepGreen,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // Space for the logo overflow
            // --- Information Section ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comp.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _detailRow(Icons.location_city, "City", comp.cityName),
                  _detailRow(Icons.info_outline, "Status", comp.status),
                  _detailRow(Icons.tag, "Tracker", comp.tracker),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(comp.description ?? "No description available."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String val) => ListTile(
    leading: Icon(icon, color: kDeepGreen),
    title: Text(
      label,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    subtitle: Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  void _showEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateCompanyForm(
        kDeepGreen: kDeepGreen,
        onSaved: () => Navigator.pop(context, true),
        existingCompany: widget.company,
      ),
    ).then((val) {
      if (val == true) Navigator.pop(context, true);
    });
  }

  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Company"),
        content: Text("Delete ${widget.company.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.delete(
          "${ApiConstants.companies}${widget.company.tracker}/",
        );
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}
