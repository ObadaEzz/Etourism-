// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:e_tourism/components/curd.dart';

class DriverListPage extends StatefulWidget {
  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  List<dynamic> _drivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    var response = await getRequest(driverView);

    if (response != null && response['status'] == 'success') {
      setState(() {
        _drivers = response['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to load drivers.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _editDriver(String driverId) {
    Navigator.pushNamed(context, 'editdriver', arguments: driverId);
  }

  void _deleteDriver(String driverName) async {
    var response = await postRequest(driverDelete, {'driverName': driverName});
    if (response != null && response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Driver deleted successfully!'),
        backgroundColor: Colors.green,
      ));
      setState(() {
        _drivers.removeWhere((driver) =>
            driver['driverName'] == driverName); // حذف السائق من القائمة
      });

      if (_drivers.isEmpty) {
        _fetchDrivers(); // إعادة تحميل القائمة إذا كانت فارغة
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response?['message'] ?? 'Failed to delete driver.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers List'),
        backgroundColor: Color(0xFF33579B),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _drivers.isEmpty
              ? Center(child: Text('No drivers found.'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 2.0,
                    ),
                    itemCount: _drivers.length,
                    itemBuilder: (context, index) {
                      var driver = _drivers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${driver['fName']} ${driver['lName']}',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Driver Name: ${driver['driverName']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Plate Number: ${driver['plateNumber']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Description: ${driver['description'] ?? ''}',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _editDriver(
                                        driver['Idriver_id'].toString()),
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF33579B),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteDriver(
                                        driver['driverName'].toString()),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
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
