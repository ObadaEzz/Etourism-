// ignore_for_file: prefer_const_constructors

import 'package:e_tourism/app/Auth/forget.dart';
import 'package:e_tourism/app/Auth/SplashScreen.dart';
import 'package:e_tourism/app/Auth/login.dart';
import 'package:e_tourism/app/Auth/signup.dart';
import 'package:e_tourism/app/Auth/success.dart';
import 'package:e_tourism/app/admin/drivers/adddriver.dart';
import 'package:e_tourism/app/admin/drivers/deletedriver.dart';
import 'package:e_tourism/app/admin/drivers/driverpage.dart';
import 'package:e_tourism/app/admin/drivers/editdriver.dart';
import 'package:e_tourism/app/admin/drivers/viewdriver.dart';
import 'package:e_tourism/app/admin/guides/addguide.dart';
import 'package:e_tourism/app/admin/guides/deleteguide.dart';
import 'package:e_tourism/app/admin/guides/editguide.dart';
import 'package:e_tourism/app/admin/guides/guidepage.dart';
import 'package:e_tourism/app/admin/guides/viewguide.dart';
import 'package:e_tourism/app/admin/homeadmin.dart';
import 'package:e_tourism/app/admin/programmes/addprogramme.dart';
import 'package:e_tourism/app/admin/programmes/deleteprogramme.dart';
import 'package:e_tourism/app/admin/programmes/editprogramme.dart';
import 'package:e_tourism/app/admin/programmes/programmepage.dart';
import 'package:e_tourism/app/admin/programmes/viewprogramme.dart';
import 'package:e_tourism/app/admin/report.dart';
import 'package:e_tourism/app/admin/tourists/addtourist.dart';
import 'package:e_tourism/app/admin/tourists/deletetourist.dart';
import 'package:e_tourism/app/admin/tourists/edittourist.dart';
import 'package:e_tourism/app/admin/tourists/touristpage.dart';
import 'package:e_tourism/app/admin/tourists/viewtourist.dart';
import 'package:e_tourism/app/admin/tours/addtour.dart';
import 'package:e_tourism/app/admin/tours/deletetour.dart';
import 'package:e_tourism/app/admin/tours/edittour.dart';
import 'package:e_tourism/app/admin/tours/tourpage.dart';
import 'package:e_tourism/app/admin/tours/viewtour.dart';
import 'package:e_tourism/app/users/homepage.dart';

//import 'package:e_tourism/app/user/screens/home_screen.dart';

//import 'package:e_tourism/constant/linksapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences sharedPref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Application name
      title: 'ETourism',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        // useMaterial3: false,
        primaryColor: Color(0xFF3EBACE),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Color(0xFFD8ECF1)),
      ),
      // A widget which will be started on application startup
      initialRoute: "SplashScreen",
      /*  initialRoute: sharedPref!.getString("id") == null
          ? "SplashScreen"
          : sharedPref!.getString("role") == "admin"
              ? "adminhome"
              : "home", */
      routes: {
        //Auth
        'login': (context) => const Login(),
        'signup': (context) => const SignUp(),
        'forgot_password': (context) => const ForgotPassword(),
        'success': (context) => const Success(),
        'SplashScreen': (context) => const SplashScreen(),
        //admin
        'homeadmin': (context) => const AdminHomePage(),
        //driver
        'driverhome': (context) => const DriverPage(),
        'adddriver': (context) => AddDriverPage(),
        'deletedriver': (context) => DeleteDriverPage(),
        'editdriver': (context) => UpdateDriverPage(),
        'viewdriver': (context) => DriverListPage(),
        //guide
        'guidehome': (context) => const GuidePage(),
        'addguide': (context) => AddGuidePage(),
        'deleteguide': (context) => DeleteGuidePage(),
        'editguide': (context) => UpdateGuidePage(),
        'viewguide': (context) => GuideListPage(),
        //tour
        'tourhome': (context) => const TourPage(),
        'addtour': (context) => AddTourPage(),
        'deletetour': (context) => DeleteTourPage(),
        'edittour': (context) => UpdateTourPage(),
        'viewtour': (context) => TourListPage(),
        //programme
        'programmehome': (context) => const ProgrammePage(),
        'addprogramme': (context) => AddProgrammePage(),
        'deleteprogramme': (context) => DeleteProgrammePage(),
        'editprogramme': (context) => UpdateProgrammePage(),
        'viewprogramme': (context) => ProgrammeListPage(),
        //tourist
        'touristhome': (context) => const TouristPage(),
        'addtourist': (context) => AddTouristPage(),
        'deletetourist': (context) => DeleteTouristPage(),
        'edittourist': (context) => UpdateTouristPage(),
        'viewtourist': (context) => TouristListPage(),
        //home
        //      'home': (context) => HomeScreen(),
        'homepage': (context) => UserHomePage(),
        'report': (context) => ToursByDriverPage(),
        //'userhome': (context) => UserHomePage(),
        //user
      },
    );
  }
}
