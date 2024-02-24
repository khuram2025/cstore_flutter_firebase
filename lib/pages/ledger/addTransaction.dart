import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isGiven; // Flag to determine if the transaction is "Given" or "Received"

  const AddTransactionScreen({Key? key, required this.isGiven}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Text(
              'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Add Note (optional)',
              suffixIcon: Icon(Icons.note_add),
            ),
            onChanged: (value) {
              _note = value;
            },
          ),
          Spacer(),
          _buildNumberPad(),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              // Logic to handle transaction submission
            },
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Container(
      padding: EdgeInsets.all(16),
      // Optional: Adjust your layout according to the design
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3].map((i) => _buildNumberPadButton(i.toString())).toList(),
          ),
          // Add more rows for each number
          // Add last row for decimal, zero, and operations (if needed)
        ],
      ),
    );
  }

  Widget _buildNumberPadButton(String value) {
    return TextButton(
      onPressed: () {
        setState(() {
          _amountController.text += value;
        });
      },
      child: Text(value, style: TextStyle(fontSize: 24)),
    );
  }
}
