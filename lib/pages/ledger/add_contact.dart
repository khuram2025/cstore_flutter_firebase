import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../ApiService.dart';
import '../../constants.dart';
import '../../model/data.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/add_contact/section_card.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  static const id = '/addContactPage';

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Consumer<DataModel>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomBackButton(title: 'Add Contact'),
                    CustomButton(
                      onTap: () {},
                      icon: Icons.contacts,
                      title: 'Select Contact',
                    ),
                    const SizedBox(height: 25.0),
                    const Row(
                      children: [
                        CustomDivider(),
                        Text(
                          'OR',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomDivider(),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    SectionCard(
                      children: [
                        const Text(
                          'Select Category',
                          style: kSectionHeaderStyle,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: const Text('Customer'),
                                value: 'Customer',
                                contentPadding: const EdgeInsets.all(0),
                                groupValue: value.selectedCustomerCategory,
                                onChanged: (String? newValue) => value.updateCustomerCategory(newValue!),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: const Text('Supplier'),
                                value: 'Supplier',
                                groupValue: value.selectedCustomerCategory,
                                onChanged: (String? newValue) => value.updateCustomerCategory(newValue!),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SectionCard(
                      children: [
                        Text(
                          '${value.selectedCustomerCategory} Details',
                          style: kSectionHeaderStyle,
                        ),
                        const SizedBox(height: 15.0),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'User name',
                          prefixIcon: Icons.person,
                          label: 'Name*',
                          textInputType: TextInputType.name,
                          maxLength: 20,
                        ),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'XXXXXXXXXX (Optional)',
                          prefixIcon: Icons.call,
                          label: 'Number',
                          textInputType: TextInputType.number,
                          maxLength: 10,
                        ),
                      ],
                    ),
                    CustomButton(
                      onTap: () async {
                        int businessId = 1;
                        String name = _nameController.text;
                        String phone = _phoneController.text;

                        bool success = await createOrLinkCustomer(name, phone, businessId);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Customer added successfully'))
                          );

                          // Navigate back to customer list route
                          Navigator.pop(context); // Assuming your customer list is the previous page

                          // Or, if you have a named route for the customer list:
                          // Navigator.pushReplacementNamed(context, YourCustomerListRoute.id);

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add customer'))
                          );
                        }
                      },
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10.0),
                      title: 'Confirm',
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
