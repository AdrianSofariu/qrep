import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrep/main.dart';
import 'package:qrep/pages/loginpage.dart';
import 'package:qrep/auth_service.dart';

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
            return const RootPage();
          }
          // user is not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
