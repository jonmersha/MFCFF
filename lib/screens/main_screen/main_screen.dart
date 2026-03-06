// // import 'package:flutter/material.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// // import '../../services/api_service.dart';
// // import 'dashboard_screen.dart';
// // import '../inventory_screen.dart';
// // import '../sales_page.dart';
// // import '../purchase_page.dart';
// // import '../user_profile/profile_screen.dart';
// // import '../user_profile/login_screen.dart';

// // class MainScreen extends StatefulWidget {
// //   const MainScreen({super.key});

// //   @override
// //   State<MainScreen> createState() => _MainScreenState();
// // }

// // class _MainScreenState extends State<MainScreen> {
// //   int _selectedIndex = 0;
// //   final ApiService _api = ApiService();
// //   String _username = "Loading...";
// //   String _email = "";
// //   final Color kDeepGreen = const Color(0xFF1B5E20);

// //   final List<Widget> _pages = [
// //     DashboardPage(),
// //     InventoryPage(),
// //     SalesPage(),
// //     PurchasePage(),
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserInfo();
// //   }

// //   Future<void> _loadUserInfo() async {
// //     try {
// //       final user = await _api.getCurrentUser();
// //       if (mounted) {
// //         setState(() {
// //           _username = user['username'] ?? "User";
// //           _email = user['email'] ?? "";
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) setState(() => _username = "Operator");
// //     }
// //   }

// //   void _handleLogout(BuildContext context) async {
// //     final bool? confirm = await showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text("Logout"),
// //         content: const Text("Are you sure you want to exit the Milki ERP?"),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx),
// //             child: const Text("CANCEL"),
// //           ),
// //           TextButton(
// //             onPressed: () async {
// //               await const FlutterSecureStorage().deleteAll();
// //               if (mounted) {
// //                 Navigator.pushAndRemoveUntil(
// //                   context,
// //                   MaterialPageRoute(builder: (c) => LoginScreen()),
// //                   (route) => false,
// //                 );
// //               }
// //             },
// //             child: const Text("LOGOUT", style: TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: kDeepGreen,
// //         elevation: 2,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               "MFC",
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             Text(
// //               "User: $_username",
// //               style: const TextStyle(color: Colors.white70, fontSize: 11),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.account_circle_outlined),
// //             onPressed: () => Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (c) => ProfileScreen()),
// //             ).then((_) => _loadUserInfo()),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.power_settings_new, color: Colors.white70),
// //             onPressed: () => _handleLogout(context),
// //           ),
// //           const SizedBox(width: 5),
// //         ],
// //       ),

// //       // --- DRAWER ADDED BACK ---
// //       drawer: _buildAppDrawer(context),

// //       body: IndexedStack(index: _selectedIndex, children: _pages),

// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (i) => setState(() => _selectedIndex = i),
// //         type: BottomNavigationBarType.fixed,
// //         selectedItemColor: kDeepGreen,
// //         unselectedItemColor: Colors.grey,
// //         items: const [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.analytics_outlined),
// //             label: 'Stats',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.warehouse_outlined),
// //             label: 'Silos',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.receipt_long_outlined),
// //             label: 'Sales',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.local_shipping_outlined),
// //             label: 'Intake',
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAppDrawer(BuildContext context) {
// //     return Drawer(
// //       child: Column(
// //         children: [
// //           UserAccountsDrawerHeader(
// //             decoration: BoxDecoration(color: kDeepGreen),
// //             currentAccountPicture: const CircleAvatar(
// //               backgroundColor: Colors.white,
// //               child: Icon(
// //                 Icons.factory_outlined,
// //                 color: Color(0xFF1B5E20),
// //                 size: 40,
// //               ),
// //             ),
// //             accountName: Text(
// //               _username,
// //               style: const TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //             accountEmail: Text(_email.isNotEmpty ? _email : "Milki ERP v1.0"),
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.person_outline, color: kDeepGreen),
// //             title: const Text("Profile Settings"),
// //             onTap: () {
// //               Navigator.pop(context);
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (c) => ProfileScreen()),
// //               ).then((_) => _loadUserInfo());
// //             },
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.settings_outlined, color: kDeepGreen),
// //             title: const Text("Factory Configuration"),
// //             onTap: () {},
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.help_outline, color: kDeepGreen),
// //             title: const Text("Support & Help"),
// //             onTap: () {},
// //           ),
// //           const Spacer(),
// //           const Divider(),
// //           ListTile(
// //             leading: const Icon(Icons.logout, color: Colors.red),
// //             title: const Text(
// //               "Logout System",
// //               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
// //             ),
// //             onTap: () => _handleLogout(context),
// //           ),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:mfco/widgets/navigation/app_drawer.dart';
// import 'package:mfco/widgets/navigation/main_app_bar.dart';
// import 'package:mfco/widgets/navigation/main_bottom_nav.dart';
// import '../../services/api_service.dart';
// // Separate Component Imports

// // Page Imports
// import 'dashboard_screen.dart';
// import '../inventory_screen.dart';
// import '../sales_page.dart';
// import '../purchase_page.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final ApiService _api = ApiService();
//   String _username = "Loading...";
//   String _email = "";
//   String _firstName = "";
//   String _lastName = "";
//   final Color kDeepGreen = const Color(0xFF1B5E20);

//   final List<Widget> _pages = [
//     DashboardPage(),
//     InventoryPage(),
//     SalesPage(),
//     PurchasePage(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserInfo();
//   }

//   Future<void> _loadUserInfo() async {
//     try {
//       final user = await _api.getCurrentUser();
//       if (mounted) {
//         setState(() {
//           _username = user['username'] ?? "User";
//           _email = user['email'] ?? "";
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _username = "Operator");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // 1. Separated App Bar
//       appBar: MainAppBar(
//         username: _username,
//         kDeepGreen: kDeepGreen,
//         onProfileUpdate: _loadUserInfo,
//       ),

//       // 2. Separated Drawer
//       drawer: AppDrawer(
//         firstName: _firstName, // Ensure you load these in _loadUserInfo()
//         lastName: _lastName,
//         email: _email,
//         kDeepGreen: kDeepGreen,
//         onProfileUpdate: _loadUserInfo,
//       ),

//       // Use IndexedStack to preserve state of factory pages
//       body: IndexedStack(index: _selectedIndex, children: _pages),

//       // 3. Separated Bottom Navigation
//       bottomNavigationBar: MainBottomNav(
//         currentIndex: _selectedIndex,
//         kDeepGreen: kDeepGreen,
//         onTap: (index) => setState(() => _selectedIndex = index),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mfco/widgets/navigation/app_drawer.dart';
import 'package:mfco/widgets/navigation/main_app_bar.dart';
import 'package:mfco/widgets/navigation/main_bottom_nav.dart';
import '../../services/api_service.dart';

// Page Imports
import 'dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../sales/sales_page.dart';
import '../purchase/po/purchase_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ApiService _api = ApiService();

  // Initialize with empty strings to prevent "null" errors
  String _firstName = "";
  String _lastName = "";
  String _username = "";
  String _email = "";

  final Color kDeepGreen = const Color(0xFF1B5E20);

  final List<Widget> _pages = [
    const DashboardPage(),
    const InventoryPage(),
    const SalesPage(),
    const PurchasePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await _api.getCurrentUser();
      if (mounted) {
        setState(() {
          // IMPORTANT: These keys must match your ApiService/Django response
          _username = user['username'] ?? "";
          _email = user['email'] ?? "";
          _firstName = user['first_name'] ?? "";
          _lastName = user['last_name'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        firstName: _firstName,
        lastName: _lastName,
        kDeepGreen: kDeepGreen,
        onProfileUpdate: _loadUserInfo,
      ),
      drawer: AppDrawer(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        kDeepGreen: kDeepGreen,
        onProfileUpdate: _loadUserInfo,
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _selectedIndex,
        kDeepGreen: kDeepGreen,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
