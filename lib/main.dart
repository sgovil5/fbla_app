import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/other/report_bug.dart';
import 'screens/auth_screen.dart';
import 'screens/bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FBLA App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return BottomNavBar();
          }
          return AuthScreen();
        },
      ),
      initialRoute: '/',
      routes: {
        ReportBug.routeName: (ctx) => ReportBug(),
      },
    );
  }
}
