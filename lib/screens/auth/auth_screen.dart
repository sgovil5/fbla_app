import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  List<String> setSearchParam(String inputTitle) {
    List<String> searchList = List();
    String temp = "";
    for (int i = 0; i < inputTitle.length; i++) {
      temp = temp + inputTitle[i];
      searchList.add(temp);
    }
    return searchList;
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    String school,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Send image
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + 'jpg');

        await ref.putFile(image).onComplete;
        //URL!!!!!!!!!!!!!
        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
          'password': password,
          'school': school,
          'description': "",
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
