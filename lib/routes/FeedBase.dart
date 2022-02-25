import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/routes/welcome.dart';
import 'package:project_app/routes/walktrough.dart';
import 'package:provider/provider.dart';
import 'package:project_app/routes/feed.dart';
import 'package:project_app/routes/feed_annon.dart';

class FeedBase extends StatefulWidget {
  FeedBase({Key? key,required this.user}) : super(key: key);

  User? user;

  @override
  _FeedBaseState createState() => _FeedBaseState();
}

class _FeedBaseState extends State<FeedBase> {
  @override
  Widget build(BuildContext context) {
    

    if (widget.user!.isAnonymous) {
      return FeedAnnon();
    } else {
      return Feed();
    }
  }
}
