import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ApiService.dart';
import '../../model/data.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isGiven;
  final String customerId; // Add customerId as a parameter
  final String customerName; // Add customerName as a parameter

  const AddTransactionScreen({
    Key? key,
    required this.isGiven,
    required this.customerId, // Ensure it's required or provide a default/fallback value
    required this.customerName, // Ensure it's required or provide a default/fallback value
  }) : super(key: key);


  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}


class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String selectedUser = 'User 1'; // This will be replaced with actual logic.
  // Assume customers list is populated either statically or from an API call for dropdown.
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Since selectedUser is used for dropdown, ensure the logic aligns with what you intend for customer selection.
    selectedUser = widget.customerId; // Pre-select the customer based on passed ID.
    print("AddTransactionScreen customerId: ${widget.customerId}"); // Print customerId to console.
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
        labelText: 'Customer Name',
        border: OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedUser = newValue!;
        });
      },
      items: customers.map<DropdownMenuItem<String>>((Customer customer) {
        return DropdownMenuItem<String>(
          value: customer.id.toString(),
          child: Text(customer.name),
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
          // Use widget.customerId directly for the customerAccountId
          String customerAccountId = widget.customerId;
          double amount = double.tryParse(_amountController.text) ?? 0;
          String transactionType = widget.isGiven ? "Given" : "Received";
          DateTime? date = _selectedDate;
          String? notes = _noteController.text.isNotEmpty ? _noteController.text : null;

          // Update the API call to use the correct customerAccountId
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
