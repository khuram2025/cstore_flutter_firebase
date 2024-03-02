import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ApiService.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isGiven;

  const AddTransactionScreen({Key? key, required this.isGiven}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String selectedUser = 'User 1';
  List<String> users = ['User 1', 'User 2', 'User 3'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserDropdown(),
              _buildAmountInput(),
              _buildDateTimeInput(context),
              _buildNoteInput(),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedUser,
      decoration: InputDecoration(
        labelText: 'User Name',
        border: OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedUser = newValue!;
        });
      },
      items: users.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildAmountInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        controller: _amountController,
        decoration: InputDecoration(
          labelText: 'Amount',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDateTimeInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2025),
          );
          if (pickedDate != null) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_selectedDate),
            );
            if (pickedTime != null) {
              setState(() {
                _selectedDate = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
              });
            }
          }
        },
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Date and Time',
              hintText: DateFormat('yyyy-MM-dd – HH:mm').format(_selectedDate),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: 'Note',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        maxLines: 3,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity, // Use full width
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        child: Text('Submit', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          // Assuming selectedUser somehow maps to customerAccountId
          String customerAccountId = "appropriate_customer_account_id"; // This should be set based on your application's logic
          double amount = double.tryParse(_amountController.text) ?? 0;
          String transactionType = widget.isGiven ? "Given" : "Received";
          DateTime? date = _selectedDate;
          String? notes = _noteController.text.isNotEmpty ? _noteController.text : null;

          // Call createTransaction with dynamic values
          bool result = await createTransaction(
            customerAccountId: customerAccountId,
            amount: amount,
            transactionType: transactionType,
            date: date,
            time: TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute),
            notes: notes,
            // attachmentPath: You would handle attachment upload separately
          );

          if (result) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction added successfully')));
            Navigator.pop(context); // Optionally pop back to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add transaction')));
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green, // Green background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }




}
