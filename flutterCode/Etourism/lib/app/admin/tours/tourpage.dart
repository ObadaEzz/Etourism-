// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class TourPage extends StatelessWidget {
  const TourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tours Management',
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
            // زر إضافة رحلة
            _buildTourButton(
              context: context,
              title: 'Add\nTour', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "addtour"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر حذف رحلة
            _buildTourButton(
              context: context,
              title: 'Remove\nTour', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "deletetour"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر تعديل معلومات رحلة
            _buildTourButton(
              context: context,
              title: 'Edit\nTour', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "edittour"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر عرض معلومات جميع الرحلات
            _buildTourButton(
              context: context,
              title: 'View\nAll Tours', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(
                    context, "viewtour"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourButton({
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
