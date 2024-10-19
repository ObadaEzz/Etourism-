// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class TouristPage extends StatelessWidget {
  const TouristPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tourists Management',
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
            // زر إضافة سائح
            _buildTouristButton(
              context: context,
              title: 'Add\nTourist', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "addtourist"); // تغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر حذف سائح
            _buildTouristButton(
              context: context,
              title: 'Remove\nTourist', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "deletetourist"); // تغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر تعديل معلومات سائح
            _buildTouristButton(
              context: context,
              title: 'Edit\nTourist', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "edittourist"); // تغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر عرض معلومات جميع السياح
            _buildTouristButton(
              context: context,
              title: 'View\nAll Tourists', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "viewtourist"); // تغيير اسم الصفحة إلى ما يناسبك
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTouristButton({
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
