// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';

class AddDriverPage extends StatefulWidget {
  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isLoading = false;

  // دالة لإضافة سائق
  Future<void> _addDriver() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      Map<String, dynamic> data = {
        'driverName': _driverNameController.text,
        'fName': _fNameController.text,
        'lName': _lNameController.text,
        'plateNumber': _plateNumberController.text,
        'description': _descriptionController.text,
      };

      var response = await postRequest(driverAdd, data);

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Driver added successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to add driver: ${response?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: Container(
        color: backgroundColor, // لون الخلفية (يمكنك تغييره حسب الرغبة)
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _driverNameController,
                decoration: const InputDecoration(labelText: 'Driver Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _fNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _plateNumberController,
                decoration: const InputDecoration(labelText: 'Plate Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plate number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _addDriver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // المسافة الداخلية
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Add Driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
