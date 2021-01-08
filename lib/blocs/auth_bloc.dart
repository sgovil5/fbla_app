import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/facebook_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthBloc {
  final authService = FacebookAuthService();
  final fb = FacebookLogin();

  Stream<FirebaseUser> get currentUser => authService.currentUser;

  loginFacebook(BuildContext context) async {
    final res = await fb.logIn(
      //Gives permissions to the app from Facebook
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );

    switch (res.status) {
      //In case of a success logging in with Facebook
      case FacebookLoginStatus.success:
        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;
        //Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: fbToken.token);
        // User Credential to Sign in with Firebase
        final result = await authService.signInWithCredential(credential);
        //Get the current ID of user
        String userId = await currentUser.first.then((value) => value.uid);
        //Get data of the current user
        final snapshot =
            await Firestore.instance.collection('users').document(userId).get();
        if (snapshot == null || !snapshot.exists) {
          //Create a new user if one doesn't exist with empty data
          await Firestore
              .instance //Send data to Firebase in the user's document
              .collection('users')
              .document(userId)
              .setData({
            'username': '',
            'email': '',
            'image_url': null,
            'password': '',
            'school': '',
            'description': '',
            'searchKeywords': [],
            'achievements': [],
            'classes': [],
            'experiences': [],
            'interests': [],
            'test_scores': [],
            'friends': [],
            'pending': [],
          });
        }
        break;
      case FacebookLoginStatus
          .cancel: //In the case that the Facebook Login is cancelled
        showDialog(
          // An alert will be shown that the login was cancelled
          context: context,
          child: AlertDialog(
            title: Text('The Facebook Login was cancelled'),
            actions: [
              FlatButton(
                //User will have the option to close the alert by pressing the "okay" button
                child: Text('Okay'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        break;
      case FacebookLoginStatus
          .error: //In the case that there is an error during facebook login
        showDialog(
          // An alert will be shown that the login had an error
          context: context,
          child: AlertDialog(
            title: Text('There was an error'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                //User will have the option to close the alert by pressing the "okay" button
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        break;
    }
  }
}
