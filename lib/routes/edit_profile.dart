import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/services/auth.dart';
import 'package:project_app/utils/styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  late String mail;
  late String username;
  late String aboutme;

  AuthService auth = AuthService();
  var _firebase = FirebaseFirestore.instance.collection("users");
  User? x = FirebaseAuth.instance.currentUser;
  String id = "";

  @override
  Widget build(BuildContext context) {
    if (x != null) {
      id = x!.uid;
    }

    return Scaffold(
      appBar: AppBar(
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
                    child: TextFormField(
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter your username";
                        }

                        return null;
                      },
                      onSaved: (String? value) {
                        if (value != null) {
                          username = value;
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        label: Text("Username"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter your e-mail.";
                        }
                        if (value != null && !EmailValidator.validate(value)) {
                          return 'The e-mail address is not valid.';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        if (value != null) {
                          mail = value;
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        label: Text("E-mail"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: TextFormField(
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter some information about yourself";
                        }

                        return null;
                      },
                      onSaved: (String? value) {
                        if (value != null) {
                          aboutme = value;
                        }
                      },
                      maxLines: 4,
                      minLines: 4,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        focusColor: Colors.white,
                        label: Text("Daily Blog"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.green)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                _firebase.doc(id).update({
                                  "username": username,
                                  "aboutme": aboutme,
                                  "email": mail
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Profile edited...")));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "Save Changes",
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () async {
                              _firebase.doc(id).delete();
                              await FirebaseAuth.instance.currentUser!.delete();
                              Navigator.of(context).pushNamed("/HomePage");
                            },
                            child: Text(
                              "Delete Profile",
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
