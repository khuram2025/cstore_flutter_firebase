import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign_okcredit/pages/ledger/addTransaction.dart';

import '../../../ApiService.dart';
import '../../../constants.dart';
import '../../../model/data.dart';
import '../../../widgets/ledger/buildReceivedGivenIndicators.dart';
import 'customerProfileedit.dart';

class CustomerDetailPage extends StatelessWidget {
  final String name;

  final String mobileNumber;
  final String totalBalance;
  final String customerId;
  final String opening_balance;

  CustomerDetailPage({
    Key? key,
    required this.name,

    required this.totalBalance,
    required this.mobileNumber,
    required this.customerId,
    required this.opening_balance,
  }) : super(key: key) {
    print("Opening Balance Received: $opening_balance");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name ($mobileNumber)'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerProfileEdit(
                    name: name,
                    mobileNumber: mobileNumber,
                    customerId: customerId,
                    openingBalance: opening_balance, // Corrected from opening_balance to openingBalance
                  ),
                ),

              );

            },
          ),
        ],
      ),
      body: Column(
        children: [
          ReceivedGivenIndicators(totalBalance: totalBalance),
          _buildTransactionsHeader(context),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: fetchTransactions(int.parse(customerId)),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final transactions = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionItem(context, transaction: transaction);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transactions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            'Filter',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBalanceDueSection(),
          SizedBox(height: 16),
          _buildReminderButtons(),
          SizedBox(height: 16),
          _buildReceivedGivenButtons(context),
        ],
      ),
    );
  }

  Widget _buildBalanceDueSection() {
    // Assuming totalBalance is a String that may include a minus sign for negative values
    final bool isBalancePositive = !totalBalance.startsWith('-');
    final Color balanceColor = isBalancePositive ? Colors.red : Colors.green;

    // If you want to remove the minus sign for display, you can conditionally format the string
    final String displayBalance = isBalancePositive ? totalBalance : totalBalance.substring(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Balance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          'Rs.$displayBalance',
          style: TextStyle(
            color: balanceColor, // Color based on positive or negative balance
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }



  Widget _buildReminderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          icon: Icon(Icons.calendar_today, color: Colors.green),
          label: Text('Reminder Date', style: TextStyle(color: Colors.green)),
          onPressed: () {
            // Action for setting reminder date
          },
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.notifications_active, color: Colors.white),
          label: Text('Remind'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
          ),
          onPressed: () {
            // Action for remind
          },
        ),
      ],
    );
  }
  Widget _buildReceivedGivenButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Use `name` and `customerId` directly here
        _buildActionButton(context, Icons.call_received, 'Received', Colors.green, name, customerId),
        _buildActionButton(context, Icons.call_made, 'Given', Colors.red, name, customerId),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, String customerName, String customerId) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              isGiven: label == 'Given',
              customerId: customerId,
              customerName: name,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }


  Widget _buildTransactionItem(BuildContext context, {required Transaction transaction}) {
    // Parse the amount to a double
    final double amount = double.parse(transaction.amount);

    // Determine if the amount is a whole number
    final bool isWholeNumber = amount == amount.truncate();

    // Format the amount based on whether it's a whole number or not
    final String formattedAmount = isWholeNumber ? '${amount.toInt()}' : amount.toStringAsFixed(2);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(transaction.date),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (transaction.time != null) // Check if time is provided
                      Text(
                        transaction.time!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  transaction.description,
                  style: TextStyle(color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Rs.$formattedAmount', // Use formatted amount here
                  style: TextStyle(
                    color: transaction.transactionType == 'Given' ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: kHighLightColor, // Use your constant color here
          height: 5, // Adjust thickness
        ),
      ],
    );
  }



}
