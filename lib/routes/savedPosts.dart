import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/services/auth.dart';
import 'package:project_app/ui/Post.dart';
import 'package:flutter/cupertino.dart';

class SavedPost extends StatefulWidget {
  const SavedPost({Key? key}) : super(key: key);

  @override
  _SavedPostState createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _feeds =
      FirebaseFirestore.instance.collection("feednews");
  User? user = FirebaseAuth.instance.currentUser;
  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int idx = 2;

  List appbarsTitles = [
    "/FeedPage",
    "/SearchPage",
    "/SavedPosts",
    "/BlogPage",
    "/Profile"
  ];

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      id = user!.uid;
    }

    DocumentReference<Object?> userDoc = _users.doc(id);

    Future<DocumentSnapshot> result = userDoc.get();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageColors.appBarColor,
          title: Text("Saved News"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text("Connection Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              var postIds = snapshot.data!.get("savedposts");

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ...postIds.map((val) {
                        var feedDoc = _feeds.doc(val);

                        Future<DocumentSnapshot> response = feedDoc.get();

                        return FutureBuilder<DocumentSnapshot>(
                            future: response,
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.done) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: PostItem(
                                    fid: snap.data!.id,
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            });
                      })
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Container(
          height: 65.0,
          width: 65.0,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: PageColors.buttonColor,
              onPressed: () {},
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              // elevation: 5.0,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            // elevation: 20.0,

            shape: CircularNotchedRectangle(),
            child: Container(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
                    icon: Icon(Icons.bookmark),
                    onPressed: () {
                      setState(() {
                        idx = 2;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(right: 28.0),
                    icon: Icon(Icons.article),
                    onPressed: () {
                      setState(() {
                        idx = 3;
                        Navigator.of(context).pushNamed(appbarsTitles[idx]);
                      });
                    },
                  )
                ],
              ),
            )));
  }
}
