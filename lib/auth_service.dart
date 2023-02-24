import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qrep/read_data/get_userdetails.dart';

bool isloggedIn = false;

class AuthService {
  signInWithGoogle() async {
    //beginn intractive sign-in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //add user to db
    addUserDetails(gUser.displayName.toString(), gUser.email);

    //finally, sign-in
    //return await
    await FirebaseAuth.instance.signInWithCredential(credential);

    final user = FirebaseAuth.instance.currentUser!;
    Constants.getUserName(user.email.toString());
  }

  Future addUserDetails(String username, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'username': username,
      'email': email,
    }, SetOptions(merge: true));
  }
}
