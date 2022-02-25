import 'package:firebase_analytics/firebase_analytics.dart';

setLogEvent(FirebaseAnalytics analytics) {
  analytics.logEvent(name: 'CS310_Test', parameters: <String, dynamic>{
    'string': 'string',
    'int': 310,
    'long': 1234567890123,
    'double': 310.202002,
    'bool': true,
  });

  print("Log event detected.");
}

setLogInEvent(FirebaseAnalytics analytics, String logType) {
  analytics.logLogin(loginMethod: logType);
  print("LogIn event detected.");
}

setCurrentScreen(
    FirebaseAnalytics analytics, String screenName, String screenClass) {
  analytics.setCurrentScreen(
    screenName: screenName,
    screenClassOverride: screenClass,
  );

  print("Set current screen called.");
}

setuserId(FirebaseAnalytics analytics, String userID) {
  analytics.setUserId(userID);
  print("Set user id called.");
}
