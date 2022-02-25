import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/ui/Post.dart';
import 'package:project_app/utils/styles.dart';

class CategorySearch extends StatefulWidget {
  CategorySearch({Key? key, required this.genre}) : super(key: key);

  final String genre;

  @override
  _CategorySearchState createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("feednews");

  final CollectionReference _firebaseUsers =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            // Fetch data here

            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element["category"]
                        .toString()
                        .toLowerCase()
                        .contains(widget.genre.toLowerCase()))
                .isEmpty) {
              return Scaffold(
                backgroundColor: PageColors.pageBackgroundColor,
                body: Center(
                  child: Text("No search query found"),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: PageColors.pageBackgroundColor,
                appBar: AppBar(
                  backgroundColor: PageColors.appBarColor,
                  title: Text(widget.genre + " News"),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element["category"]
                                .toString()
                                .toLowerCase()
                                .contains(widget.genre.toLowerCase()))
                        .map((QueryDocumentSnapshot<Object?> data) {
                      final String title = data.get('title');
                      final String content = data.get("content");
                      final String author = data.get("author");
                      final DateTime myDateTime = data['date'].toDate();
                      final String pp = data.get("authorPhoto");
                      final String contentImg = data.get("contentPhoto");

                      //Text(DateFormat.yMMMd().add_jm().format(myDateTime));

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: PostItem(
                          fid: data.id,
                        ),
                      );
                    })
                  ]),
                ),
              );
            }
          }
        });
  }
}
