import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ApiService.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/custom_text_field.dart';

class CustomerProfileEdit extends StatefulWidget {
  final String? name;
  final String? mobileNumber;
  final String openingBalance;
  final String customerId;

  const CustomerProfileEdit({
    Key? key,
    this.name,
    this.mobileNumber,
    required this.openingBalance,
    required this.customerId,
  }) : super(key: key);

  @override
  _CustomerProfileEditState createState() => _CustomerProfileEditState();
}



class _CustomerProfileEditState extends State<CustomerProfileEdit> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _openingBalanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _mobileNumberController = TextEditingController(text: widget.mobileNumber ?? '');
    _openingBalanceController = TextEditingController(text: widget.openingBalance);
    print("Opening Balance in Edit: ${widget.openingBalance}"); // Debug print
  }



  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _mobileNumberController.text.isEmpty || _openingBalanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields'),
      ));
      return;
    }
    String accountId = widget.customerId;


    bool result = await editCustomerAccountProfile(
      int.parse(accountId),
      _nameController.text,
      _mobileNumberController.text,
      _openingBalanceController.text,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile Updated Successfully'),
      ));
      // Optionally pop the current route to return back
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update profile'),
      ));
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: const CustomBackButton(title: '',),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 24.0),
                ),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _nameController,
                hintText: 'Name',
                prefixIcon: Icons.person,
                label: 'Name*',
                textInputType: TextInputType.name,
              ),
              CustomTextField(
                controller: _mobileNumberController,
                hintText: 'Mobile Number',
                prefixIcon: Icons.phone,
                label: 'Mobile Number*',
                textInputType: TextInputType.phone,
              ),
              CustomTextField(
                controller: _openingBalanceController,
                hintText: 'Opening Balance',
                prefixIcon: Icons.account_balance_wallet,
                label: 'Opening Balance',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                onTap: _saveChanges,
                title: 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
