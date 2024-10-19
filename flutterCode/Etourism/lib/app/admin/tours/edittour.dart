// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateTourPage extends StatefulWidget {
  @override
  _UpdateTourPageState createState() => _UpdateTourPageState();
}

class _UpdateTourPageState extends State<UpdateTourPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool isLoading = false;
  String? _imagePath; // To hold the selected image path

  Future<void> _updateTour() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var request = http.MultipartRequest('POST', Uri.parse(tourUpdate));

      // Add image to the request if selected
      if (_imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _imagePath!));
      }

      // Prepare data for updating the tour
      request.fields['name'] = _nameController.text.trim();
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['start_date'] = _startDateController.text.trim();
      request.fields['end_date'] = _endDateController.text.trim();
      request.fields['price'] = _priceController.text.trim();

      try {
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        final responseJson = json.decode(respStr);

        if (responseJson['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Tour updated successfully!'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update tour: ${responseJson['message']}'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Error sending request: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to send request to server.'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Tour'),
        backgroundColor: Color(0xFF33579B),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Tour Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter tour name'
                    : null,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
              ),
              const SizedBox(height: 10),
              _buildDateField(_startDateController, 'Start Date'),
              const SizedBox(height: 10),
              _buildDateField(_endDateController, 'End Date'),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _priceController,
                labelText: 'Price',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number for the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33579B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: const Text('Select Image'),
              ),
              if (_imagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Selected Image: ${_imagePath!.split('/').last}'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _updateTour,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33579B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Tour'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  Widget _buildDateField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          controller.text = '${pickedDate.toLocal()}'.split(' ')[0];
        }
      },
    );
  }
}
