// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/app/users/viewtour.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_tourism/constant/linksapi.dart'; // تأكد من استيراد الرابط المناسب

class SearchTourPage extends StatefulWidget {
  @override
  _SearchTourPageState createState() => _SearchTourPageState();
}

class _SearchTourPageState extends State<SearchTourPage> {
  List<dynamic> tours = [];
  List<dynamic> filteredTours = [];
  bool isLoading = true;
  bool hasError = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchTours();
  }

  Future<void> fetchTours() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response =
          await http.get(Uri.parse(searchtour)); // تعديل حسب الرابط المطلوب

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          if (responseBody['data'] is List) {
            setState(() {
              tours = responseBody['data'];
              filteredTours = tours;
              isLoading = false;
            });
          } else {
            throw Exception("Unexpected data format: expected List");
          }
        } else {
          throw Exception("Failed to fetch tours: ${responseBody['message']}");
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

  void _filterTours(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredTours = tours.where((tour) {
        final tourName = tour['tour_name'].toString().toLowerCase();
        return tourName.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Tours"),
        backgroundColor: Color(0xFF33579B),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(), // مربع البحث
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Available Tours",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33579B),
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(
                        child: Text(
                        "Failed to load tours. Please try again.",
                        style: TextStyle(color: Colors.red),
                      ))
                    : _buildToursList(), // قائمة الرحلات بناءً على البحث
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          _filterTours(value); // استدعاء فلترة النتائج حسب البحث
        },
        decoration: InputDecoration(
          hintText: "Search tours...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildToursList() {
    return filteredTours.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No tours match your search.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredTours.length,
            itemBuilder: (context, index) {
              final tour = filteredTours[index];
              return _buildTourCard(tour);
            },
          );
  }

  Widget _buildTourCard(Map<String, dynamic> tour) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTourImage(tour['image_url']),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour['tour_name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33579B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${tour['price']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewTourPage(tourId: tour['tour_id']),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF33579B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size(90, 36), // تصغير حجم الزر
                        ),
                        child: Text(
                          'View Tour',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12), // تصغير حجم النص
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showBookingDialog(
                              tour['tour_name']); // تمرير اسم الرحلة هنا
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size(90, 36), // تصغير حجم الزر
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12), // تصغير حجم النص
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: Image.network(
        imageUrl.isNotEmpty
            ? linkimagetour + imageUrl
            : '${linkimagetour}default.jpg',
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
            width: 120,
            height: 120,
            child: Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 50),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showBookingDialog(String tourName) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                String name = nameController.text;
                String email = emailController.text;
                String phone = phoneController.text;

                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
                  await _submitBooking(
                      name, email, phone, tourName); // تمرير اسم الرحلة هنا

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Thank you!"),
                        content: Text(
                            "Thank you for your booking. We will contact you soon to confirm your reservation."),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pop(); // Close booking dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
    });
  }

  Future<void> _submitBooking(
      String name, String email, String phone, String tourName) async {
    // تغيير نوع المعامل tourId إلى tourName
    try {
      var response = await http.post(
        Uri.parse(book), // API endpoint for booking

        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'tour_name': tourName, // استخدام اسم الرحلة هنا
          'registered_date': DateTime.now().toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          print("Booking successful");
        } else {
          print("Failed to book");
        }
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
