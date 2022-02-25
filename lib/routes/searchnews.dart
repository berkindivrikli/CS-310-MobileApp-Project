import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_app/ui/Post.dart';

class NewsSearchPage extends SearchDelegate {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("feednews");

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back));
  }

  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseFirestore.snapshots().asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Fetch data here

          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element["title"]
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(
              child: Text("No search query found"),
            );
          } else {
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element["title"]
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String title = data.get('title');
                final String content = data.get("content");
                final String author = data.get("author");
                final Timestamp date = data.get("date");
                final String pp = data.get("authorPhoto");
                DateTime myDateTime = data['date'].toDate();
                final String contentImg = data.get("contentPhoto");

                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Post(fid: data.id)));
                  },
                  title: Text(title),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Text(author),
                      ),
                      Text(DateFormat.yMMMd().add_jm().format(myDateTime))
                    ],
                  ),
                );
              })
            ]);
          }
        }
      },
    );
  }

  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search anything here"),
    );
  }
}
