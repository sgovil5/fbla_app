import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_form.dart';
import '../../blocs/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  // Function to create an array of search parameters by looking at every substring of a username
  List<String> setSearchParam(String inputTitle) {
    List<String> searchList = List();
    String temp = "";
    for (int i = 0; i < inputTitle.length; i++) {
      temp = temp + inputTitle[i];
      searchList.add(temp);
    }
    return searchList;
  }

  // Function to sumbit data from an authentication form to Firebase and create a user account
  void _submitAuthForm(
    String email,
    String password,
    String username,
    String school,
    String description,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      // Checks if user is logging in or signing up
      if (isLogin) {
        // If the user is logging in, the Firebase API will sign in with email and password
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // If the user is signing up, the Firebase API will create a user with email and password
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Sends the user image to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + 'jpg');

        await ref.putFile(image).onComplete;
        //Gets the link of the image from Firebase Storage
        final url = await ref.getDownloadURL();
        //Creates a user with all the data submitted in the form and the image URL in Firebase
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
          'password': password,
          'school': school,
          'description': description,
          'searchKeywords': setSearchParam(username.trim().toLowerCase()),
          'achievements': [],
          'classes': [],
          'experiences': [],
          'interests': [],
          'test_scores': [],
          'friends': [],
          'pending': [],
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      //If there is an error, a snackbar will be displayed showing the error
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Creates a reference to the AuthBloc class for login through Facebook
    var authBloc = Provider.of<AuthBloc>(context);
    // Returns a screen for the user authentication for both login and signup
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //Creates a column of widgets with center alignment
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Adds an Auth Form to the column of widgets and passes in the submit auth form method and a boolean of "isLoading"
          AuthForm(
            _submitAuthForm,
            _isLoading,
          ),
          //Creates a button for signing in with facebook
          SignInButton(
            Buttons.Facebook,
            onPressed: () {
              //Calls the loginFacebook method from the AuthBloc class to login with Facebook
              authBloc.loginFacebook(context);
            },
          )
        ],
      ),
    );
  }
}
