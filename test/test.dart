import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerDetailPage extends StatelessWidget {
  final String name;
  final String balanceDue; // Define balanceDue as a member variable

  // Modify the constructor to accept balanceDue.
  const CustomerDetailPage({
    Key? key,
    required this.name,
    required this.balanceDue, // Add balanceDue as a required parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Action for edit
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Action for more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Your other widgets here...
          _buildTransactionsHeader(context),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your actual number of transactions
              itemBuilder: (context, index) {
                return _buildTransactionItem(
                  context,
                  // Replace with your actual transaction data
                  date: DateTime.now(),
                  description: 'Description of the transaction goes here...',
                  amount: '₹100',
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
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

  Widget _buildTransactionItem(BuildContext context, {required DateTime date, required String description, required String amount}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            DateFormat('dd/MM/yyyy').format(date),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description.length > 10 ? '${description.substring(0, 10)}...' : description,
          ),
          trailing: Text(
            amount,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          isThreeLine: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit action
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete action
              },
            ),
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {
                // Attachment action
              },
            ),
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                // View detail action
              },
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

// Your _buildBottomSheet and other methods...
}
