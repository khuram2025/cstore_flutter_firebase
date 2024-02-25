import 'package:flutter/material.dart';

import '../../ApiService.dart';
import '../../bottom_navbar.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page'; // Add this line

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Welcome to Channab',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(_mobileNumberController, 'Mobile Number', false, Icons.phone),
              _buildTextField(_passwordController, 'Password', true, Icons.lock),
              SizedBox(height: 20),
              // ...
              ElevatedButton(
                child: Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  String mobile = _mobileNumberController.text;
                  String password = _passwordController.text;
                  bool loginSuccess = await loginUser(mobile, password); // Call the login function
                  if (loginSuccess) {
                    // If login is successful, navigate to HomePage
                    Navigator.of(context).pushReplacementNamed(BottomNavbar.id); // Replace with your HomePage route name
                  } else {
                    // Handle login failure (show error message)
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed. Please check your credentials.'))
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
// ...


              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to signup page
                  },
                  child: Text(
                    'Don\'t have an account? Signup',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool obscureText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
