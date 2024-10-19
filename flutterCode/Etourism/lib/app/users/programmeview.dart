// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/app/users/viewtour.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgramDetailsPage extends StatefulWidget {
  final Map<String, dynamic> program;

  const ProgramDetailsPage({Key? key, required this.program}) : super(key: key);

  @override
  _ProgramDetailsPageState createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
  List<dynamic> tours = [];
  bool isLoading = true;
  bool hasError = false;

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
      final response = await http.get(
          Uri.parse('$gettour?program_id=${widget.program['programme_id']}'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          setState(() {
            tours = responseBody['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed to fetch tours");
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program['name']),
        backgroundColor: Color(0xFF33579B),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgramImage(widget.program['image_path'] ?? ''),
            _buildProgramInfoCard(),
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
                        ),
                      )
                    : _buildToursList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Image.network(
        linkimage + imagePath,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
            width: double.infinity,
            height: 250,
            child: Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 50),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramInfoCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.program['description'] ?? '',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price: \$${widget.program['price']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF33579B),
                    ),
                  ),
                  Icon(Icons.monetization_on, color: Color(0xFF33579B)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: ${widget.program['start_date']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.date_range, color: Color(0xFF33579B)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End: ${widget.program['end_date']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.event_available, color: Color(0xFF33579B)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToursList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
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
          _buildTourImage(tour['image_url'] ?? ''),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour['tour_name'] ?? '',
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
                          final tourId = tour['tour_id']?.toString();
                          if (tourId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewTourPage(tourId: tour['tour_id']),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tour ID is not available.'),
                              ),
                            );
                          }
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
                          _showBookingDialog(tour['tour_name']);
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
            : linkimagetour + 'default.jpg',
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

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking for $tourName'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Your Email',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Perform booking logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
