// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart'; // تأكد من أن لديك هذا المسار الصحيح
import 'package:e_tourism/components/curd.dart'; // تأكد من وجود دالة getRequest

class TouristListPage extends StatefulWidget {
  @override
  _TouristListPageState createState() => _TouristListPageState();
}

class _TouristListPageState extends State<TouristListPage> {
  List<dynamic> _tourists = []; // قائمة لتخزين بيانات السياح
  bool _isLoading = true; // حالة التحميل

  @override
  void initState() {
    super.initState();
    _fetchTourists(); // استدعاء الدالة لجلب بيانات السياح عند تحميل الصفحة
  }

  Future<void> _fetchTourists() async {
    var response =
        await getRequest(touristView); // تأكد من أن لديك عنوان URL الصحيح

    if (response != null && response['status'] == 'success') {
      setState(() {
        _tourists = response['data']; // تخزين بيانات السياح
        _isLoading = false; // إنهاء حالة التحميل
      });
    } else {
      setState(() {
        _isLoading = false; // إنهاء حالة التحميل
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to load tourists.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editTourist(String touristId) {
    // إضافة كود للتعديل على معلومات السائح
    Navigator.pushNamed(context, 'edittourist', arguments: touristId);
  }

  void _deleteTourist(String touristId) async {
    // إضافة كود لحذف السائح
    var response = await postRequest(
        touristDelete, {'id': touristId}); // استخدام id للسائح
    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tourist deleted successfully!'),
        backgroundColor: Colors.green,
      ));
      _fetchTourists(); // تحديث قائمة السياح بعد الحذف
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to delete tourist.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourists List'), // تغيير عنوان الصفحة
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // دائرة تحميل
          : _tourists.isEmpty
              ? Center(
                  child:
                      Text('No tourists found.')) // رسالة في حال عدم وجود سياح
              : Padding(
                  padding: const EdgeInsets.all(8.0), // تقليل الهوامش الخارجية
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد الأعمدة في الشبكة
                      crossAxisSpacing: 8.0, // تقليل المسافة الأفقية
                      mainAxisSpacing: 2.0, // تقليل المسافة العمودية
                    ),
                    itemCount: _tourists.length,
                    itemBuilder: (context, index) {
                      var tourist = _tourists[index]; // السائح الحالي
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
                                '${tourist['name']}', // استخدام اسم السائح
                                style: TextStyle(
                                  fontSize: 25, // حجم الخط للنص
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 1), // تقليل المسافة
                              Text(
                                'Tour name: ${tourist['tour_name'] ?? ''}', // استخدام وصف السائح
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 4),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Phone: ${tourist['phone']}', // استخدام معرف السائح
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Email: ${tourist['email']}', // استخدام معرف السائح
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'registred_date: ${tourist['registered_date']}', // استخدام معرف السائح
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ), // تقليل المسافة
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _editTourist(
                                        tourist['tourist_id']
                                            .toString()), // إرسال معرف السائح
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
                                    onPressed: () => _deleteTourist(
                                        tourist['tourist_id']
                                            .toString()), // إرسال id
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
