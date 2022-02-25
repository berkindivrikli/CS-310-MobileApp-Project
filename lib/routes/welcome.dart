import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:project_app/utils/styles.dart';
import 'package:project_app/services/analytics.dart';
import 'package:project_app/services/auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int count = 0;
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(widget.analytics, "WelcomePage", "welcomePage");
    setLogEvent(widget.analytics);
    return Scaffold(
        backgroundColor: PageColors.pageBackgroundColor,
        body: Column(
          children: [
            SizedBox(
              height: 75,
            ),
            Text("Welcome to Fresh News!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: PageColors.pageTextColor)),
            SizedBox(height: 20),
            Text("Thank you for joining us",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: PageColors.pageTextColor)),
            SizedBox(height: 20),
            Text("Please login or sign up",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: PageColors.pageTextColor)),
            SizedBox(height: 50),
            Image.asset(
              'assets/logom.png',
              scale: 4,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 130,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginPage');
                      },
                      child: Text("Login",
                          style: TextStyle(
                              fontSize: 16, color: PageColors.buttonTextColor)),
                      style: ElevatedButton.styleFrom(
                          primary: PageColors.buttonColor, elevation: 10)),
                ),
                SizedBox(
                  width: 130,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signUpPage');
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              fontSize: 16, color: PageColors.buttonTextColor)),
                      style: ElevatedButton.styleFrom(
                          primary: PageColors.buttonColor, elevation: 10)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: PageColors.buttonColor, elevation: 10),
                onPressed: () {
                  auth.signInWithGoogle();
                  setuserId(widget.analytics, "googleUser");
                  setLogInEvent(widget.analytics, "google-login");
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.android),
                      Text("Sign in with Google!")
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: PageColors.buttonColor, elevation: 10),
                child: Text("Anonymus Login"),
                onPressed: () {
                  auth.signInAnon();
                },
              ),
            )
          ],
        ));
  }
}
