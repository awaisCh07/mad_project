import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:ams_employees/screens/attendance_screen.dart';
import 'package:ams_employees/screens/dashboard_screen.dart';
import 'package:ams_employees/screens/leave_screen.dart';
import 'package:ams_employees/screens/login_screen.dart';
import 'package:ams_employees/screens/signup_screen.dart';

import 'package:ams_employees/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: 'AMS WhiteBox',
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => Signup(),
        '/login': (context) => const Login(),
        '/dashboard': (context) => const Dashboard(),
        '/profile': (context) => const Profile(),
        '/attendance': (context) => const Attendance(),
        '/leave': (context) => const LeaveScreen(),
      },
    );
  }
}
