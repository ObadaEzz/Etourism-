// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/app/users/searchProgramme.dart';
import 'package:e_tourism/app/users/programmeview.dart';
import 'package:e_tourism/app/users/searchtourpage.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // لإضافة التقييم العشوائي

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<dynamic> programs = [];
  bool isLoading = true;
  bool hasError = false;
  int _selectedIndex = 0; // مؤشر التنقل السفلي

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
      var response = await http.get(Uri.parse(getdata));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['status'] == 'success') {
          setState(() {
            programs = responseBody['data'];
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchTourPage(), // الانتقال إلى صفحة عرض البرامج
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AvailableProgramPage(), // الانتقال إلى صفحة عرض البرامج
        ),
      );
    }
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Coming Soon"),
          content: Text("This feature is coming soon!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? _buildErrorWidget()
              : _buildContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'E-Tourism',
        style: TextStyle(color: Colors.white), // لون النص أبيض
      ),
      backgroundColor: const Color(0xFF33579B), // لون الشريط العلوي أزرق
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white), // لون الأيقونة أبيض
          onPressed:
              fetchPrograms, // لإعادة تحميل البرامج عند الضغط على التحديث
        ),
        IconButton(
          icon: Icon(Icons.logout,
              color: Colors.white), // أيقونة تسجيل الخروج باللون الأبيض
          onPressed: _showLogoutDialog, // دالة تأكيد تسجيل الخروج
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
            ),
          ],
        );
      },
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Icons Row (Flights, Hotels, etc.)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                    Icons.flight, 'Flights', _showComingSoonDialog),
                _buildIconButton(
                    Icons.directions_car, 'Cars', _showComingSoonDialog),
                _buildIconButton(Icons.hotel, 'Hotels', _showComingSoonDialog),
                _buildIconButton(
                    Icons.local_activity, 'Activities', _showComingSoonDialog),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Slider Section
          _buildSlider(),

          // Program List Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Programs",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AvailableProgramPage(), // الانتقال إلى صفحة عرض البرامج
                      ),
                    );
                  },
                  child: Text("View All"),
                ),
              ],
            ),
          ),
          _buildProgramList(),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CarouselSlider(
        options: CarouselOptions(height: 200.0, autoPlay: true),
        items: [
          'assets/images/road1.jpg',
          'assets/images/road2.jpg',
          'assets/images/road3.jpg'
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(i),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgramList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return _buildProgramCard(program);
      },
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
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            child: Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 50),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingStars() {
    int rating = Random().nextInt(5) + 1; // إنشاء تقييم عشوائي بين 1 و 5
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: const Color(0xFF33579B), // لون الشريط السفلي أزرق
      selectedItemColor: Color(0xFF33579B), // الأيقونات المختارة باللون الأبيض
      unselectedItemColor: Color(0xFF33579B),
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
