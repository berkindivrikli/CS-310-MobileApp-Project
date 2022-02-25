import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/ui/Post.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/services/auth.dart';
import 'package:flutter/cupertino.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("feednews");

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PageColors.appBarColor,
          title: Text("Featured News"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              iconSize: 30.0,
              padding: EdgeInsets.only(right: 16.0),
              icon: Icon(Icons.account_box),
              onPressed: () {
                setState(() {
                  idx = 4;
                  Navigator.of(context).pushNamed(appbarsTitles[idx]);
                });
              },
            ),
          ],
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
                  ),
                ],
              ),
            )));
  }
}

/*
BottomNavigationBar(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        currentIndex: idx,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            if (idx != 2) {
              idx = index;
              Navigator.pushNamed(context, appbarsTitles[idx]);
            }
          });
        },
        selectedItemColor: PageColors.appBarColor,
        unselectedItemColor: PageColors.buttonColor,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
            //backgroundColor: PageColors.pageBackgroundColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: "Search",
              backgroundColor: PageColors.pageBackgroundColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: "",
              backgroundColor: PageColors.pageBackgroundColor),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Saved",
            //backgroundColor: PageColors.pageBackgroundColor
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
            ),
            label: "Profile",
            //backgroundColor: PageColors.pageBackgroundColor
          ),
        ],
      ),
 */