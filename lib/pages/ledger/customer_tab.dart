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
                color: Colors.blue.value, // This is just an example, adjust as needed
                name: customer.customerName,

                remarks: customer.totalBalance, // Assuming totalBalance is a property of your CustomerAccount model
                type: 'Transaction Type', // Adjust based on your data
                date: 'Transaction Date', // Adjust based on your data
                openingBalance: customer.openingBalance, // Ensure this property exists and is passed
                onTap: () {
                  // Adjust according to how you want to handle taps
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDetailPage(
                        name: customer.customerName,
                        totalBalance: customer.totalBalance,
                        mobileNumber: customer.mobileNumber,
                        customerId: customer.id.toString(),
                        opening_balance: customer.openingBalance.toString(), // Corrected parameter name
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
