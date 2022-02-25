import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogPost extends StatefulWidget {
  const BlogPost({Key? key, required this.bid}) : super(key: key);

  final String bid;

  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  CollectionReference _blogs = FirebaseFirestore.instance.collection("blogs");
  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> _future = _blogs.doc(widget.bid).get();
    return FutureBuilder<DocumentSnapshot>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("Conection Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            String title = snapshot.data!.get("title");
            String content = snapshot.data!.get("content");
            String writerID = snapshot.data!.get("writerID");
            String category = snapshot.data!.get("category");
            String contentPhoto = snapshot.data!.get("contentPhoto");

            Future<DocumentSnapshot> _userFut = _users.doc(writerID).get();

            return FutureBuilder<DocumentSnapshot>(
                future: _userFut,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("Connection Error"),
                    );
                  }
                  if (snap.connectionState == ConnectionState.done) {
                    String username = snap.data!.get('username');
                    String profilePhoto = snap.data!.get("profilePhoto");

                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/FeedPage");
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: PageColors.appBarColor,
                            )),
                        bottomOpacity: 0,
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 16),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                              Image.network(
                                contentPhoto,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(content),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24.0,
                                        backgroundImage:
                                            NetworkImage(profilePhoto),
                                        backgroundColor: Colors.grey,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 40, 0),
                                        child: Text(username),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class BlogItem extends StatefulWidget {
  const BlogItem({Key? key, required this.bid}) : super(key: key);

  final String bid;

  @override
  _BlogItemState createState() => _BlogItemState();
}

class _BlogItemState extends State<BlogItem> {
  CollectionReference _blogs = FirebaseFirestore.instance.collection("blogs");
  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> _future = _blogs.doc(widget.bid).get();
    return FutureBuilder<DocumentSnapshot>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("Conection Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            String title = snapshot.data!.get("title");
            String content = snapshot.data!.get("content");
            String writerID = snapshot.data!.get("writerID");
            String category = snapshot.data!.get("category");
            String contentPhoto = snapshot.data!.get("contentPhoto");

            Future<DocumentSnapshot> _userFut = _users.doc(writerID).get();

            return FutureBuilder<DocumentSnapshot>(
                future: _userFut,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("Connection Error"),
                    );
                  }
                  if (snap.connectionState == ConnectionState.done) {
                    String username = snap.data!.get('username');
                    String profilePhoto = snap.data!.get("profilePhoto");

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.5),
                      child: InkWell(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(profilePhoto),
                                backgroundColor: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(category + "-Blog"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Image.network(
                              contentPhoto,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogPost(bid: widget.bid)));
                        },
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
