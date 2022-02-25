import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/utils/styles.dart';

class DetailsRead extends StatefulWidget {
  DetailsRead({Key? key, required this.saveds}) : super(key: key);
  List saveds;

  @override
  State<DetailsRead> createState() => _DetailsReadState();
}

class _DetailsReadState extends State<DetailsRead> {
  late int countTech = 0;

  late int countPolitics = 0;

  late int countSport = 0;

  late int countMag = 0;

  late int countGame = 0;

  late int countSci = 0;

  bool check = false;

  CollectionReference _feeds =
      FirebaseFirestore.instance.collection("feednews");

  Future _calculateNums(List saveds) async {
    countTech = 0;

    countPolitics = 0;

    countSport = 0;

    countMag = 0;

    countGame = 0;

    countSci = 0;
    for (var element in saveds) {
      var res = await _feeds.doc(element).get();
      var cat = res.get("category");
      if (cat == "Technology") {
        countTech++;
      }
      if (cat == "Magazine") {
        countMag++;
      }
      if (cat == "Sports") {
        countSport++;
      }
      if (cat == "Gaming") {
        countGame++;
      }
      if (cat == "Politics") {
        countPolitics++;
      }
      if (cat == "Science") {
        countSci++;
      }
    }
    check = true;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.saveds.toString());
    print("build called");
    return FutureBuilder(
        future: _calculateNums(widget.saveds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Scaffold(
              body: Center(
                child: Text("Connection Error"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (true) {
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
                body: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: PageColors.appBarColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 32, 8, 32),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countTech.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Technology Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countPolitics.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Politics Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countSport.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Sports Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countMag.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Magazine Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countGame.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Gaming Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Chip(
                              avatar: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  countSci.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              label: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    "Read Science Articles",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
