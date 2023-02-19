import 'package:flutter/material.dart';
import 'package:qrep/pages/loginpage.dart';

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
                'Welcome to QREP!',
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
              'Qrep is the app that helps you find the best questions and exercises to use when creating a test or quiz. Browse our repository for free or create an account to become part of the community!',
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
                          return LoginPage();
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
