import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("users");

  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> getUser() async {
    return (await _auth.currentUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signUpWithMailAndPass(
      String mail, String pass, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: pass);
      User user = result.user!;

      await _firebaseFirestore.doc(user.uid).set({
        'email': mail,
        'username': username,
        'aboutme': "",
        'profilePhoto': "",
        'uid': user.uid,
        'savedposts': []
      });

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logInWithMailAndPass(String mail, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;
    /*if (user != null) {
      _firebaseFirestore.doc(user.uid).set({
        'username': user.displayName.toString(),
        'email': user.email.toString(),
        'aboutme': "",
        'profilePhoto': "",
        'uid': user.uid,
        'savedposts': []
      });
    }*/

    return _userFromFirebase(user);
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
