import 'package:flutter/material.dart';
import 'package:mfco/screens/user_profile/profile_screen.dart';
import '../../core/utils/auth_utils.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final Color kDeepGreen;
  final VoidCallback onProfileUpdate;

  const MainAppBar({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.kDeepGreen,
    required this.onProfileUpdate,
  });

  @override
  Widget build(BuildContext context) {
    const Color kGolden = Color(0xFFFFC107);

    // Logic to determine the greeting name
    final String fullName = "$firstName $lastName".trim();
    final String displayName = fullName.isNotEmpty ? fullName : "Staff Member";

    return AppBar(
      backgroundColor: kDeepGreen,
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MILKI FOOD COMPLEX",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.white),
              children: [
                const TextSpan(text: "Hello, "),
                TextSpan(
                  text: displayName,
                  style: const TextStyle(
                    color: kGolden, // Secondary Golden color for the name
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
          tooltip: "Profile Settings",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const ProfileScreen()),
          ).then((_) => onProfileUpdate()),
        ),
        IconButton(
          icon: const Icon(Icons.power_settings_new, color: Colors.white70),
          tooltip: "Logout",
          onPressed: () => AuthUtils.showLogoutDialog(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
