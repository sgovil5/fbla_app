import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/services/facebook_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthBloc {
  final authService = FacebookAuthService();
  final fb = FacebookLogin();

  Stream<FirebaseUser> get currentUser => authService.currentUser;

  loginFacebook(BuildContext context) async {
    print('Starting Facebook Login');

    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    // Facebook Login Integration.

    switch (res.status) {
      case FacebookLoginStatus.success:
        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;
        //Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: fbToken.token);
        // User Credential to Sign in with Firebase
        final result = await authService.signInWithCredential(credential);
        String userId = await currentUser.first.then((value) => value.uid);
        final snapshot =
            await Firestore.instance.collection('users').document(userId).get();
        if (snapshot == null || !snapshot.exists) {
          await Firestore.instance
              .collection('users')
              .document(userId)
              .setData({
            'username': '',
            'email': '',
            'image_url': null,
            'password': '',
            'school': '',
            'description': '',
            'searchKeywords':
                [], //setSearchParam(username.trim().toLowerCase()),
            'achievements': [],
            'classes': [],
            'experiences': [],
            'interests': [],
            'test_scores': [],
            'friends': [],
            'pending': [],
          });
        } // Creation of new user.
        print('${result.user.displayName} is logged in');
        break;
      case FacebookLoginStatus.cancel:
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('The Facebook Login was cancelled'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ); // Went to Facebook Login page, and then came back without logging in.
        break;
      case FacebookLoginStatus.error:
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('There was an error'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ); // Mostly for debugging purposes. 
        break;
    }
  }
}
