// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToursByDriverPage extends StatefulWidget {
  @override
  _ToursByDriverPageState createState() => _ToursByDriverPageState();
}

class _ToursByDriverPageState extends State<ToursByDriverPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  List<dynamic> _reports = [];
  bool _isLoading = false;

  Future<void> _fetchToursByDriver() async {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select both start and end dates.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse(report));
    request.fields['start_date'] = _startDateController.text;
    request.fields['end_date'] = _endDateController.text;

    try {
      var response = await request.send();
      print('Response status: ${response.statusCode}');
      final respStr = await response.stream.bytesToString();
      print('Response body: $respStr');
      final responseJson = json.decode(respStr);
      if (responseJson['status'] == 'success') {
        setState(() {
          _reports = responseJson['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseJson['message'] ?? 'Failed to load reports.'),
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
        _isLoading = false;
      });
    }
  }

  Widget _buildDateField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      readOnly: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tours by Driver'),
        backgroundColor: Color(0xFF33579B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDateField(_startDateController, 'Start Date'),
            SizedBox(height: 10),
            _buildDateField(_endDateController, 'End Date'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchToursByDriver,
              child: Text('Get Tours'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF33579B),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _reports.isEmpty
                    ? Center(child: Text('No tours found.'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            var report = _reports[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Driver: ${report['driverName']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Plate Number: ${report['plateNumber']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Total Tours: ${report['total_tours']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
