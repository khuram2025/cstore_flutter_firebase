import 'package:flutter/material.dart';
import 'package:redesign_okcredit/model/data.dart'; // Import your Transaction model
import '../../../ApiService.dart'; // Adjust the path as necessary

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  EditTransactionScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _descriptionController = TextEditingController(text: widget.transaction.description);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _updateTransaction() async {
    final int transactionId = widget.transaction.id;
    Map<String, dynamic> updatedData = {
      "amount": _amountController.text,
      "description": _descriptionController.text,
      // Include other fields that are editable
    };
    return updateTransaction(transactionId, updatedData);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _updateTransaction();
      if (success) {
        Navigator.of(context).pop(true); // Pass true to indicate success
      } else {
        // Handle failure, show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
