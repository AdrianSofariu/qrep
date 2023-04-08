import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  //final String getDocId;
  static String? userName;
  static String? userEmail;

  Constants();

  //get username
  static void getUserName(String getDocId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var document = users.doc(getDocId);
    var snapshot = await document.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    userName = data['username'];
  }

  static void getUserEmail(String getDocId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var document = users.doc(getDocId);
    var snapshot = await document.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    userEmail = data['email'];
  }
}
