import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_app/services/auth.dart';
import 'package:project_app/utils/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  CollectionReference _blogs = FirebaseFirestore.instance.collection("blogs");
  CollectionReference _users = FirebaseFirestore.instance.collection("users");
  FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = Uuid();

  late String title;
  late String content;
  late String photoURL = "";
  late String category;

  late XFile? _pickedXImg;
  late File _pickedImg;

  AuthService auth = AuthService();
  User? x = FirebaseAuth.instance.currentUser;
  String id = "";

  @override
  Widget build(BuildContext context) {
    if (x != null) {
      id = x!.uid;
    }
    final String postID = uuid.v1();
    var ref = _storage.ref().child("postphotos").child(postID + ".jpg");
    Future<DocumentSnapshot> _future = _users.doc(id).get();

    return FutureBuilder<DocumentSnapshot>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Scaffold(
              body: Center(
                child: Text("Connection Error"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            String author = snapshot.data!.get("username");
            String authorPhoto = snapshot.data!.get("profilePhoto");
            Timestamp time = Timestamp.now();
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Create Post",
                  style: TextStyle(color: PageColors.appBarColor),
                ),
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: PageColors.appBarColor,
                    )),
                bottomOpacity: 0,
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: Form(
                  key: _key,
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: PageColors.appBarColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                            child: Container(
                                child: Center(
                                  child: (photoURL == "")
                                      ? IconButton(
                                          onPressed: () async {
                                            _pickedXImg = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            _pickedImg =
                                                File(_pickedXImg!.path);
                                            await ref.putFile(_pickedImg);
                                            var url =
                                                await ref.getDownloadURL();

                                            setState(() {
                                              photoURL = url;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                          ))
                                      : Image.network(photoURL),
                                ),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: TextFormField(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Title can not be empty";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                if (value != null) {
                                  title = value;
                                }
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                label: Text("Title"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Category can not be empty";
                                }

                                return null;
                              },
                              onSaved: (String? value) {
                                if (value != null) {
                                  category = value;
                                }
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                label: Text("Category"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return "Content can not be empty";
                                }

                                return null;
                              },
                              onSaved: (String? value) {
                                if (value != null) {
                                  content = value;
                                }
                              },
                              maxLines: 8,
                              minLines: 4,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.white),
                                focusColor: Colors.white,
                                label: Text("Content"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.grey),
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        _key.currentState!.save();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text("Submitting...")));

                                        _blogs.doc(postID).set({
                                          "content": content,
                                          "title": title,
                                          "contentPhoto": photoURL,
                                          "writerID": id,
                                          "category": category
                                        });

                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text(
                                      "Add Post",
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        photoURL = "";
                                      });
                                    },
                                    child: Text(
                                      "Discard Photo",
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
