// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:e_tourism/constant/linksapi.dart'; // تأكد من وجود رابط الـ API هنا
import 'package:e_tourism/components/curd.dart'; // ملف يحتوي على دالة `postRequest`
import 'package:lottie/lottie.dart'; // مكتبة لوتي للعروض المتحركة

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // تأكد من أن المفتاح فريد
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // دالة إرسال طلب استعادة كلمة المرور
  sendResetLink() async {
    if (_formKey2.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // إرسال البريد الإلكتروني إلى الخادم
      var response = await postRequest(linkForgotPassword, {
        "email": emailController.text,
      });

      setState(() => isLoading = false);

      // التعامل مع الاستجابة
      if (response != null) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(response['message'] ?? 'Reset link sent successfully!'),
            backgroundColor: Colors.green,
          ));

          // الانتقال إلى صفحة تسجيل الدخول بعد فترة قصيرة
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, "login");
          });
        } else {
          // حالة عندما لا يتم العثور على المستخدم
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message'] ?? 'Failed to send reset link!'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // التعامل مع الخطأ في الاتصال بالخادم
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to connect to the server!'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // الألوان المستخدمة في التطبيق
    Color primaryColor = const Color(0xFF0066CC); // لون أزرق
    Color secondaryColor = const Color(0xFFFF5A5F); // لون أحمر
    Color backgroundColor = const Color(0xFFF5F5F5); // خلفية فاتحة
    Color buttonTextColor = Colors.white; // لون النص في الأزرار

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: primaryColor, // لون العنوان في التطبيق
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json', // تأكد من وجود ملف لوتي للتحميل
                width: 200,
                height: 200,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/forget.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Send Reset Link to Email!',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black87, // لون النص الرئيسي
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: primaryColor), // لون النصوص في الحقول
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // زر إرسال رابط إعادة تعيين كلمة المرور مع أيقونة
                    ElevatedButton(
                      onPressed: sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // لون الزر
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.white, // لون أيقونة الإرسال
                          ),
                          const SizedBox(width: 8), // مسافة بين الأيقونة والنص
                          Text(
                            'Send Reset Link',
                            style: TextStyle(
                              fontSize: 14,
                              color: buttonTextColor, // لون النص في زر الإرسال
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // زر العودة مع أيقونة
                    ElevatedButton(
                      onPressed: () {
                        print('Return Home button pressed'); // تتبع الزر
                        Navigator.pushNamed(
                            context, "login"); // التنقل إلى صفحة تسجيل الدخول
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor, // لون زر العودة
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back, // أيقونة العودة
                            color: Colors.white, // لون أيقونة العودة
                          ),
                          const SizedBox(width: 8), // مسافة بين الأيقونة والنص
                          Text(
                            'Return Home',
                            style: TextStyle(
                              fontSize: 14,
                              color: buttonTextColor, // لون النص في زر العودة
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      backgroundColor: backgroundColor, // لون الخلفية العامة
    );
  }
}
