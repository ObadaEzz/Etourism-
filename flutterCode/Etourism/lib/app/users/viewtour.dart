import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_tourism/constant/linksapi.dart';

class ViewTourPage extends StatefulWidget {
  final int tourId;

  const ViewTourPage({required this.tourId});

  @override
  _ViewTourPageState createState() => _ViewTourPageState();
}

class _ViewTourPageState extends State<ViewTourPage> {
  Map<String, dynamic>? tourDetails;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTourDetails();
  }

  Future<void> fetchTourDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('$viewtour?tour_id=${widget.tourId}'),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          setState(() {
            tourDetails = responseBody['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed to fetch tour details");
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

  @override
  void dispose() {
    super.dispose();
  }

  // نافذة منبثقة لحجز الجولة
  Future<void> _showBookingDialog() async {
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
                      name, email, phone, tourDetails!['tour_name']);

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
    try {
      var response = await http.post(
        Uri.parse(book), // أدخل الرابط الخاص بك هنا
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'tour_name': tourName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tourDetails?['tour_name'] ?? "Tour Details"),
        backgroundColor: Color(0xFF33579B),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text("Failed to load tour details."))
              : tourDetails != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                tourDetails!['image_url'].isNotEmpty
                                    ? linkimagetour + tourDetails!['image_url']
                                    : linkimagetour + 'default.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey,
                                    child: Center(
                                      child: Icon(Icons.broken_image,
                                          size: 50, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              tourDetails!['tour_name'],
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF33579B),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start Date: ${tourDetails!['start_date'] ?? "N/A"}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'End Date: ${tourDetails!['end_date'] ?? "N/A"}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Price: \$${tourDetails!['price']}',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              tourDetails!['description'] ??
                                  "No description available.",
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.grey),
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                onPressed: _showBookingDialog,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  backgroundColor: Color(0xFF33579B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(child: Text("No tour details available.")),
    );
  }
}
