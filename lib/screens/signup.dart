import 'package:flutter/material.dart';
import 'package:rekam_medis_pasien/services/api_service.dart'; // Correct path to the API service
import 'package:rekam_medis_pasien/screens/login.dart';
import 'package:rekam_medis_pasien/theme.dart';
import 'package:rekam_medis_pasien/widgets/checkbox.dart';
import 'package:rekam_medis_pasien/widgets/primary_button.dart';
import 'package:rekam_medis_pasien/widgets/success_dialog.dart'; // Replace with the actual import for SuccessDialog
import 'package:rekam_medis_pasien/widgets/warning_dialog.dart'; // Replace with the actual import for WarningDialog

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService().register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => SuccessDialog(
          description: "Registration successful! You can now log in.",
          okClick: () {
            Navigator.pop(context); // Close the dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LogInScreen()), // Navigate to login
            );
          },
        ),
      );
    } catch (e) {
      // Show warning dialog on error
      showDialog(
        context: context,
        builder: (context) => WarningDialog(
          description: e.toString(), // Show the error message
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 160),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Create Account',
                style: titleText,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Already a member?',
                    style: subTitle,
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: kDefaultPadding,
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: kDefaultPadding,
              child: CheckBox('I agree to the terms and conditions.'),
            ),
            SizedBox(height: 40),
            Padding(
              padding: kDefaultPadding,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : PrimaryButton(
                      buttonText: 'Sign Up',
                      onTap: _register, // Call register method here
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
