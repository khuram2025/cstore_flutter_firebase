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

Future<List<dynamic>> fetchCustomers() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  var url = Uri.parse('http://farmapp.channab.com/customers/api/customers/'); // Replace with your API URL

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken', // Replace 'Token' if you use a different scheme
  };

  print("Headers: $headers");  // Debug print

  try {
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('Customers fetched successfully');
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch customers: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching customers: $e');
  }

  return []; // Return an empty list if the fetch operation fails
}


Future<bool> createOrLinkCustomer(String name, String phone, int businessId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  var url = Uri.parse('http://farmapp.channab.com/customers/api/customer-create-link/'); // Check if this URL is correct

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  Map<String, dynamic> body = {
    'name': name,
    'phone': phone,
    'business_id': businessId.toString(),
  };

  print('URL: $url'); // Print the URL
  print('Headers: $headers'); // Print the headers
  print('Body: $body'); // Print the body

  try {
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}'); // Print the response status
    print('Response Body: ${response.body}'); // Print the response body

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Customer created/linked successfully');
      return true;
    } else {
      print('Failed to create/link customer: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error creating/linking customer: $e');
    return false;
  }
}

Future<bool> createTransaction({
  required String customerAccountId,
  required double amount,
  required String transactionType,
  DateTime? date,
  TimeOfDay? time,
  String? notes,
  String? attachmentPath,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  var url = Uri.parse('http://farmapp.channab.com/customers/api/add-transaction/');

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  // Ensure customerAccountId is an integer
  int customerAccountIdInt = int.tryParse(customerAccountId) ?? 0; // Adjust as necessary

  Map<String, dynamic> body = {
    'customer_account': customerAccountIdInt,
    'amount': amount,
    'transaction_type': transactionType,
    'notes': notes ?? '',
    'date': date != null ? "${date.year}-${date.month}-${date.day}" : '',
    'time': time != null ? "${time.hour}:${time.minute}:00" : '',
  };

  print('Making API Call to Add Transaction...');
  print('URL: $url');
  print('Headers: $headers');
  print('Body: $body');

  try {
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Transaction created successfully');
      return true;
    } else {
      print('Failed to create transaction: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error creating transaction: $e');
    return false;
  }
}
