// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for the text fade-in effect
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC1E7FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اسم التطبيق في الأعلى
            Text(
              "E-Tourism",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 15),

            // لوتي في المنتصف
            Lottie.asset('assets/lottie/spreash.json', width: 400, height: 400),

            SizedBox(height: 10),

            // النص الذي يظهر تدريجيًا
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                "Book with us and enjoy the best trips!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold, // لجعل النص عريض
                  fontStyle: FontStyle.italic, // لجعل النص مائل
                  letterSpacing: 1.5, // زيادة التباعد بين الأحرف
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 40),

            // الزرين في الأسفل بجانب بعضهم البعض
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر التسجيل
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("signup");
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    // تغيير لون النص إلى أسود
                  ),
                ),
                SizedBox(width: 20), // فراغ بين الزرين

                // زر تسجيل الدخول
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("login");
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    // تغيير لون النص إلى أسود
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
