// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart'; // تأكد من أن لديك هذا المسار الصحيح
import 'package:e_tourism/components/curd.dart'; // تأكد من وجود دالة getRequest

class ProgrammeListPage extends StatefulWidget {
  @override
  _ProgrammeListPageState createState() => _ProgrammeListPageState();
}

class _ProgrammeListPageState extends State<ProgrammeListPage> {
  List<dynamic> _programmes = []; // قائمة لتخزين بيانات البرامج
  bool _isLoading = true; // حالة التحميل

  @override
  void initState() {
    super.initState();
    _fetchProgrammes(); // استدعاء الدالة لجلب بيانات البرامج عند تحميل الصفحة
  }

  Future<void> _fetchProgrammes() async {
    var response =
        await getRequest(programmeView); // تأكد من أن لديك عنوان URL الصحيح

    if (response != null && response['status'] == 'success') {
      setState(() {
        _programmes = response['data']; // تخزين بيانات البرامج
        _isLoading = false; // إنهاء حالة التحميل
      });
    } else {
      setState(() {
        _isLoading = false; // إنهاء حالة التحميل
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to load programmes.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editProgramme(String programmeId) {
    // إضافة كود للتعديل على معلومات البرنامج
    Navigator.pushNamed(context, 'editprogramme', arguments: programmeId);
  }

  void _deleteProgramme(String programmeName) async {
    // إضافة كود لحذف البرنامج بناءً على الاسم
    var response = await postRequest(
        programmeDelete, {'name': programmeName}); // استخدام name
    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Programme deleted successfully!'),
        backgroundColor: Colors.green,
      ));
      _fetchProgrammes(); // تحديث قائمة البرامج بعد الحذف
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to delete programme.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programmes List'), // تغيير العنوان إلى "قائمة البرامج"
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // دائرة تحميل
          : _programmes.isEmpty
              ? Center(
                  child: Text(
                      'No programmes found.')) // رسالة في حال عدم وجود برامج
              : Padding(
                  padding: const EdgeInsets.all(8.0), // تقليل الهوامش الخارجية
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد الأعمدة في الشبكة
                      crossAxisSpacing: 8.0, // تقليل المسافة الأفقية
                      mainAxisSpacing: 2.0, // تقليل المسافة العمودية
                    ),
                    itemCount: _programmes.length,
                    itemBuilder: (context, index) {
                      var programme = _programmes[index]; // البرنامج الحالي
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // تقليل الزوايا
                        ),
                        elevation: 5, // تقليل الظل
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0), // ضبط الهوامش الداخلية
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${programme['name']}', // تغيير العنوان إلى اسم البرنامج
                                style: TextStyle(
                                  fontSize: 25, // حجم الخط للنص
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4), // تقليل المسافة
                              Text(
                                'Description: ${programme['description'] ?? 'N/A'}', // عرض الوصف
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Start Date: ${programme['start_date'] ?? 'N/A'}', // عرض تاريخ البداية
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'End Date: ${programme['end_date'] ?? 'N/A'}', // عرض تاريخ النهاية
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Driver: ${programme['driverName'] ?? 'N/A'}', // عرض اسم السائق
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 1), // تقليل المسافة
                              Text(
                                'Guide: ${programme['guideName'] ?? 'N/A'}', // عرض اسم المرشد
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 1), // تقليل المسافة
                              Text(
                                'Price: \$${programme['price'] ?? 'N/A'}', // عرض السعر
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 4), // تقليل المسافة
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _editProgramme(
                                        programme['id']
                                            .toString()), // إرسال معرف البرنامج
                                    child: Text(
                                      'Edit',
                                      style:
                                          TextStyle(fontSize: 20), // حجم النص
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xFF33579B), // لون الزر
                                      foregroundColor:
                                          Colors.white, // لون النص أبيض
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              20), // زيادة المسافة الداخلية
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteProgramme(
                                        programme['name']), // إرسال name
                                    child: Text(
                                      'Delete',
                                      style:
                                          TextStyle(fontSize: 20), // حجم النص
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // لون الزر
                                      foregroundColor:
                                          Colors.white, // لون النص أبيض
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              20), // زيادة المسافة الداخلية
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
