import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/ui/Blog.dart';
import 'package:project_app/ui/Post.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  CollectionReference _blogs = FirebaseFirestore.instance.collection("blogs");
  User? user = FirebaseAuth.instance.currentUser;
  String id = "";

  int idx = 0;

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

    return StreamBuilder(
      stream: _blogs.snapshots().asBroadcastStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: PageColors.appBarColor,
              automaticallyImplyLeading: false,
              title: Text("Blog Page"),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: PageColors.appBarColor,
              automaticallyImplyLeading: false,
              title: Text("Blog Page"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ...snapshot.data!.docs.map((QueryDocumentSnapshot data) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: BlogItem(bid: data.id),
                    );
                  })
                ],
              ),
            ),
            floatingActionButton: Container(
              height: 65.0,
              width: 65.0,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: PageColors.buttonColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/AddPost');
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  // elevation: 5.0,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
                      ),
                    ],
                  ),
                )),
          );
        }
      },
    );
  }
}
