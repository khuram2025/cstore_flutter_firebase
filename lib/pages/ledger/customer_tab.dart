import 'package:flutter/material.dart';

import '../../ApiService.dart';
import '../../widgets/ledger/transaction_tile.dart';
import 'customer/customerDetail.dart';

class CustomerTab extends StatefulWidget {
  const CustomerTab({super.key});

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  List<dynamic> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers().then((data) {
      setState(() {
        customers = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: customers.map((customer) {
              // Assuming 'color' is an integer representation of a color in your customer data
              int customerColor = customer['color'] ?? 0xff5099f5; // Default color if not provided

              return TransactionTile(
                color: customerColor,
                name: customer['name'] ?? 'Unknown', // Provide a fallback for an empty or null name
                amount: customer['amount'].toString(), // Convert to string if necessary
                remarks: customer['remarks'] ?? 'No Remarks', // Provide a fallback for null remarks
                type: customer['type'] ?? 'Payment', // Provide a fallback for null type
                date: customer['date'] ?? 'Unknown Date', // Provide a fallback for null date
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerDetailPage(
                      name: customer['name'],
                      balanceDue: customer['balanceDue'].toString(), // Assuming you still need to pass this
                      mobileNumber: customer['phone'] ?? 'No Mobile Number', // Assuming 'mobileNumber' is the key
                    )),
                  );
                },

              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


