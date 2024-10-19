// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/components/valid.dart';
import 'package:e_tourism/constant/colorconfig.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // استخدام مفتاح محلي بدلاً من المفتاح العالمي
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool pinWasObscured = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // تسجيل الدخول
  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      print("isloading $isLoading");

      // إرسال الطلب إلى الخادم باستخدام البريد الإلكتروني وكلمة المرور
      var response = await postRequest(linkLogin, {
        "username": usernameController.text,
        "password": passwordController.text,
      });

      // طباعة الاستجابة لمساعدتك على فهم المشكلة
      print('Response from login: $response');

      setState(() {
        isLoading = false;
      });

      // التحقق من صحة الاستجابة
      if (response != null && response['status'] == "success") {
        String userId = response['data']['Id'].toString();
        String role = response['data']['role']
            .toString(); // Assuming role is provided in response
        print('User ID: $userId');
        print('User Role: $role');

        // الانتقال إلى الشاشة الرئيسية بناءً على الدور
        if (role.toLowerCase() == "admin") {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homeadmin", (route) => false);
        } else if (role.toLowerCase() == "tourist") {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homepage", (route) => false);
        } else {
          // Handle any other roles if necessary
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Unknown role, please contact support!'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // عرض رسالة تنبيه في حالة فشل تسجيل الدخول
        String message =
            response['message'] ?? 'Failed to login, Please try again!';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: isLoading
            ? Center(
                // عرض شاشة تحميل أثناء إرسال الطلب
                child: Lottie.asset(
                  'assets/lottie/loading.json', // تأكد من وجود هذا الملف
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              )
            : Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Image.asset(
                            'assets/images/login.png', // تأكد من وجود هذا الملف
                            width: 400,
                            height: 200,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            validator: (val) {
                              return validInput(val!, 1, 250, 'username');
                            },
                            controller: usernameController,
                            decoration: const InputDecoration(
                                label: Text("username"),
                                prefixIcon: Icon(LineAwesomeIcons.envelope)),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (val) {
                              return validInput(val!, 1, 250, 'password');
                            },
                            controller: passwordController,
                            obscureText: pinWasObscured,
                            decoration: InputDecoration(
                              label: const Text("Password"),
                              prefixIcon: const Icon(Icons.fingerprint),
                              suffixIcon: IconButton(
                                icon: pinWasObscured
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() {
                                    pinWasObscured = !pinWasObscured;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                              height: 10), // مسافة بين حقل كلمة المرور والزر
                          // زر "نسيان كلمة المرور"
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                // الانتقال إلى صفحة "نسيت كلمة المرور"
                                Navigator.pushNamed(context, 'forgot_password');
                              },
                              child: const Text(
                                "   Forgot Password?",
                                style: TextStyle(
                                  color: Colors.red, // لون النص
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            color: buttonColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            onPressed: () async {
                              await login();
                              print("finished login");
                            },
                            child: const Text("Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            child: const Text("Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  decoration: TextDecoration
                                      .underline, // إضافة خط تحت النص
                                )),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("signup");
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
