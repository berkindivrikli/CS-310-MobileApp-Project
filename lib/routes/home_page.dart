import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/routes/welcome.dart';
import 'package:project_app/routes/walktrough.dart';
import 'package:provider/provider.dart';
import 'package:project_app/routes/feed.dart';
import 'package:project_app/routes/feed_annon.dart';
import 'package:project_app/routes/FeedBase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return WelcomePage(
          analytics: widget.analytics, observer: widget.observer);
    } else {
      return FeedBase(
        user: user,
      );
    }
  }
}
