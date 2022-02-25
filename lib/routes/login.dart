import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_app/services/analytics.dart';
import 'package:project_app/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/services/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _message = '';
  late String mail;
  late String pass;
  late String username; // has not been added
  final _formKey = GlobalKey<FormState>();

  AuthService auth = AuthService();

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print("Build called");
    setCurrentScreen(widget.analytics, "LogInPage", "loginPage");
    setLogEvent(widget.analytics);
    return Scaffold(
        backgroundColor: PageColors.pageBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_return),
            color: PageColors.appBarButtonColor,
            iconSize: 28,
          ),
          title: Text("Login",
              style: TextStyle(
                color: PageColors.appBarTextColor,
                fontSize: 20,
              )),
          backgroundColor: PageColors.appBarColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Form(
                key: _formKey,
                child: Expanded(
                    child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 8, 4),
                        child: Text(
                            "Please enter the username you want to choose:",
                            style: TextStyle(
                              color: PageColors.pageTextColor,
                              fontSize: 16,
                            )),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Username",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 10, 20, 10),
                              hintStyle: TextStyle(
                                  color: PageColors.textFormFieldHintColor),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: BorderSide(
                                      color: PageColors
                                          .textFormFieldBorderColor)))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
                          child: Text("Please enter your email address:",
                              style: TextStyle(
                                color: PageColors.pageTextColor,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email Address",
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            hintStyle: TextStyle(
                                color: PageColors.textFormFieldHintColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                    color:
                                        PageColors.textFormFieldBorderColor))),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please enter your e-mail.";
                          }
                          if (value != null &&
                              !EmailValidator.validate(value)) {
                            return 'The e-mail address is not valid.';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          if (value != null) {
                            mail = value;
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
                          child: Text("Please enter your password:",
                              style: TextStyle(
                                color: PageColors.pageTextColor,
                                fontSize: 16,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "********",
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            hintStyle: TextStyle(
                                color: PageColors.textFormFieldHintColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                    color:
                                        PageColors.textFormFieldBorderColor))),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please enter your password.";
                          }
                          if (value != null && value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          if (value != null) {
                            pass = value;
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  auth.logInWithMailAndPass(mail, pass);
                                  setuserId(widget.analytics, mail);
                                  setLogInEvent(
                                      widget.analytics, "email-login");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Logging in...")));

                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text("Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: PageColors.buttonTextColor)),
                              style: ElevatedButton.styleFrom(
                                  primary: PageColors.buttonColor,
                                  elevation: 10)),
                        ),
                      ],
                    ),
                  ],
                ))),
            Text(
              _message,
              style: TextStyle(
                color: Colors.red,
              ),
            )
          ],
        ));
  }
}
