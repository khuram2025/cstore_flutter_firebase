import 'package:flutter/material.dart';

import '../../ApiService.dart';

class SignupPage extends StatefulWidget {
  static const String id = 'signup_page'; // Add this line
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();

  void _submitSignup() {
    String mobile = _mobileNumberController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String businessName = _businessNameController.text;

    if (password != confirmPassword) {
      // Show an error message that passwords don't match
      print('Passwords do not match');
      return;
    }

    // Call the signup function with an empty string for the name
    signupUser(mobile, password, "", businessName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField(_mobileNumberController, 'Mobile Number', false, Icons.phone),
              _buildTextField(_passwordController, 'Password', true, Icons.lock),
              _buildTextField(_confirmPasswordController, 'Confirm Password', true, Icons.lock),
              _buildTextField(_businessNameController, 'Business Name', false, Icons.business),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                onPressed: _submitSignup,  // Updated to use the _submitSignup method
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to login page
                  },
                  child: Text(
                    'Already have an account? Login',
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
