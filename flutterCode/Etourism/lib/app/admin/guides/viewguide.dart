// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:e_tourism/components/curd.dart';

class GuideListPage extends StatefulWidget {
  @override
  _GuideListPageState createState() => _GuideListPageState();
}

class _GuideListPageState extends State<GuideListPage> {
  List<dynamic> _guides = []; // قائمة لتخزين بيانات المرشدين
  bool _isLoading = true; // حالة التحميل
  bool _isDeleting = false; // حالة الحذف لتجنب النقرات المتعددة

  @override
  void initState() {
    super.initState();
    _fetchGuides(); // استدعاء الدالة لجلب بيانات المرشدين عند تحميل الصفحة
  }

  Future<void> _fetchGuides() async {
    setState(() {
      _isLoading =
          true; // تعيين حالة التحميل إلى true عند البدء في تحميل البيانات
    });

    var response =
        await getRequest(guideView); // تأكد من أن لديك عنوان URL الصحيح

    if (response != null && response['status'] == 'success') {
      setState(() {
        _guides = response['data'] ?? []; // تخزين بيانات المرشدين
        _isLoading = false; // إنهاء حالة التحميل
      });
    } else {
      setState(() {
        _isLoading = false; // إنهاء حالة التحميل
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to load guides.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editGuide(String guideId) {
    // إضافة كود للتعديل على معلومات المرشد
    Navigator.pushNamed(context, 'editguide', arguments: guideId);
  }

  void _deleteGuide(String guideName) async {
    // إضافة كود لحذف المرشد
    if (_isDeleting) return; // منع النقرات المتعددة أثناء الحذف
    setState(() {
      _isDeleting = true; // تعيين حالة الحذف إلى true
    });

    var response = await postRequest(guideDelete, {'guideName': guideName});

    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Guide deleted successfully!'),
        backgroundColor: Colors.green,
      ));
      // إعادة تحميل قائمة المرشدين بعد الحذف
      await _fetchGuides(); // تأكد من إعادة تحميل البيانات
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to delete guide.'),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      _isDeleting = false; // إعادة تعيين حالة الحذف إلى false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guides List'),
        backgroundColor: Color(0xFF33579B), // لون شريط العنوان
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // دائرة تحميل
          : _guides.isEmpty
              ? Center(
                  child:
                      Text('No guides found.')) // رسالة في حال عدم وجود مرشدين
              : Padding(
                  padding: const EdgeInsets.all(8.0), // تقليل الهوامش الخارجية
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // عدد الأعمدة في الشبكة
                      crossAxisSpacing: 8.0, // تقليل المسافة الأفقية
                      mainAxisSpacing: 2.0, // تقليل المسافة العمودية
                    ),
                    itemCount: _guides.length,
                    itemBuilder: (context, index) {
                      var guide = _guides[index]; // المرشد الحالي
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
                                '${guide['fName']} ${guide['lName']}',
                                style: TextStyle(
                                  fontSize: 25, // حجم الخط للنص
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Guide Name: ${guide['guideName']}',
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 2), // تقليل المسافة
                              Text(
                                'Mobile Number: ${guide['mobile']}',
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 1), // تقليل المسافة
                              Text(
                                'Description: ${guide['description'] ?? ''}',
                                style:
                                    TextStyle(fontSize: 20), // تعديل حجم الخط
                              ),
                              SizedBox(height: 4), // تقليل المسافة
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _editGuide(
                                        guide['guide_id'].toString()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xFF33579B), // لون الزر
                                      foregroundColor:
                                          Colors.white, // لون النص أبيض
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              20), // زيادة المسافة الداخلية
                                    ), // إرسال معرف المرشد
                                    child: Text(
                                      'Edit',
                                      style:
                                          TextStyle(fontSize: 20), // حجم النص
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteGuide(
                                        guide['guideName'].toString()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // لون الزر
                                      foregroundColor:
                                          Colors.white, // لون النص أبيض
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical:
                                              20), // زيادة المسافة الداخلية
                                    ), // إرسال mobile
                                    child: Text(
                                      'Delete',
                                      style:
                                          TextStyle(fontSize: 20), // حجم النص
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
