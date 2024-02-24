import 'package:flutter/material.dart';

import '../addTransaction.dart';


class CustomerDetailPage extends StatelessWidget {
  final String name; // Assuming you pass the customer's name
  final String balanceDue = '₹100'; // Replace with actual balance

  const CustomerDetailPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Action for more options
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.orange, // Replace with the appropriate color
            child: Text(
              'Your customer can see this account. Know More',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today', style: TextStyle(color: Colors.grey)),
                    Text(balanceDue, style: TextStyle(color: Colors.red)),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('03:30 am', style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('$balanceDue DUE', style: TextStyle(color: Colors.red)),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Balance Due $balanceDue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Action for setting reminder
                      },
                      icon: Icon(Icons.calendar_today), // Corrected to use Material Icons
                      label: Text('Reminder Date'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action for remind
                      },
                      child: Text('Remind'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(context, Icons.call_received, 'Received', Colors.green),
                    _buildActionButton(context, Icons.call_made, 'Given', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // Navigate to the AddTransactionScreen when the button is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransactionScreen(isGiven: label == 'Given')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

}
