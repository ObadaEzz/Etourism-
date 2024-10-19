// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guides Management',
          style: TextStyle(color: Colors.white), // تعديل لون العنوان إلى الأبيض
        ),
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: Container(
        color: backgroundColor, // لون الخلفية (يمكنك تغييره حسب الرغبة)
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // عدد الأعمدة في الشبكة
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // زر إضافة مرشد
            _buildGuideButton(
              context: context,
              title: 'Add\nGuide', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "addguide"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر حذف مرشد
            _buildGuideButton(
              context: context,
              title: 'Remove\nGuide', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "deleteguide"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر تعديل معلومات مرشد
            _buildGuideButton(
              context: context,
              title: 'Edit\nGuide', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "editguide"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر عرض معلومات جميع المرشدين
            _buildGuideButton(
              context: context,
              title: 'View\nAll Guides', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "viewguide"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideButton({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF33579B), // لون الزر
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // زوايا دائرية
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // محاذاة العمود في المنتصف
        children: [
          Text(
            title,
            textAlign: TextAlign.center, // محاذاة النص في المنتصف
            style: TextStyle(fontSize: 18), // حجم الخط
          ),
        ],
      ),
    );
  }
}
