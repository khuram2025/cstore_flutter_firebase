import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign_okcredit/pages/ledger/addTransaction.dart';

class CustomerDetailPage extends StatelessWidget {
  final String name;
  final String balanceDue;
  final String mobileNumber;
  final String customerId;

   CustomerDetailPage({
    Key? key,
    required this.name,
    required this.balanceDue,
    required this.mobileNumber,
    required this.customerId,
  }) : super(key: key) {
    print("CustomerDetailPage customerId: $customerId"); // Add this line
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name ($mobileNumber)'), // Display both name and mobile number
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

  Widget _buildTransactionItem(BuildContext context,
      {required DateTime date, required String description, required String amount}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add horizontal padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and Time Column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(date),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.jm().format(date), // Format time
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]), // Match icon size
                    ),
                  ],
                ),
              ),
              // Description and Icons Row
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.length > 10
                          ? '${description.substring(0, 10)}...'
                          : description,
                      style: TextStyle(color: Colors.grey[600]), // Lighter font for description
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                          onPressed: () {
                            // Edit action
                          },
                          padding: EdgeInsets.zero, // Reduces default padding
                          constraints: BoxConstraints(), // Limits hit area to icon size
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.grey[600]),
                          onPressed: () {
                            // Delete action
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file, size: 20, color: Colors.grey[600]),
                          onPressed: () {
                            // Attachment action
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        IconButton(
                          icon: Icon(Icons.visibility, size: 20, color: Colors.grey[600]),
                          onPressed: () {
                            // View detail action
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Amount Text
              Expanded(
                flex: 1,
                child: Text(
                  amount,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Divider(), // Divider after each transaction item
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Balance Due',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          balanceDue,
          style: TextStyle(
            color: Colors.red,
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

}
