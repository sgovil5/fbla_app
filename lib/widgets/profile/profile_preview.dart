import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbla_app/screens/profile/profile_detail_screen.dart';
import 'package:flutter/material.dart';

class ProfilePreview extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String school;
  final DocumentSnapshot user;

  ProfilePreview(this.name, this.imageUrl, this.school, this.user);

  void selectProfile(BuildContext context, DocumentSnapshot userDocument) {
    Navigator.of(context)
        .pushNamed(
      ProfileDetail.routeName,
      arguments: userDocument,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectProfile(context, user);
      },
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            school,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
