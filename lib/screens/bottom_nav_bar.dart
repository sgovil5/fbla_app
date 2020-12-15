import 'package:flutter/material.dart';

import '../screens/chat/chat_overview.dart';
import '../screens/friends_overview.dart';
import '../screens/other/other_overview_screen.dart';
import '../screens/profile_overview.dart';
import '../screens/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _pages = [
    ProfileOverview(),
    FriendsOverview(),
    ChatOverview(),
    SearchScreen(),
    OtherOverViewScreen(),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedPageIndex,
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
            icon: Icon(Icons.list),
            title: Text('Other'),
          ),
        ],
      ),
    );
  }
}
