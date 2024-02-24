import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isGiven; // Add this member variable

  const AddTransactionScreen({Key? key, required this.isGiven}) : super(key: key); // Update constructor

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now().subtract(Duration(microseconds: DateTime.now().microsecond));
  bool isGiven = false; // Add this variable

  @override
  void initState() {
    super.initState();
    isGiven = widget.isGiven; // Access the value passed from the previous screen
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save transaction logic
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAmountSection(),
          _buildDateAndAddBillsSection(),
          _buildNoteSection(),

        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Text(
            '₹5',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          // Include additional widgets if needed, like an input field for amount
        ],
      ),
    );
  }

  Widget _buildDateAndAddBillsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          DropdownButtonFormField<DateTime>(
            value: _selectedDate,
            decoration: InputDecoration(
              labelText: 'Date',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onChanged: (DateTime? newValue) {
              setState(() {
                if (newValue != null) {
                  _selectedDate = newValue;
                }
              });
            },
            items: [DateTime.now()]
                .map<DropdownMenuItem<DateTime>>((DateTime value) {
              return DropdownMenuItem<DateTime>(
                value: value,
                child: Text(DateFormat('MMM dd, yyyy').format(value)),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Logic to add bills
            },
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add Bills'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: 'Add note (Optional)',
          suffixIcon: Icon(Icons.note),
        ),
      ),
    );
  }

}
