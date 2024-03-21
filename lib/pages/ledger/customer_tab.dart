import 'package:flutter/material.dart';
import '../../ApiService.dart'; // Make sure this import path is correct
import '../../model/data.dart'; // Make sure this import path is correct
// Include any other imports you need

class CustomerTab extends StatefulWidget {
  final String searchTerm;

  const CustomerTab({Key? key, required this.searchTerm}) : super(key: key);

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  List<CustomerAccount> _customers = [];
  List<CustomerAccount> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  void didUpdateWidget(covariant CustomerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchTerm != oldWidget.searchTerm) {
      _filterCustomers();
    }
  }

  void _fetchCustomers() async {
    var customersData = await fetchCustomerAccounts();
    setState(() {
      _customers = customersData;
      _filterCustomers();
    });
  }

  void _filterCustomers() {
    setState(() {
      _filteredCustomers = widget.searchTerm.isEmpty
          ? _customers
          : _customers.where((customer) {
        return customer.customerName.toLowerCase().contains(widget.searchTerm.toLowerCase()) ||
            customer.mobileNumber.contains(widget.searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _filteredCustomers.length,
        itemBuilder: (context, index) {
          var customer = _filteredCustomers[index];
          return ListTile(
            title: Text(customer.customerName),
            subtitle: Text('Mobile: ${customer.mobileNumber}'),
            onTap: () {
              // Navigate to customer details or handle tap
            },
          );
        },
      ),
    );
  }
}
