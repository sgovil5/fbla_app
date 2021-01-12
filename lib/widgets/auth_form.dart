import './pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  // Creates a template for a function that takes in data about the user as parameters
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    String userSchool,
    String userDescription,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Initializes form key and data about a user
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userSchool = '';
  var _userDescription = '';
  var _userImageFile;

  // Function to assign the user's chosen image to the _userImageFile
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  // Function to validate that the values the user entered are legitimate
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //Remove keyboard after submit

    // If the user hasn't chosen an image a snackbar is shown prompting the user to choose an image
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Choose an image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    // If the form is valid, the values of the form are sent to the Auth Screen widget
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userSchool.trim(),
        _userDescription.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Creates a scrollview with a card to contain a form
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              // assigns the form key
              key: _formKey,
              // Creates a column to display multiple widgets
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // If the user is not in login mode, they have to choose an image
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  // A Text Field prompts the user for their email
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      // validator to make sure the email is valid
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    // If the user is not in login mode, they are prompted for a username
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        // validator to make sure username is valid
                        if (value.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  if (!_isLogin)
                    // If the user is not in login mode, they are prompted for a school
                    TextFormField(
                      key: ValueKey('school'),
                      validator: (value) {
                        // validator to make sure school is valid
                        if (value.isEmpty || value.length < 3) {
                          return 'School name must be at least 3 character long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'School',
                      ),
                      onSaved: (value) {
                        _userSchool = value;
                      },
                    ),
                  if (!_isLogin)
                    // If the user is not in login mode, they are prompted for a description
                    TextFormField(
                      key: ValueKey('description'),
                      validator: (value) {
                        // validator to make sure description is valid
                        if (value.isEmpty || value.length > 150) {
                          return 'Description must be between 1 and 150 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description About Yourself',
                      ),
                      onSaved: (value) {
                        _userDescription = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 character long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    // A button to show the mode of user authentication
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    // A button to switch between creation of account and login to an existing account
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
