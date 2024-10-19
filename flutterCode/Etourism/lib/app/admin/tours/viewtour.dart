// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart'; // تأكد من أن لديك هذا المسار الصحيح
import 'package:e_tourism/components/curd.dart'; // تأكد من وجود دالة getRequest

class TourListPage extends StatefulWidget {
  @override
  _TourListPageState createState() => _TourListPageState();
}

class _TourListPageState extends State<TourListPage> {
  List<dynamic> _tours = []; // قائمة لتخزين بيانات البرامج
  bool _isLoading = true; // حالة التحميل

  @override
  void initState() {
    super.initState();
    _fetchTours(); // استدعاء الدالة لجلب بيانات البرامج عند تحميل الصفحة
  }

  Future<void> _fetchTours() async {
    var response =
        await getRequest(tourView); // تأكد من أن لديك عنوان URL الصحيح

    if (response != null && response['status'] == 'success') {
      setState(() {
        _tours = response['data']; // تخزين بيانات البرامج
        _isLoading = false; // إنهاء حالة التحميل
      });
    } else {
      setState(() {
        _isLoading = false; // إنهاء حالة التحميل
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to load tours.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editTour(String tourId) {
    // إضافة كود للتعديل على معلومات البرنامج
    Navigator.pushNamed(context, 'edittour', arguments: tourId);
  }

  void _deleteTour(String tourName) async {
    // إضافة كود لحذف البرنامج بناءً على الاسم
    var response =
        await postRequest(tourDelete, {'name': tourName}); // استخدام name
    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tour deleted successfully!'),
        backgroundColor: Colors.green,
      ));
      _fetchTours(); // تحديث قائمة البرامج بعد الحذف
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to delete tour.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tours List'), // تغيير العنوان إلى "قائمة البرامج"
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // دائرة تحميل
          : _tours.isEmpty
              ? Center(
                  child: Text('No tours found.')) // رسالة في حال عدم وجود برامج
              : Padding(
                  padding: const EdgeInsets.all(8.0), // تقليل الهوامش الخارجية
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد الأعمدة في الشبكة
                      crossAxisSpacing: 8.0, // تقليل المسافة الأفقية
                      mainAxisSpacing: 2.0, // تقليل المسافة العمودية
                    ),
                    itemCount: _tours.length,
                    itemBuilder: (context, index) {
                      var tour = _tours[index]; // البرنامج الحالي
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
                                '${tour['name']}', // تغيير العنوان إلى اسم البرنامج
                                style: TextStyle(
                                  fontSize: 25, // حجم الخط للنص
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4), // تقليل المسافة
                              Text(
                                'Description: ${tour['description'] ?? 'N/A'}', // عرض الوصف
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Start Date: ${tour['start_date'] ?? 'N/A'}', // عرض تاريخ البداية
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'End Date: ${tour['end_date'] ?? 'N/A'}', // عرض تاريخ النهاية
                                style:
                                    TextStyle(fontSize: 16), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Programme: ${tour['programmeName'] ?? 'N/A'}', // عرض اسم السائق
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),

                              SizedBox(height: 1), // تقليل المسافة
                              Text(
                                'Price: \$${tour['price'] ?? 'N/A'}', // عرض السعر
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 4), // تقليل المسافة
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _editTour(tour['id']
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
                                    onPressed: () =>
                                        _deleteTour(tour['name']), // إرسال name
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
