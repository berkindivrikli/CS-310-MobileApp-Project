import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference feedCollection =
      FirebaseFirestore.instance.collection("feednews");

  Future addUserAutoID(String email, String username, String token) async {
    userCollection
        .add({'email': email, 'username': username, 'token': token})
        .then((value) => print("User added"))
        .catchError((error) => print("Error: ${error.toString()}"));
  }

  Future addUser(String email, String username, String token) async {
    userCollection
        .doc(token)
        .set({'email': email, 'username': username, 'token': token});
  }
}
