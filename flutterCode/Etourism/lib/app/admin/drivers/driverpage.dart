// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers Management',
            style: TextStyle(color: Colors.white)),
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
            // زر إضافة سائق
            _buildDriverButton(
              context: context,
              title: 'Add\nDriver', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "adddriver"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر حذف سائق
            _buildDriverButton(
              context: context,
              title: 'Remove\nDriver', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "deletedriver"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر تعديل معلومات سائق
            _buildDriverButton(
              context: context,
              title: 'Edit\nDriver', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "editdriver"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر عرض معلومات جميع السائقين
            _buildDriverButton(
              context: context,
              title: 'View\nAll Drivers', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "viewdriver"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverButton({
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
        // استخدام Column لوضع النص في عدة سطور
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
