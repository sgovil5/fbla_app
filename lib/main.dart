import 'package:fbla_app/screens/other/terms_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/other/report_bug_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/bottom_nav_bar.dart';
import 'blocs/auth_bloc.dart';
import 'screens/chat/chat_detail_screen.dart';
import 'screens/profile/profile_detail_screen.dart';
import 'screens/profile/profile_edit.dart';
import 'screens/profile/user_overview_screen.dart';

void main() {
  runApp(Resudent()); // runs the Resudent Class to run the entire App
}

class Resudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      // Creates a provider to get information from the AuthBloc widget regarding Facebook Login
      create: (context) => AuthBloc(), // Gets the data from the AuthBloc widget
      child: MaterialApp(
        // Creates a Material App widget which allows for the creation of the app
        debugShowCheckedModeBanner: false,
        title: 'Resudent',
        theme: ThemeData(
          primarySwatch: Colors
              .blue, //Assigns the main colors of the application to be blue
          scaffoldBackgroundColor: Colors
              .white, //Assigns the background color of the app to be white
        ),
        home: StreamBuilder(
          // Creates a stream to check if the status of authentication has been changed
          // Checks if the user is currently logged in or not
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            //If the user is not logged in, the authentication screen is returned
            //If the user is logged in, the main app under the "BottomNavBar" widget name is returned
            if (userSnapshot.hasData) {
              return BottomNavBar();
            }
            return AuthScreen();
          },
        ),
        initialRoute: '/',
        // Creates route tables to allow for navigation between pages
        routes: {
          ProfileEdit.routeName: (ctx) => ProfileEdit(),
          ReportBug.routeName: (ctx) => ReportBug(),
          ProfileDetail.routeName: (ctx) => ProfileDetail(),
          ChatDetail.routeName: (ctx) => ChatDetail(),
          UserOverview.routeName: (ctx) => UserOverview(),
          TermsService.routeName: (ctx) => TermsService(),
        },
      ),
    );
  }
}
