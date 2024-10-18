import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/services/api_service.dart'; 
import 'package:rekam_medis_pasien/providers/auth_provider.dart'; 
import 'package:rekam_medis_pasien/screens/signup.dart';
import 'package:rekam_medis_pasien/screens/home_screen.dart';
import 'package:rekam_medis_pasien/theme.dart';
import 'package:provider/provider.dart';
import 'package:rekam_medis_pasien/widgets/primary_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Moved to state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 200),
              Text(
                'Welcome Back',
                style: titleText,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('New to this app?', style: subTitle),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Login Form Fields
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ],
              ),
              SizedBox(height: 40),
              // Use a Consumer to access the AuthProvider
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                      : PrimaryButton(
                          buttonText: 'Log In',
                          onTap: () async {
                            setState(() {
                              _isLoading = true; // Set loading state
                            });
                            try {
                              final token = await ApiService().login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              authProvider.setToken(token);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(e.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false; // Reset loading state
                              });
                            }
                          },
                        );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
