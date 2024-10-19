import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:e_tourism/constant/colorconfig.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 150,
            child: Lottie.asset(
              'assets/lottie/a.json',
              width: 100,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Center(
            child: Text(
              "account created,please login",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          MaterialButton(
              textColor: Colors.white,
              color: buttonColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              child: const Text("Login"))
        ],
      ),
    );
  }
}
