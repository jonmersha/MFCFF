import 'package:flutter/material.dart';
import 'package:mfco/screens/core/company_list_page.dart';
import 'package:mfco/screens/core/factory_list_page.dart';
import 'package:mfco/screens/customer/customer_list.dart';
import 'package:mfco/screens/inventory/product_list_page.dart';
import 'package:mfco/screens/inventory/warehouse_list_page.dart';
import 'package:mfco/screens/suppliers/suppliers_list_page.dart';
import 'package:mfco/screens/user_profile/profile_screen.dart';
import '../../core/utils/auth_utils.dart';
import '../../screens/core/admin_regin_page.dart';
import '../../screens/purchase/goods_receiving_note.dart';
import '../../screens/purchase/order_list.dart';
import '../../screens/purchase/purchase_order.dart';

class AppDrawer extends StatelessWidget {
  // Swapped username for specific name fields
  final String firstName;
  final String lastName;
  final String email;
  final Color kDeepGreen;
  final VoidCallback onProfileUpdate;

  const AppDrawer({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.kDeepGreen,
    required this.onProfileUpdate,
  });

  final Color kGolden = const Color(0xFFB8860B);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Inside the ListView of your AppDrawer...
                _buildSectionTitle("STRUCTURAL CORE"),
                _buildMenuItem(
                  Icons.policy,
                  "Admin Region",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const AdminRegionPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(Icons.business_outlined, "Company Setup", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const CompanyListPage()),
                  );
                }),
                _buildMenuItem(
                  Icons.factory_outlined,
                  "Factory Management",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const FactoryListPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(Icons.warehouse_outlined, "Warehouse Setup", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const WarehouseListPage(),
                    ),
                  );
                }),
                _buildMenuItem(
                  Icons.inventory_2_outlined,
                  "Product Catalog",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const ProductListPage(),
                      ),
                    );
                  },
                ),
                _buildSectionTitle("Sales Module"),
                _buildMenuItem(
                  Icons.factory_outlined,
                  "Customers",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const CustomerListPage(),
                      ),
                    );
                  },
                ),

                _buildSectionTitle("Purchase Module"),

                _buildMenuItem(
                  Icons.factory_outlined,
                  "Suppliers",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const SupplierListPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.factory_outlined,
                  "PO",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const PurchaseOrderListPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.factory_outlined,
                  "Goods Receiving",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const GRNListPage(),
                      ),
                    );
                  },
                ),
                _buildSectionTitle("Inventory"),
                _buildMenuItem(
                  Icons.factory_outlined,
                  "Stock",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const PurchaseOrderListPage(),
                      ),
                    );
                  },
                ),

                _buildSectionTitle("CORE MODULES"),
                _buildMenuItem(
                  Icons.dashboard_outlined,
                  "Operational Dashboard",
                  () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  Icons.precision_manufacturing_outlined,
                  "Milling Production",
                  () {},
                ),
                _buildMenuItem(
                  Icons.science_outlined,
                  "Lab & Quality Control",
                  () {},
                ),

                const Divider(),
                _buildSectionTitle("LOGISTICS"),
                _buildMenuItem(
                  Icons.inventory_2_outlined,
                  "Warehouse (Finished Goods)",
                  () {},
                ),
                _buildMenuItem(
                  Icons.local_shipping_outlined,
                  "Fleet Management",
                  () {},
                ),

                const Divider(),
                _buildSectionTitle("ADMINISTRATION"),
                _buildMenuItem(
                  Icons.people_alt_outlined,
                  "Staff Directory",
                  () {},
                ),
                _buildMenuItem(
                  Icons.assessment_outlined,
                  "Reports & Analytics",
                  () {},
                  isPremium: true,
                ),
                _buildMenuItem(
                  Icons.settings_outlined,
                  "Factory Configuration",
                  () {},
                ),

                const Divider(),
                _buildMenuItem(Icons.person_outline, "Profile Settings", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const ProfileScreen()),
                  ).then((_) => onProfileUpdate());
                }),
                _buildMenuItem(Icons.help_outline, "Support & Help", () {}),
              ],
            ),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // Combine names for the display
    final String fullName = "$firstName $lastName".trim();
    final String displayName = fullName.isNotEmpty ? fullName : "Staff Member";

    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: kDeepGreen),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          // Show initials if name exists, otherwise show factory icon
          firstName.isNotEmpty
              ? "${firstName[0]}${lastName.isNotEmpty ? lastName[0] : ''}"
              : "",
          style: TextStyle(
            color: kDeepGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      accountName: Text(
        displayName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      accountEmail: Text(email.isNotEmpty ? email : "Milki ERP v1.0"),
    );
  }

  // ... (Keep _buildSectionTitle, _buildMenuItem, and _buildLogoutButton exactly as they were)

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isPremium = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isPremium ? kGolden : kDeepGreen),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isPremium ? FontWeight.bold : FontWeight.normal,
          color: isPremium ? kGolden : Colors.black87,
        ),
      ),
      trailing: isPremium
          ? Icon(Icons.star, color: kGolden, size: 16)
          : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Logout System",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: () => AuthUtils.showLogoutDialog(context),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
