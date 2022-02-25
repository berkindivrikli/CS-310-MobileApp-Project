import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post extends StatefulWidget {
  Post({Key? key, required this.fid}) : super(key: key);

  late String author;
  late String title;
  late String content;
  late DateTime date;
  late String pp;
  late String contentImg;
  final String fid;

  User? user = FirebaseAuth.instance.currentUser;
  String id = "";

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  Icon _saveIcon = Icon(Icons.bookmark_border);
  CollectionReference _feed = FirebaseFirestore.instance.collection("feednews");
  CollectionReference _user = FirebaseFirestore.instance.collection("users");

  @override
  void initState() {
    // TODO: implement initState
    if (widget.user != null) {
      widget.id = widget.user!.uid;
    }
    super.initState();
  }

  Future<bool> isInclude(String val) async {
    DocumentSnapshot result = await _user.doc(widget.id).get();
    bool flag = false;

    result.get("savedposts").forEach((val) {
      if (val == widget.fid) {
        flag = true;
      }
    });
    return flag;
  }

  void savePost(String val) async {
    DocumentSnapshot result = await _user.doc(widget.id).get();
    result["savedposts"].add(val);
    _saveIcon = Icon(Icons.bookmark);
  }

  void removePost(String val) async {
    DocumentSnapshot result = await _user.doc(widget.id).get();
    result["savedposts"].remove(val);
    _saveIcon = Icon(Icons.bookmark_border);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      widget.id = widget.user!.uid;
    }
    Future<DocumentSnapshot> _init = _feed.doc(widget.fid).get();

    return FutureBuilder<DocumentSnapshot>(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Scaffold(
            body: Center(
              child: Text("Connection Error"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          widget.author = snapshot.data!.get("author");
          widget.pp = snapshot.data!.get("authorPhoto");
          widget.content = snapshot.data!.get("content");
          widget.title = snapshot.data!.get("title");
          widget.contentImg = snapshot.data!.get("contentPhoto");
          widget.date = snapshot.data!.get("date").toDate();

          Future<DocumentSnapshot> result = _user.doc(widget.id).get();

          return FutureBuilder<DocumentSnapshot>(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return Center(
                    child: Text("Connection Error"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  bool _isinclude = false;

                  List postList = snapshot.data!.get("savedposts");

                  postList.forEach((val) {
                    if (val == widget.fid) {
                      _isinclude = true;
                      _saveIcon = Icon(Icons.bookmark);
                    }
                  });

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: PageColors.appBarColor,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (_isinclude) {
                                  List posts = snapshot.data!.get("savedposts");
                                  posts.remove(widget.fid);
                                  _user
                                      .doc(widget.id)
                                      .update({"savedposts": posts});
                                  _saveIcon = Icon(Icons.bookmark_border);
                                } else {
                                  List posts = snapshot.data!.get("savedposts");
                                  posts.add(widget.fid);
                                  _user
                                      .doc(widget.id)
                                      .update({"savedposts": posts});
                                  _saveIcon = Icon(Icons.bookmark);
                                }
                              });
                            },
                            icon: _saveIcon)
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                            ),
                            Image.network(
                              widget.contentImg,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(widget.content),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24.0,
                                      backgroundImage: NetworkImage(widget.pp),
                                      backgroundColor: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 0, 40, 0),
                                      child: Text(widget.author),
                                    ),
                                    Text(DateFormat.yMMMd().format(widget.date))
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
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class PostItem extends StatefulWidget {
  late String pp;
  late String name;
  late DateTime date;
  late String img;
  late String title;
  late String content;

  late String fid;

  PostItem({Key? key, required this.fid}) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  CollectionReference _feed = FirebaseFirestore.instance.collection("feednews");

  @override
  Widget build(BuildContext context) {
    DocumentReference feedDoc = _feed.doc(widget.fid);
    Future<DocumentSnapshot> response = feedDoc.get();
    return FutureBuilder<DocumentSnapshot>(
      future: response,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Center(
            child: Text("Connection Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          widget.pp = snapshot.data!.get("authorPhoto");
          widget.name = snapshot.data!.get("author");
          widget.content = snapshot.data!.get("content");
          widget.date = snapshot.data!.get("date").toDate();
          widget.title = snapshot.data!.get("title");
          widget.img = snapshot.data!.get("contentPhoto");

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.5),
            child: InkWell(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(widget.pp),
                      backgroundColor: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "${widget.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      DateFormat.yMMMd().add_jm().format(widget.date),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.network(
                    widget.img,
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Post(fid: widget.fid)));
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
