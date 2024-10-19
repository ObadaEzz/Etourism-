// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:e_tourism/constant/colorconfig.dart'; // إضافة لون الخلفية والأزرار

class DeleteTourPage extends StatefulWidget {
  @override
  _DeleteTourPageState createState() => _DeleteTourPageState();
}

class _DeleteTourPageState extends State<DeleteTourPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(); // استخدام معرف البرنامج فقط

  bool isLoading = false;

  // دالة لحذف البرنامج
  Future<void> _deleteTour() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      // إعداد البيانات للحذف
      String name = _nameController.text.trim(); // استخدام معرف البرنامج
      Map<String, dynamic> data = {
        'name': name, // إرسال معرف البرنامج
      };

      var response = await postRequest(tourDelete, data); // إرسال طلب الحذف

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      // التعامل مع الاستجابة
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tour deleted successfully!'),
          backgroundColor: Colors.green,
        ));
      } else if (response != null && response['status'] == 'fail') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tour not found. No action taken.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to delete tour: ${response?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Tour'), // تغيير العنوان إلى "حذف برنامج"
        backgroundColor: Color(0xFF33579B), // شريط العنوان باللون الأزرق
      ),
      body: Container(
        color: backgroundColor, // لون الخلفية
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Tour Name', // تغيير العنوان إلى معرف البرنامج
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tour name'; // رسالة الخطأ إذا كان المدخل فارغًا
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _deleteTour,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // مسافة داخلية للزر
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Delete Tour'), // تغيير النص إلى "حذف برنامج"
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }
}
