import 'package:rekam_medis_pasien/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/screens/home_screen.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900], // Semi-dark background for the entire drawer
        child: ListView(
          children: [
            // Add the logo here
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800], // Darker shade for the header
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png', // Path to your logo
                  height: 80, // Adjust the height as needed
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white), // Icon color
              title: const Text(
                'Homepage',
                style: TextStyle(color: Colors.white, fontSize: 15), // Text color
              ),
              onTap: () {
                // Navigate to Home Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white), // Icon color
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 15), // Text color
              ),
              onTap: () {
                // Example for clearing session data or shared preferences (if any)
                // You can include your logic here for logging out.

                // Navigate to Login Screen and prevent going back
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogInScreen(),
                  ),
                  (Route<dynamic> route) => false, // Prevent back navigation to previous screens
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
