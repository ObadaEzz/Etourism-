// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProgrammePage extends StatefulWidget {
  const AddProgrammePage({super.key});

  @override
  _AddProgrammePageState createState() => _AddProgrammePageState();
}

class _AddProgrammePageState extends State<AddProgrammePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedDriver;
  String? _selectedGuide;
  bool isLoading = false;
  String? _imagePath; // لحفظ مسار الصورة المرفوعة

  List<String> drivers = [];
  List<String> guides = [];

  @override
  void initState() {
    super.initState();
    _loadDriversAndGuides();
  }

  Future<void> _loadDriversAndGuides() async {
    setState(() {
      isLoading = true;
    });

    try {
      var responseDrivers = await getRequest(driversGet);
      var responseGuides = await getRequest(guidesGet);

      if (responseDrivers != null && responseDrivers['status'] == 'success') {
        setState(() {
          drivers = List<String>.from(
              responseDrivers['data'].map((driver) => driver['name']));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to load drivers: ${responseDrivers?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }

      if (responseGuides != null && responseGuides['status'] == 'success') {
        setState(() {
          guides = List<String>.from(
              responseGuides['data'].map((guide) => guide['fullName']));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to load guides: ${responseGuides?['message'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $error'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addProgramme() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var request = http.MultipartRequest('POST', Uri.parse(programmeAdd));

      // إضافة الصورة إلى الطلب
      if (_imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _imagePath!));
      }

      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['start_date'] = _startDateController.text;
      request.fields['end_date'] = _endDateController.text;
      request.fields['price'] = _priceController.text;
      request.fields['driver'] = _selectedDriver ?? '';
      request.fields['guide'] = _selectedGuide ?? '';

      try {
        var response = await request.send();

        // تحقق من الحالة
        print('Response status: ${response.statusCode}');

        // قراءة الاستجابة
        final respStr = await response.stream.bytesToString();

        // طباعة الاستجابة
        print('Response body: $respStr');

        try {
          final responseJson = json.decode(respStr);

          if (responseJson['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Program added successfully!'),
              backgroundColor: Colors.green,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Failed to add program: ${responseJson['message']}'),
              backgroundColor: Colors.red,
            ));
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to decode response from server.'),
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
        _imagePath = pickedFile.path; // حفظ مسار الصورة المرفوعة
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Program'),
        backgroundColor: const Color(0xFF33579B),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Program Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the program name'
                    : null,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
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
              _buildDropdownButtonFormField(
                value: _selectedDriver,
                hint: 'Select Driver',
                items: drivers,
                onChanged: (value) {
                  setState(() {
                    _selectedDriver = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildDropdownButtonFormField(
                value: _selectedGuide,
                hint: 'Select Guide',
                items: guides,
                onChanged: (value) {
                  setState(() {
                    _selectedGuide = value;
                  });
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
                onPressed: isLoading ? null : _addProgramme,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33579B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Program'),
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

  Widget _buildDropdownButtonFormField({
    String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: hint),
      hint: Text(hint),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
