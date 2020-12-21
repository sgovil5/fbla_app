import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/profile/profile_preview.dart';
import './profile/profile_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget buildCategory(BuildContext context, String category,
      SearchDelegate<String> searchType) {
    return InkWell(
      onTap: () {
        showSearch(context: context, delegate: searchType);
      },
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for People'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NameSearch(),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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

  @override
  Widget buildResults(BuildContext context) {
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
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people matching the search "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
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
  Widget buildSuggestions(BuildContext context) {
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
        return ListView.builder(
          shrinkWrap: true,
          itemCount: userData.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(userData[index]['username']),
              onTap: () {
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

  @override
  Widget buildResults(BuildContext context) {
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
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people with the interest of "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
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
  Widget buildSuggestions(BuildContext context) {
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
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userData[index]['username']),
                  onTap: () {
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

  @override
  Widget buildResults(BuildContext context) {
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
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              child: Text(
                'These are a list of people who go to the school "$query"',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
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
  Widget buildSuggestions(BuildContext context) {
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
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 40,
                child: Text(
                  'People who go to the school "$query"',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userData.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userData[index]['username']),
                  onTap: () {
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
