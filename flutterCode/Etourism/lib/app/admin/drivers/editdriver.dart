// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';

class UpdateDriverPage extends StatefulWidget {
  @override
  _UpdateDriverPageState createState() => _UpdateDriverPageState();
}

class _UpdateDriverPageState extends State<UpdateDriverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController =
      TextEditingController(); // رقم اللوحة
  final TextEditingController _plateNumberController =
      TextEditingController(); // رقم اللوحة
  final TextEditingController _fNameController =
      TextEditingController(); // الاسم الأول
  final TextEditingController _lNameController =
      TextEditingController(); // الاسم الأخير
  final TextEditingController _descriptionController =
      TextEditingController(); // الوصف

  bool isLoading = false;

  // دالة لتحديث معلومات السائق
  Future<void> _updateDriver() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      // إعداد البيانات للتحديث
      Map<String, dynamic> data = {
        'driverName': _driverNameController.text.trim(),
        'plateNumber': _plateNumberController.text.trim(), // رقم اللوحة
        'fName': _fNameController.text.trim(), // الاسم الأول
        'lName': _lNameController.text.trim(), // الاسم الأخير
        'description': _descriptionController.text.trim(), // الوصف
      };

      var response = await postRequest(driverUpdate, data); // إرسال طلب التحديث

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      // التعامل مع الاستجابة
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Driver information updated successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to update driver information: ${response?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // خلفية زرقاء
      appBar: AppBar(
        title: Text('Update Driver'),
        backgroundColor: Color(0xFF33579B), // شريط العنوان باللون الأزرق
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _driverNameController,
                decoration: const InputDecoration(
                  labelText: 'Driver Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _plateNumberController,
                decoration: const InputDecoration(
                  labelText: 'Plate Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plate number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _updateDriver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // مسافة داخلية للزر
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Update Driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
