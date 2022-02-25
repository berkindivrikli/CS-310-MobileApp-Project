import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_app/routes/add_post.dart';
import 'package:project_app/routes/blogs.dart';
import 'package:project_app/routes/edit_profile.dart';
import 'package:project_app/routes/feed.dart';
import 'package:project_app/routes/feed_annon.dart';
import 'package:project_app/routes/home_page.dart';
import 'package:project_app/routes/profile_view.dart';
import 'package:project_app/routes/read_details.dart';
import 'package:project_app/routes/savedPosts.dart';
import 'package:project_app/routes/searchPage.dart';
import 'package:project_app/routes/searchPage_annon.dart';
import 'package:project_app/routes/signup.dart';
import 'package:project_app/services/auth.dart';
import 'package:project_app/routes/walktrough.dart';
import 'package:project_app/routes/login.dart';
import 'package:project_app/routes/welcome.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? initScreen = true;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getBool('initScreen');
  runApp(const MyFirebaseApp());
}

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  //final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
                home: Scaffold(
              body: Center(
                  child: Text(
                      "Could not connect to firebase: ${snapshot.error.toString()}")),
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const AppBase();
          }

          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text("LOADING...")),
            ),
          );
        });
  }
}

class AppBase extends StatelessWidget {
  const AppBase({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: (initScreen == true || initScreen == null)
            ? Walktrough(analytics: analytics, observer: observer)
            : HomePage(analytics: analytics, observer: observer),
        routes: {
          '/loginPage': (context) =>
              LoginPage(analytics: analytics, observer: observer),
          '/walktroughPage': (context) => Walktrough(
                analytics: analytics,
                observer: observer,
              ),
          '/signUpPage': (context) =>
              SignUpPage(analytics: analytics, observer: observer),
          '/welcomePage': (context) =>
              WelcomePage(analytics: analytics, observer: observer),
          '/HomePage': (context) =>
              HomePage(analytics: analytics, observer: observer),
          '/FeedPage': (context) => const Feed(),
          '/Profile': (context) => ProfileView(),
          '/SavedPosts': (context) => SavedPost(),
          '/SearchPage': (context) => SearchPage(),
          '/EditPage': (context) => EditPage(),
          '/AddPost': (context) => AddPost(),
          '/SearchPageAnnon': (context) => SearchPageAnnon(),
          '/FeedPageAnnon': (context) => const FeedAnnon(),
          '/BlogPage': (context) => BlogPage(),
        },
      ),
    );
  }
}
