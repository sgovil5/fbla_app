import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/profile/profile_preview.dart';
import './profile/profile_detail_screen.dart';
import './profile/user_overview_screen.dart';
import './../assets/fonts/my_flutter_app_icons.dart';

class SearchScreen extends StatelessWidget {
  // Function to navigate to the profile page of the current user
  void selectUserOverview(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      UserOverview.routeName,
    )
        .then((result) {
      if (result != null) {}
    });
  }

  // A function to create the UI of a category to search for
  Widget buildCategory(BuildContext context, String category,
      SearchDelegate<String> searchType) {
    // Creates a clickable button that searches by the chosen category
    return InkWell(
      onTap: () {
        showSearch(
            context: context,
            delegate:
                searchType); // Setup to search by Name, Interest, or School.
      },
      // Creates a card that displays the text of the type of search
      child: Container(
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Card(
          elevation: 2,
          color: Colors.blueAccent,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: Alignment.center,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Assigns title to search bar
        title: Text('Search for People'),
        actions: [
          // Creates a default way to search with an icon on the app bar which searches by name
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NameSearch(),
              );
            },
          ),
          // Creates an icon to navigate to the current user's profile page
          IconButton(
            icon: Icon(MyFlutterApp.graduation_cap), // Logo Integration.
            onPressed: () {
              selectUserOverview(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // Builds the UI to search by the different categories
          children: [
            buildCategory(context, 'Search by Name', NameSearch()),
            buildCategory(context, 'Search by Interest', InterestSearch()),
            buildCategory(context, 'Search by School', SchoolSearch()),
          ],
        ),
      ),
    );
  }
}

class NameSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // Creates and Icon to clear the search once it is being typed
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Creates and icon to close the current search and return to the previous page
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Function to show the preview of a user searching a name
  @override
  Widget buildResults(BuildContext context) {
    // Creates a stream to gather data about the current users being searched from Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        return Column(
          children: [
            // Creates a title to show the user's results for their query
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people matching the search "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Displays all the users being searched
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                // Returns a preview of each shown user's profile
                return ProfilePreview(
                  userData[index].documentID,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // When a user is clicked on, it navigates to their profile page.
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

  // Function to display suggestions for the search that a user performs
  @override
  Widget buildSuggestions(BuildContext context) {
    // Creates a stream to gather data about the current users being searched from Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        // Displays all the users being searched
        return ListView.builder(
          shrinkWrap: true,
          itemCount: userData.length,
          itemBuilder: (ctx, index) {
            // Returns a preview of the users being searched based on their username
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(userData[index]['username']),
              onTap: () {
                // When the preview is clicked, the app navigates to the selected user's profile page
                selectProfile(context, userData[index]);
              },
            );
          },
        );
      },
    );
  }
}

class InterestSearch extends SearchDelegate<String> {
  @override
  // Creates and Icon to clear the search once it is being typed
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  // Creates and icon to close the current search and return to the previous page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Function to show the preview of a user searching for an interest
  @override
  Widget buildResults(BuildContext context) {
    // Creates a stream to gather data about the current users with the interest being searched form Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('interests', arrayContains: query)
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        return Column(
          children: [
            // Creates a title to show the user's results for their query
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people with the interest of "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Displays all the users being searched
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                // Returns a preview of each shown user's profile
                return ProfilePreview(
                  userData[index].documentID,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // When a user is clicked on, it navigates to their profile page.
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

  // Function to display suggestions for the search that a user performs
  @override
  Widget buildSuggestions(BuildContext context) {
    // Creates a stream to gather data about the current users with interest being searched from Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('interests', arrayContains: query)
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        return Column(
          children: [
            if (query.isNotEmpty)
              // Displays all the users being searched
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 40,
                child: Text(
                  'People with interest "$query"',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                // Returns a preview of the users being searched containing their username
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userData[index]['username']),
                  onTap: () {
                    // When the preview is clicked, the app navigates to the selected user's profile page
                    selectProfile(context, userData[index]);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SchoolSearch extends SearchDelegate<String> {
  @override
  // Creates and Icon to clear the search once it is being typed
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  // Creates and icon to close the current search and return to the previous page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Function to show the preview of a user searching by a school
  @override
  Widget buildResults(BuildContext context) {
    // Creates a stream to gather data about the current users with the school being searched from Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('school', isEqualTo: query)
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        return Column(
          children: [
            // Creates a title to show the user's results for their query
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people who go to the school "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Displays all the users being searched
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                // Returns a preview of each shown user's profile
                return ProfilePreview(
                  userData[index].documentID,
                );
              },
            ),
          ],
        );
      },
    );
  }

  // When a user is clicked on, it navigates to their profile page.
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

  // Function to display suggestions for the search that a user performs
  @override
  Widget buildSuggestions(BuildContext context) {
    // Creates a stream to gather data about the current users being searched from Firebase
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .where('school', isEqualTo: query)
          .snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = userSnapshot.data.documents;
        return Column(
          children: [
            if (query.isNotEmpty)
              // Creates a title to show the results of a user's query
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 40,
                child: Text(
                  'People who go to the school "$query"', // Displays results.
                  style: TextStyle(fontSize: 15),
                ),
              ),
            // Displays all the users being searched
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                // Returns a preview of the users being searched based on their username
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userData[index]['username']),
                  onTap: () {
                    // When the preview is clicked, the app navigates to the selected user's profile page
                    selectProfile(context, userData[index]);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
