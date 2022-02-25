import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:project_app/services/analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Walktrough extends StatefulWidget {
  Walktrough({
    Key? key,
    required this.analytics,
    required this.observer,
  });

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WalktroughState createState() => _WalktroughState();
}

class _WalktroughState extends State<Walktrough> {
  PageController pc = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(widget.analytics, "WalkthroughPage", "walkthroughPage");
    setLogEvent(widget.analytics);
    return PageView(
      controller: pc,
      children: [
        Walktrough1(pc),
        Walktrough2(pc),
        WalktroughFinal(context, pc),
      ],
    );
  }
}

Widget Walktrough1(PageController pc) {
  return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("WELCOME TO FRESH NEWS!",
                          style: TextStyle(
                              color: WalktroughColors.walktroughTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CircleAvatar(
                  child: ClipOval(
                      child: Image(
                    image: AssetImage('assets/newspaper.jpg'),
                    fit: BoxFit.fill,
                    height: 250,
                  )),
                  radius: 110,
                ),
                SizedBox(height: 30),
                Text("OUR MAIN OBJECTIVE IS TO",
                    style: TextStyle(
                        fontSize: 15,
                        decorationThickness: 2.85,
                        color: WalktroughColors.walktroughTextColor)),
                Text("BRING YOU NEWS FROM ALL OVER THE WORLD!",
                    style: TextStyle(
                        fontSize: 15,
                        color: WalktroughColors.walktroughTextColor)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  pc.jumpToPage(1);
                },
                icon: Icon(Icons.keyboard_arrow_right_sharp),
                color: WalktroughColors.pcIconButtonColor,
                iconSize: 40,
              )
            ],
          )
        ],
      ),
      backgroundColor: WalktroughColors.walktroughbackgroundColor);
}

Widget Walktrough2(PageController pc) {
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Column(
          children: [
            SizedBox(
              height: 160,
            ),
            CircleAvatar(
              child: ClipOval(
                  child: Image(
                image: AssetImage('assets/categories.png'),
                fit: BoxFit.fill,
                height: 250,
              )),
              radius: 110,
            ),
            SizedBox(height: 30),
            Text("WITH OUR APP YOU CAN ACCESS",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            Text("NEWS FROM ALL KINDS OF CATEGORIES",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            Text("NATIONAL AND INTERNATIONAL!",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            SizedBox(height: 50),
            Text("YOU CAN ALSO SUBSCRIBE TO CATEGORIES",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            Text("AND KEEP TRACK OF THE LATEST NEWS",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            Text("WITH OUR NOTIFICATIONS",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
            Text("CUSTOMIZED ONLY FOR YOU!",
                style: TextStyle(
                    color: WalktroughColors.walktroughTextColor, fontSize: 15)),
          ],
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                pc.jumpToPage(0);
              },
              icon: Icon(Icons.keyboard_arrow_left_sharp),
              color: WalktroughColors.pcIconButtonColor,
              iconSize: 40,
            ),
            IconButton(
              onPressed: () {
                pc.jumpToPage(2);
              },
              icon: Icon(Icons.keyboard_arrow_right_sharp),
              color: WalktroughColors.pcIconButtonColor,
              iconSize: 40,
            )
          ],
        )
      ],
    ),
    backgroundColor: WalktroughColors.walktroughbackgroundColor,
  );
}

Widget WalktroughFinal(BuildContext context, PageController pc) {
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(height: 165),
              CircleAvatar(
                child: ClipOval(
                    child: Image(
                  image: AssetImage('assets/newspapers2.jpeg'),
                  fit: BoxFit.fill,
                  height: 250,
                )),
                radius: 110,
              ),
              SizedBox(height: 30),
              Text("ADDITIONALLY YOU CAN READ",
                  style: TextStyle(
                      fontSize: 15,
                      color: WalktroughColors.walktroughTextColor)),
              Text("ENTIRE DAILY NEWSPAPERS",
                  style: TextStyle(
                      fontSize: 15,
                      color: WalktroughColors.walktroughTextColor)),
              Text("FROM ALL COUNTRIES",
                  style: TextStyle(
                      fontSize: 15,
                      color: WalktroughColors.walktroughTextColor)),
              Text("OF THE WORLD",
                  style: TextStyle(
                      fontSize: 15,
                      color: WalktroughColors.walktroughTextColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                pc.jumpToPage(1);
              },
              icon: Icon(Icons.keyboard_arrow_left_sharp),
              color: WalktroughColors.pcIconButtonColor,
              iconSize: 40,
            ),
            TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setBool("initScreen", false);
                  Navigator.pushNamed(context, '/HomePage');
                },
                child: Text("Get Started!",
                    style: TextStyle(
                        fontSize: 20,
                        color: WalktroughColors.pcIconButtonColor))),
          ],
        ),
      ],
    ),
    backgroundColor: WalktroughColors.walktroughbackgroundColor,
  );
}
