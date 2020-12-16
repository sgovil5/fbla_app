import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
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
                delegate: ArticleSearch(),
              );
            },
          )
        ],
      ),
    );
  }
}

class ArticleSearch extends SearchDelegate<String> {
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
    StreamBuilder(
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
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    StreamBuilder(
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
        ListView.builder(
          itemCount: userData.length,
          itemBuilder: (ctx, index) {
            return ListTile(
                leading: Icon(Icons.person),
                title: Text(userData[index]['name']),
                onTap: () {
                  //select user
                });
          },
        );
      },
    );
  }
}
