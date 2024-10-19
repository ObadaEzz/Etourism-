// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/constant/colorconfig.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Home',
          style: TextStyle(color: Colors.white), // Text color to white
        ),
        backgroundColor: const Color(0xFF33579B), // AppBar background color
      ),
      body: Container(
        color: backgroundColor, // Background color (customizable)
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // Guide Button
            _buildAdminButton(
              context: context,
              title: 'Guide',
              routeName: 'guidehome',
            ),
            // Driver Button
            _buildAdminButton(
              context: context,
              title: 'Driver',
              routeName: 'driverhome',
            ),
            // Programme Button
            _buildAdminButton(
              context: context,
              title: 'Programme',
              routeName: 'programmehome',
            ),
            // Tour Button
            _buildAdminButton(
              context: context,
              title: 'Tour',
              routeName: 'tourhome',
            ),
            // Tourist Button
            _buildAdminButton(
              context: context,
              title: 'Tourist',
              routeName: 'touristhome',
            ),
            // Report Button (Logout style)
            _buildAdminButton(
              context: context,
              title: 'Report',
              routeName: 'report',
              isLogoutButton: false,
            ),
            // Logout Button
            _buildAdminButton(
              context: context,
              title: 'Logout',
              routeName: 'login',
              isLogoutButton: true,
            ),
          ],
        ),
      ),
    );
  }

  // Custom Button Builder
  Widget _buildAdminButton({
    required BuildContext context,
    required String title,
    required String routeName,
    bool isLogoutButton = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isLogoutButton
            ? const Color(0xFFAC3A32) // Red color for logout/report buttons
            : const Color(0xFF33579B), // Default button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, routeName); // Navigate to specific route
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
