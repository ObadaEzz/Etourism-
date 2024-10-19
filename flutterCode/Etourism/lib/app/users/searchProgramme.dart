// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/app/users/homepage.dart';
import 'package:e_tourism/app/users/programmeview.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart'; // لإضافة التقييم العشوائي

class AvailableProgramPage extends StatefulWidget {
  @override
  _AvailableProgramPageState createState() => _AvailableProgramPageState();
}

class _AvailableProgramPageState extends State<AvailableProgramPage> {
  List<dynamic> programs = [];
  List<dynamic> filteredPrograms = [];
  bool isLoading = true;
  bool hasError = false;

  DateTime? _startDate;
  DateTime? _endDate;

  int _selectedIndex = 2; // مؤشر التنقل السفلي إلى البرامج

  @override
  void initState() {
    super.initState();
    fetchPrograms();
  }

  Future<void> fetchPrograms() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      var response =
          await http.get(Uri.parse(getdataspecific)); // تعديل الرابط هنا
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          setState(() {
            programs = responseBody['data'];
            filteredPrograms = programs; // التصفية الافتراضية لكل البرامج
            isLoading = false;
          });
        } else {
          throw Exception("Failed to fetch programs");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = DateTime(picked.year, picked.month, picked.day);
        _filterPrograms();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = DateTime(picked.year, picked.month, picked.day);
        _filterPrograms();
      });
    }
  }

  void _filterPrograms() {
    if (_startDate == null || _endDate == null) {
      filteredPrograms = programs; // إذا لم يتم اختيار تواريخ، إرجاع كل البرامج
    } else {
      filteredPrograms = programs.where((program) {
        DateTime programStartDate =
            DateTime.parse(program['start_date'].split(' ')[0]);
        DateTime programEndDate =
            DateTime.parse(program['end_date'].split(' ')[0]);
        return (programStartDate
                    .isAfter(_startDate!.subtract(Duration(days: 1))) ||
                programStartDate.isAtSameMomentAs(_startDate!)) &&
            (programEndDate.isBefore(_endDate!.add(Duration(days: 1))) ||
                programEndDate.isAtSameMomentAs(_endDate!));
      }).toList();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // توجيه المستخدم إلى الصفحات المناسبة
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserHomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserHomePage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Programs'),
        backgroundColor: const Color(0xFF33579B),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? _buildErrorWidget()
              : _buildContent(),
      bottomNavigationBar:
          _buildBottomNavigationBar(), // إضافة شريط التنقل السفلي
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            "Failed to load data. Please try again.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchPrograms,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateSelection(
                label: 'Start Date:',
                date: _startDate,
                onPressed: () => _selectStartDate(context),
              ),
              _buildDateSelection(
                label: 'End Date:',
                date: _endDate,
                onPressed: () => _selectEndDate(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredPrograms.isEmpty
              ? Center(
                  child: Text('No programs available for the selected dates'))
              : ListView.builder(
                  itemCount: filteredPrograms.length,
                  itemBuilder: (context, index) {
                    final program = filteredPrograms[index];
                    return _buildProgramCard(program);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDateSelection(
      {required String label,
      DateTime? date,
      required VoidCallback onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFE3F2FD), // لون خلفية زر التاريخ
              borderRadius: BorderRadius.circular(12), // زوايا دائرية
              border: Border.all(color: Color(0xFF33579B)), // لون الحدود
            ),
            child: Text(
              date == null
                  ? 'Select Date'
                  : DateFormat('yyyy-MM-dd').format(date),
              style:
                  TextStyle(fontSize: 16, color: Color(0xFF33579B)), // لون النص
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgramImage(program['image_path']),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${program['price']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildRatingStars(), // عرض التقييم بالنجوم
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // الانتقال إلى صفحة تفاصيل البرنامج
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramDetailsPage(
                      program: program), // تعديل وفقًا لاسم صفحة التفاصيل
                ),
              );
            },
          ), // أيقونة الانتقال إلى تفاصيل البرنامج
        ],
      ),
    );
  }

  Widget _buildProgramImage(String imagePath) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: Image.network(
        linkimage + imagePath,
        width: 100, // عرض الصورة
        height: 100, // ارتفاع الصورة
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRatingStars() {
    final random = Random();
    int rating = random.nextInt(5) + 1; // تقييم عشوائي بين 1 و 5
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      iconSize: 26.0,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: const Color(0xFF33579B), // لون الشريط السفلي
      selectedItemColor: Color(0xFF33579B), // الأيقونات المختارة باللون الأبيض
      unselectedItemColor:
          Color(0xFF33579B), // الأيقونات غير المختارة باللون الرمادي
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Program',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
