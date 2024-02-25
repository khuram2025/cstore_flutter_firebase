import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

              _buildInvoiceUploadRow(),
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

  Widget _buildInvoiceUploadRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Upload Invoice',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Logic to take a photo for the invoice
            },
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              // Logic to select an invoice image from the gallery
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        child: Text('Submit', style: TextStyle(color: Colors.white)),
        onPressed: () {
          // Submit logic
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

