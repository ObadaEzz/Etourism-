// ignore_for_file: avoid_print, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';

class AddTouristPage extends StatefulWidget {
  @override
  _AddTouristPageState createState() => _AddTouristPageState();
}

class _AddTouristPageState extends State<AddTouristPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _touristNameController = TextEditingController();
  final TextEditingController _touristEmailController = TextEditingController();
  final TextEditingController _touristPhoneController = TextEditingController();
  final TextEditingController _tourNameController = TextEditingController();

  bool isLoading = false;

  // Function to add a tourist
  Future<void> _addTourist() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set loading state
      });

      Map<String, dynamic> data = {
        'name': _touristNameController.text,
        'email': _touristEmailController.text,
        'phone': _touristPhoneController.text,
        'tour_name': _tourNameController.text, // Added tour_name field
        // You may want to handle registered_date on the server side
      };

      var response = await postRequest(
          touristAdd, data); // Make sure to change the link as needed

      setState(() {
        isLoading = false; // End loading state
      });

      if (response != null && response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tourist added successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to add tourist: ${response?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tourist'),
        backgroundColor: Color(0xFF33579B), // AppBar color
      ),
      body: Container(
        color: backgroundColor, // Background color (change as desired)
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _touristNameController,
                decoration: const InputDecoration(labelText: 'Tourist Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tourist name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _touristEmailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _touristPhoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tourNameController,
                decoration: const InputDecoration(
                    labelText: 'Tour Name'), // Added tour name field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tour name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _addTourist,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33579B), // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20), // Padding
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Add Tourist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
