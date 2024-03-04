import 'package:flutter/material.dart';
// Import ApiService or the specific file where fetchCustomerAccounts is defined
import '../../ApiService.dart';
import '../../model/data.dart';
import '../../widgets/ledger/transaction_tile.dart';
import 'customer/customerDetail.dart';

// Assuming CustomerAccount class is defined in ApiService or another imported file
// If not, make sure to import the file where CustomerAccount is defined

class CustomerTab extends StatefulWidget {
  const CustomerTab({Key? key}) : super(key: key);

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  List<CustomerAccount> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerAccounts().then((data) {
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
              // Adjust according to the actual fields of CustomerAccount and your UI requirements
              return TransactionTile(
                color: Colors.blue.value, // Convert MaterialColor to int

                name: customer.customerName,
                amount: customer.openingBalance,
                remarks: 'No Remarks', // Adjust based on your data
                type: 'Payment', // Adjust based on your data
                date: 'Unknown Date', // Adjust based on your data
                onTap: () {
                  // Adjust according to how you want to handle taps
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDetailPage(
                        name: customer.customerName,
                        balanceDue: customer.openingBalance,
                        mobileNumber: customer.mobileNumber,
                        customerId: customer.id.toString(),
                      ),
                    ),
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
