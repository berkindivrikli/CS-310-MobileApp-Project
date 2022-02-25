import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/ui/Post.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/services/auth.dart';
import 'package:flutter/cupertino.dart';

class FeedAnnon extends StatefulWidget {
  const FeedAnnon({Key? key}) : super(key: key);

  @override
  _FeedAnnonState createState() => _FeedAnnonState();
}

class _FeedAnnonState extends State<FeedAnnon> {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("feednews");

  AuthService auth = AuthService();

  int idx = 0;

  List appbarsTitles = ["/FeedPageAnnon", "/SearchPageAnnon"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageColors.appBarColor,
          title: Text("Featured News"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.currentUser!.delete();
            },
          ),
        ),
        body: StreamBuilder(
            stream: _firebaseFirestore.snapshots().asBroadcastStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      ...snapshot.data!.docs
                          .map((QueryDocumentSnapshot<Object?> data) {
                        final String title = data.get('title');
                        final String content = data.get("content");
                        final String author = data.get("author");
                        final DateTime myDateTime = data['date'].toDate();
                        final String pp = data.get("authorPhoto");
                        final String contentImg = data.get("contentPhoto");

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: PostItem(
                            fid: data.id,
                          ),
                        );
                      })
                    ],
                  ),
                );
              }
            }),
        bottomNavigationBar: BottomAppBar(
            // elevation: 20.0,

            shape: CircularNotchedRectangle(),
            child: Container(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
                    icon: Icon(Icons.home),
                    onPressed: () {
                      setState(() {
                        idx = 0;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(right: 28.0),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        idx = 1;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  ),
                ],
              ),
            )));
  }
}
