import 'package:fbla_app/blocs/auth_bloc.dart';
import 'package:fbla_app/screens/chat/chat_detail_screen.dart';
import 'package:fbla_app/screens/profile/profile_detail_screen.dart';
import 'package:fbla_app/screens/profile/profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/other/report_bug_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/bottom_nav_bar.dart';
// ^^ imports, some from dart, some from flutter, some from firebase...
// All documentation should use this comment. 
// This is the main file, contains running code for the app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      // creates auth 
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FBLA App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        // Basic color theme, should be changed to: 
        // Lavender Web: E5E6FD (lightest, off-white)
        // Light Steel Blue: BCD2EE
        // Dark Cornflower Blue: 334195
        // Thistle: C8B5E1 (medium purple)
        // Amethyst: 895EC2 (dark purple)
        
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return BottomNavBar();
            }
            return AuthScreen();
            // Authorization screen loaded in.
          },
        ),
        initialRoute: '/',
        routes: {
          ProfileEdit.routeName: (ctx) => ProfileEdit(),
          ReportBug.routeName: (ctx) => ReportBug(),
          ProfileDetail.routeName: (ctx) => ProfileDetail(),
          ChatDetail.routeName: (ctx) => ChatDetail(),
        },
      ),
    );
  }
}
