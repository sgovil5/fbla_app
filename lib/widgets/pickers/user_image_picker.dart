import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  // Creates a function to pick an image
  void _pickImage() async {
    // Calls the image picker widget
    final picker = ImagePicker();
    // the user is prompted to choose an image from their gallery
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );
    // The chosen image is converted to a file and put into the pickedImageFile variable
    final pickedImageFile = File(pickedImage.path);
    // The _pickedImage variable is updated to choose the file
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    // Creates a column to show widgets
    return Column(
      children: [
        // Shows the current image that has been chose
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        // Creates a button to choose a new image
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          // When pressed, the _pickImage function is called
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
