// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class ProgrammePage extends StatelessWidget {
  const ProgrammePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Programs Management',
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
            // زر إضافة برنامج
            _buildProgrammeButton(
              context: context,
              title: 'Add\nProgramme', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "addprogramme"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر حذف برنامج
            _buildProgrammeButton(
              context: context,
              title: 'Remove\nProgramme', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "deleteprogramme"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر تعديل معلومات برنامج
            _buildProgrammeButton(
              context: context,
              title: 'Edit\nProgramme', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "editprogramme"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
            // زر عرض معلومات جميع البرامج
            _buildProgrammeButton(
              context: context,
              title: 'View\nAll Programmes', // النص مقسم إلى سطرين
              onPressed: () {
                Navigator.pushNamed(context,
                    "viewprogramme"); // قم بتغيير اسم الصفحة إلى ما يناسبك
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammeButton({
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
