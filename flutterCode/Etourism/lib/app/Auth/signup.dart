// ignore_for_file: unused_import, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'package:e_tourism/components/curd.dart';
import 'package:e_tourism/components/valid.dart';
import 'package:e_tourism/constant/colorConfig.dart';
import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

bool isLoading = false;
GlobalKey<FormState> formstate = GlobalKey();
bool pinWasObscured = true;

TextEditingController username = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController fName = TextEditingController();
TextEditingController lName = TextEditingController();

class _SignUpState extends State<SignUp> {
  // دالة تسجيل المستخدم
  signUp() async {
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // إرسال الطلب مع القيم المدخلة من المستخدم
      var response = await postRequest(linkSignUp, {
        "username": username.text,
        "password": password.text,
        "fName": fName.text,
        "lName": lName.text,
        "email": email.text,
      });

      setState(() {
        isLoading = false;
      });

      // تحقق من صحة الاستجابة
      if (response != null && response['status'] == "success") {
        // إظهار رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration successful! Please log in.'),
          backgroundColor: Colors.green, // لون الرسالة
        ));

        // الانتظار لفترة قصيرة قبل الانتقال إلى صفحة تسجيل الدخول
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pushReplacementNamed("login");
      } else if (response != null && response['status'] == "error") {
        String errorMessage = response['message'];

        // تحقق إذا كان الخطأ يتعلق باسم المستخدم أو البريد الإلكتروني
        if (errorMessage.contains('username')) {
          errorMessage = 'Username is already taken. Please choose another.';
        } else if (errorMessage.contains('email')) {
          errorMessage =
              'Email is already registered. Please use another email.';
        } else {
          errorMessage = 'Failed to signup, Try again later!';
        }

        // إظهار رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ));
      } else {
        // إظهار رسالة خطأ عامة
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to signup, Try again later!'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  String? validateEmail(String? value) {
    // تعبير عادي للتحقق من صحة البريد الإلكتروني
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter your email';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    // تحقق من أن كلمة المرور تحتوي على 8 أحرف على الأقل مع رقم ورمز
    if (value!.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
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
                  'assets/lottie/loading.json',
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
                      key: formstate,
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Image.asset(
                            "assets/images/signup.png",
                            width: 600,
                            height: 200,
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            validator: (val) {
                              return validInput(val!, 1, 10, 'fName');
                            },
                            controller: fName,
                            decoration: const InputDecoration(
                                label: Text('First name'),
                                prefixIcon: Icon(LineAwesomeIcons.user)),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (val) {
                              return validInput(val!, 1, 10, 'lName');
                            },
                            controller: lName,
                            decoration: const InputDecoration(
                                label: Text('Last name'),
                                prefixIcon: Icon(LineAwesomeIcons.user)),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (val) {
                              return validInput(val!, 1, 10, 'username');
                            },
                            controller: username,
                            decoration: const InputDecoration(
                                label: Text('Username'),
                                prefixIcon: Icon(LineAwesomeIcons.user)),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (val) {
                              return validateEmail(val);
                            },
                            controller: email,
                            decoration: const InputDecoration(
                                label: Text("Email"),
                                prefixIcon: Icon(LineAwesomeIcons.envelope)),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (val) {
                              return validatePassword(val);
                            },
                            controller: password,
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
                          const SizedBox(height: 20),
                          MaterialButton(
                            color: buttonColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            onPressed: () async {
                              await signUp();
                              print("finished signup");
                            },
                            child: const Text("Create account",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            child: const Text("Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  decoration: TextDecoration
                                      .underline, // إضافة خط تحت النص
                                )),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("login");
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
