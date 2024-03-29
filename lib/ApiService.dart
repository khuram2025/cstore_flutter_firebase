import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/data.dart';

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

Future<List<CustomerAccount>> fetchCustomerAccounts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  final response = await http.get(
    Uri.parse('http://farmapp.channab.com/customers/api/customer-accounts/'),
    headers: {
      'Authorization': 'Token $authToken',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);



    List<CustomerAccount> customerAccounts = (jsonResponse['accounts'] as List)
        .map((data) => CustomerAccount.fromJson(data))
        .toList();

    return customerAccounts;
  } else {
    throw Exception('Failed to load customer accounts');
  }
}

Future<SummaryData> fetchSummaryData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  final Uri apiUri = Uri.parse('http://farmapp.channab.com/customers/api/customer-accounts/');
  final response = await http.get(apiUri, headers: {'Authorization': 'Token $authToken'});

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);

    print("Fetched Summary Data:");
    print("Total Customers: ${jsonResponse['total_customers']}");
    print("Total Sum: ${jsonResponse['total_sum']}");

    return SummaryData(
      totalCustomers: jsonResponse['total_customers'],
      totalSum: jsonResponse['total_sum'].toString(),
      totalSumPaid: jsonResponse['total_sum_paid'].toString(),
      totalSumReceived: jsonResponse['total_sum_received'].toString(),
    );
  } else {
    throw Exception('Failed to load summary data');
  }
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

Future<bool> editCustomerAccountProfile(int accountId, String name, String phone, String openingBalance) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  var url = Uri.parse('http://farmapp.channab.com/customers/api/customer-accounts/edit/$accountId/'); // Ensure this is the correct URL

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  Map<String, dynamic> body = {
    'name': name,
    'phone': phone,
    'opening_balance': openingBalance,
  };

  print('URL: $url'); // Debugging: Print the URL
  print('Headers: $headers'); // Debugging: Print the headers
  print('Body: $body'); // Debugging: Print the body

  try {
    var response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}'); // Debugging: Print the response status
    print('Response Body: ${response.body}'); // Debugging: Print the response body

    if (response.statusCode == 200) {
      print('Customer account profile edited successfully');
      return true;
    } else {
      print('Failed to edit customer account profile: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error editing customer account profile: $e');
    return false;
  }
}


Future<bool> addTransaction({
  required int customerAccountId,
  required DateTime date,
  required TimeOfDay time,
  required double amount,
  required String transactionType, // 'Take' or 'Given'
  String notes = '',
  String? attachmentPath,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');

  String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  String formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  print("Sending Transaction Data:");
  print("Customer Account ID: $customerAccountId");
  print("Date: $formattedDate");
  print("Time: $formattedTime");
  print("Amount: $amount");
  print("Transaction Type: $transactionType");
  print("Notes: $notes");
  // Note: For security reasons, be cautious about printing authentication tokens or sensitive information in a production environment

  var uri = Uri.parse('http://farmapp.channab.com/customers/api/add-transaction/');
  var request = http.MultipartRequest('POST', uri)
    ..fields['customer_account'] = customerAccountId.toString()
    ..fields['date'] = formattedDate
    ..fields['time'] = formattedTime
    ..fields['amount'] = amount.toString()
    ..fields['transaction_type'] = transactionType
    ..fields['notes'] = notes
    ..headers['Authorization'] = 'Token $authToken';

  if (attachmentPath != null) {
    print("Attaching file: $attachmentPath");
    request.files.add(await http.MultipartFile.fromPath('attachment', attachmentPath));
  }

  var response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode == 201) {
    print("Transaction created successfully.");
    print("Response Body: $responseBody");
    return true;
  } else {
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: $responseBody");
    return false;
  }
}
Future<List<Transaction>> fetchTransactions(BuildContext context, int customerAccountId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  final String apiUrl = 'http://farmapp.channab.com/customers/api/transactions/$customerAccountId/';

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  print('Fetching Transactions: $apiUrl'); // Print the URL
  print('Using Headers: $headers'); // Print the headers

  final response = await http.get(Uri.parse(apiUrl), headers: headers);

  print('Response Status: ${response.statusCode}'); // Print the response status code
  print('Response Body: ${response.body}'); // Print the response body

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    // Assuming your Transaction model has a fromJson factory constructor
    return jsonResponse.map((transaction) => Transaction.fromJson(transaction)).toList();
  } else {
    print('Failed to fetch transactions: ${response.statusCode}');
    throw Exception('Failed to load transactions');
  }
}



// Example function to update a transaction
Future<bool> updateTransaction(int transactionId, Map<String, dynamic> data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  final String apiUrl = 'http://farmapp.channab.com/customers/api/transaction/$transactionId/';

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  final response = await http.put(Uri.parse(apiUrl), headers: headers, body: json.encode(data));

  if (response.statusCode == 200) {
    // Successfully updated transaction
    return true;
  } else {
    // Failed to update transaction
    return false;
  }
}

// Example function to delete a transaction
Future<void> deleteTransaction(BuildContext context, int transactionId, String customerId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken');
  final String apiUrl = 'http://farmapp.channab.com/customers/api/transaction/$transactionId/';

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken',
  };

  final response = await http.delete(Uri.parse(apiUrl), headers: headers);

  if (response.statusCode == 204) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaction deleted successfully")));
    // Optionally, refresh the transaction list after deletion
    fetchTransactions(context, int.parse(customerId)); // Assuming fetchTransactions is adapted to take context and customerId
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete transaction")));
  }
}



