// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';

class UpdateTouristPage extends StatefulWidget {
  @override
  _UpdateTouristPageState createState() => _UpdateTouristPageState();
}

class _UpdateTouristPageState extends State<UpdateTouristPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _touristIdController =
      TextEditingController(); // معرف السائح
  final TextEditingController _nameController =
      TextEditingController(); // اسم السائح
  final TextEditingController _emailController =
      TextEditingController(); // البريد الإلكتروني
  final TextEditingController _phoneController =
      TextEditingController(); // رقم الهاتف
  final TextEditingController _registeredDateController =
      TextEditingController(); // تاريخ التسجيل

  bool isLoading = false;

  // دالة لتحديث معلومات السائح
  Future<void> _updateTourist() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      // إعداد البيانات للتحديث
      Map<String, dynamic> data = {
        'id': _touristIdController.text.trim(), // معرف السائح
        'name': _nameController.text.trim(), // اسم السائح
        'email': _emailController.text.trim(), // البريد الإلكتروني
        'phone': _phoneController.text.trim(), // رقم الهاتف
        'registered_date':
            _registeredDateController.text.trim(), // تاريخ التسجيل
      };

      var response =
          await postRequest(touristUpdate, data); // إرسال طلب التحديث

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      // التعامل مع الاستجابة
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tourist information updated successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to update tourist information: ${response?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // لون الخلفية
      appBar: AppBar(
        title: Text('Update Tourist'),
        backgroundColor: Color(0xFF33579B), // شريط العنوان باللون الأزرق
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _touristIdController,
                decoration: const InputDecoration(
                  labelText: 'Tourist ID', // تغيير العنوان إلى معرف السائح
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tourist ID'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name', // عنوان الاسم
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email', // عنوان البريد الإلكتروني
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone', // عنوان رقم الهاتف
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registeredDateController,
                decoration: const InputDecoration(
                  labelText: 'Registered Date', // عنوان تاريخ التسجيل
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter registered date'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _updateTourist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // مسافة داخلية للزر
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Update Tourist'), // نص الزر
              ),
            ],
          ),
        ),
      ),
    );
  }
}
