import 'package:fbla_app/assets/fonts/my_flutter_app_icons.dart';
import 'package:fbla_app/screens/community/community_detail.dart';
import 'package:fbla_app/screens/profile/user_overview_screen.dart';
import 'package:flutter/material.dart';

class CommunityOverview extends StatelessWidget {
  void selectUserOverview(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      UserOverview.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  void selectCommunityDetail(BuildContext context) {
    Navigator.of(context).pushNamed(CommunityDetail.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Communities"),
        actions: [
          // Creates an icon button in the app bar to navigate to the user's profile
          IconButton(
            icon: Image.asset('lib/assets/icons/Logo_Circular.png'),
            onPressed: () {
              selectUserOverview(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                selectCommunityDetail(context);
              },
              child: Card(
                elevation: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Displays the profile picture of the user
                        Container(
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                                "lib/assets/icons/Logo_Circular.jpg"),
                          ),
                        ),
                        // Displays the username of the recieving user with specific alignments and a fontsize of 30
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Resudent Club",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
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
                    // Creates an empty box
                    SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
                    // Creates a divider between the current user being displayed and the next user
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
