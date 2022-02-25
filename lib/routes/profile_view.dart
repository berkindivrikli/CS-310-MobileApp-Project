import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_app/routes/read_details.dart';
import 'package:project_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
//import 'package:xfile/xfile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  AuthService auth = AuthService();
  var _firebase = FirebaseFirestore.instance.collection("users");
  User? x = FirebaseAuth.instance.currentUser;
  String id = "";

  late int tech = 0;
  late int pol = 0;
  late int sci = 0;
  late int mag = 0;
  late int spo = 0;
  late int game = 0;

  Widget build(BuildContext context) {
    if (x != null) {
      id = x!.uid.toString();
    }

    Future<DocumentSnapshot> _future = _firebase.doc(id).get();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.of(context).pushNamed("/HomePage");
              },
              icon: Icon(
                Icons.logout_outlined,
                color: PageColors.appBarColor,
              ))
        ],
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
      body: FutureBuilder<DocumentSnapshot>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("Connection Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            File _pickedImg;
            XFile? _pickedXImg;

            FirebaseStorage _storage = FirebaseStorage.instance;

            final ref = _storage.ref().child("userImages").child(id + ".jpg");

            var photo = snapshot.data!.get("profilePhoto");
            String username = snapshot.data!.get("username");
            String email = snapshot.data!.get("email");
            String aboutMe = snapshot.data!.get("aboutme");
            int count = snapshot.data!.get("savedposts").length;
            List saveds = snapshot.data!.get("savedposts");

            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 70,
                              child: ClipOval(
                                child: photo.isNotEmpty
                                    ? Image.network(
                                        photo,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo,
                                        color: Colors.white),
                                    onPressed: () async {
                                      //print("abc");
                                      _pickedXImg = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      _pickedImg = File(_pickedXImg!.path);
                                      await ref.putFile(_pickedImg);
                                      var url = await ref.getDownloadURL();
                                      _firebase
                                          .doc(id)
                                          .update({"profilePhoto": url});
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                      color: PageColors.buttonColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Article Read",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(count.toString())
                                  ],
                                ),
                                VerticalDivider(
                                  thickness: 0.5,
                                  indent: 10,
                                  color: Colors.grey,
                                  endIndent: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: PageColors.buttonColor),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsRead(saveds: saveds)));
                                    },
                                    child:
                                        Text("Click for Read Articles details"))
                              ],
                            ),
                            height: 75,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height - 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32)),
                                color: PageColors.appBarColor,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 24, 16, 16),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      initialValue: username,
                                      readOnly: true,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        focusColor: Colors.white,
                                        labelText: "Username",
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 16),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      initialValue: email,
                                      readOnly: true,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        focusColor: Colors.white,
                                        labelText: "E-mail",
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 16),
                                    child: TextFormField(
                                      minLines: 4,
                                      maxLines: 4,
                                      style: TextStyle(color: Colors.white),
                                      initialValue: aboutMe,
                                      readOnly: true,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        focusColor: Colors.white,
                                        labelText: "Daily Blog",
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: Colors.green)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 16, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed("/EditPage");
                                            },
                                            child: Text(
                                              "Edit Profile",
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
