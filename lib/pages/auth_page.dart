import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrep/main.dart';
import 'package:qrep/pages/login_or_register_page.dart';
import 'package:qrep/auth_service.dart';
import 'package:qrep/read_data/get_userdetails.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isloggedIn = true;
            final user = FirebaseAuth.instance.currentUser!;
            Constants.getUserName(user.email.toString());
            Constants.getUserEmail(user.email.toString());
            return const RootPage();
          }
          // user is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
