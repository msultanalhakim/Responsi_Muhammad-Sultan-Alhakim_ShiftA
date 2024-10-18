import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekam_medis_pasien/providers/auth_provider.dart';
import 'package:rekam_medis_pasien/screens/home_screen.dart';
import 'package:rekam_medis_pasien/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized before using any Flutter widgets.
  
  final authProvider = AuthProvider();
  await authProvider.loadToken(); // Load token on startup

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        // Add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumah Sakit Kartika Husada',
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Check if the user is logged in
          if (authProvider.token != null) {
            return HomeScreen(); // Navigate to HomeScreen if logged in
          } else {
            return LogInScreen(); // Show LogInScreen if not logged in
          }
        },
      ),
    );
  }
}
