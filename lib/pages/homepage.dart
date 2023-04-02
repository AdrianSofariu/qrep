import 'package:flutter/material.dart';
import 'package:qrep/auth_service.dart';
import 'package:qrep/pages/explore_page.dart';
import 'package:qrep/pages/login_or_register_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('images/question.jpg'),
              const Text(
                'Welcome to QRep!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            //margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.green,
                Colors.black,
              ],
            )),
            child: const Text(
              'QRep is the app that helps you find the best questions and exercises to use when creating a test or quiz. Browse our repository or start adding your own creations!',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            //color: Colors.green,
            padding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset('images/uitest.png'),
                ElevatedButton(
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.black),
                    minimumSize: MaterialStatePropertyAll(Size.square(100)),
                    shadowColor: MaterialStatePropertyAll(Colors.red),
                    elevation: MaterialStatePropertyAll(20),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          if (isloggedIn) {
                            return const Explorer();
                          }
                          //modify button route
                          else {
                            return const LoginOrRegisterPage();
                          }
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Get started!',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
