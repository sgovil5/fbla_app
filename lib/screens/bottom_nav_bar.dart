import 'package:fbla_app/screens/community/community_overview.dart';
import 'package:flutter/material.dart';

import 'chat/chat_overview_screen.dart';
import 'profile/friends_overview_screen.dart';
import '../screens/other/other_overview_screen.dart';
import 'profile/user_overview_screen.dart';
import '../screens/search_screen.dart';
// Imports of screens that map to buttons on navigation bar.

class BottomNavBar extends StatefulWidget {
  // Navigation bar that remains at the bottom of the app page, excluding authorization.
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _pages = [
    UserOverview(),
    FriendsOverview(),
    ChatOverview(),
    SearchScreen(),
    CommunityOverview(),
    OtherOverViewScreen(),
  ]; // List of pages for buttons to correspond to.

  int _selectedPageIndex = 0; // Starts at My Profile page.

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  } // Changes state of app to selected screen.

  @override
  Widget build(BuildContext context) {
    // Builds navigation bar.
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        backgroundColor: Colors.lightBlueAccent, // Chooses color theme.
        currentIndex:
            _selectedPageIndex, // Sets public variable to selected index.
        selectedFontSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Your Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Community"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Other'),
          ),
        ],
      ),
    );
  }
}
