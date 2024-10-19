// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:e_tourism/constant/colorconfig.dart'; // إضافة لون الخلفية والأزرار

class DeleteDriverPage extends StatefulWidget {
  @override
  _DeleteDriverPageState createState() => _DeleteDriverPageState();
}

class _DeleteDriverPageState extends State<DeleteDriverPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController =
      TextEditingController(); // استخدام رقم اللوحة فقط

  bool isLoading = false;

  // دالة لحذف السائق
  Future<void> _deleteDriver() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      // إعداد البيانات للحذف
      String driverName = _driverNameController.text.trim();
      Map<String, dynamic> data = {
        'driverName': driverName, // استخدام رقم اللوحة فقط
      };

      var response = await postRequest(driverDelete, data); // إرسال طلب الحذف

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      // التعامل مع الاستجابة
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Driver deleted successfully!'),
          backgroundColor: Colors.green,
        ));
      } else if (response != null && response['status'] == 'fail') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Driver not found. No action taken.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to delete driver: ${response?['message'] ?? 'Unknown error'}'),
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
        title: Text('Delete Driver'),
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
                  labelText: 'Driver Name', // تغيير العنوان إلى رقم اللوحة
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _deleteDriver,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // مسافة داخلية للزر
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Delete Driver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
