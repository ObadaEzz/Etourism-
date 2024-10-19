// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';

class UpdateGuidePage extends StatefulWidget {
  @override
  _UpdateGuidePageState createState() => _UpdateGuidePageState();
}

class _UpdateGuidePageState extends State<UpdateGuidePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _guideNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fNameController =
      TextEditingController(); // الاسم الأول
  final TextEditingController _lNameController =
      TextEditingController(); // الاسم الأخير
  final TextEditingController _descriptionController =
      TextEditingController(); // الوصف

  bool isLoading = false;

  @override
  void dispose() {
    // إلغاء Controllers عند الانتهاء لتجنب تسرب الذاكرة
    _guideNameController.dispose();
    _mobileController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // دالة لتحديث معلومات المرشد
  Future<void> _updateGuide() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // إعداد حالة التحميل
      });

      // إعداد البيانات للتحديث
      Map<String, dynamic> data = {
        'guideName': _guideNameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'fName': _fNameController.text.trim(), // الاسم الأول
        'lName': _lNameController.text.trim(), // الاسم الأخير
        'description': _descriptionController.text.trim(), // الوصف
      };

      var response = await postRequest(guideUpdate, data); // إرسال طلب التحديث

      setState(() {
        isLoading = false; // إنهاء حالة التحميل
      });

      // التعامل مع الاستجابة
      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Guide information updated successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to update guide information: ${response?['message'] ?? 'Unknown error'}'),
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
        title: Text('Update Guide'),
        backgroundColor: Color(0xFF33579B), // شريط العنوان باللون الأزرق
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _guideNameController,
                decoration: const InputDecoration(
                  labelText: 'Guide Name',
                  hintText: 'Enter guide name', // إضافة نص إرشادي
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Guide Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter mobile number', // إضافة نص إرشادي
                ),
                keyboardType: TextInputType.phone, // إعداد نوع لوحة المفاتيح
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter first name', // إضافة نص إرشادي
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
                  hintText: 'Enter last name', // إضافة نص إرشادي
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
                  hintText: 'Enter description', // إضافة نص إرشادي
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _updateGuide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // لون الزر أزرق
                  foregroundColor: Colors.white, // لون النص أبيض
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // مسافة داخلية للزر
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Update Guide'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
