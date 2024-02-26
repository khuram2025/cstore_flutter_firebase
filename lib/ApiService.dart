import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loginUser(String mobile, String password) async {
  var url = Uri.parse('http://farmapp.channab.com/accounts/api/login/');

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful');

      var jsonData = jsonDecode(response.body);
      String? authToken = jsonData['token'];

      if (authToken != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
        return true; // Login successful
      }
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  } catch (e) {
    print('Error making login request: $e');
  }
  return false; // Login failed
}


Future<bool> logoutUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    // Check if the authToken exists
    String? authToken = prefs.getString('authToken');
    if (authToken != null) {
      var url = Uri.parse('http://farmapp.channab.com/accounts/api/logout/'); // Replace with your API's logout URL

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $authToken',
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful');
        await prefs.remove('authToken'); // Remove the authToken from SharedPreferences
        return true; // Logout successful
      } else {
        print('Failed to logout: ${response.statusCode}');
      }
    } else {
      print('No authToken found');
    }
  } catch (e) {
    print('Error making logout request: $e');
  }
  return false; // Logout failed
}


Future<void> signupUser(String mobile, String password, String name, String businessName) async {
  var url = Uri.parse('http://farmapp.channab.com/accounts/api/signup/'); // Replace with your API URL

  try {
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mobile': mobile,
        'password': password,
        'name': name,  // Assuming your API expects a 'name'
        'business_name': businessName,  // Assuming your API expects a 'business_name'
      }),
    );

    if (response.statusCode == 201) {
      print('Signup successful');
      // Handle successful signup
      // Navigate to the login page or dashboard
    } else {
      print('Failed to signup: ${response.statusCode}');
      // Handle unsuccessful signup
      // Optionally show an alert dialog with the error
    }
  } catch (e) {
    print('Error making signup request: $e');
    // Handle errors in request
    // Optionally show an alert dialog with the error
  }
}

Future<Map<String, dynamic>?> fetchUserInfo(String authToken) async {
  var url = Uri.parse('http://farmapp.channab.com/accounts/api/home/'); // Replace with your API URL

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  print("Headers: $headers");  // Debug print

  try {
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('User info fetched successfully');
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user info: $e');
  }

  return null;
}

