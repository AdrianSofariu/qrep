import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrep/read_data/get_username.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //get current user
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(children: [
          Container(
            color: Colors.green[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                //greet user
                const Text(
                  'Hello, ',
                  style: TextStyle(color: Colors.white),
                ),
                GetUserName(documentId: user.email.toString()),
                const Text(
                  '!',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
