import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrep/pages/auth_page.dart';
import 'package:qrep/pages/explore_page.dart';
import 'package:qrep/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrep/pages/login_or_register_page.dart';
import 'package:qrep/pages/profile_page.dart';
import 'firebase_options.dart';
import 'package:qrep/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Ubuntu',
      ),
      home: const AuthPage(),
    );
  }
}

//sign out
void signUserOut() {
  FirebaseAuth.instance.signOut();
  isloggedIn = false;
}

//RootPage of the App
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  final user = FirebaseAuth.instance.currentUser!;

  List<Widget> pages = [
    const HomePage(),
    const Explorer(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar with login and logout functionlalities
      appBar: AppBar(
          leading: Image.asset(
            'images/QRep.png',
            scale: 25,
          ),
          /*const ImageIcon(
            AssetImage('images/QRep.png'),
            color: Colors.amber,
            size: 1,
          ),*/
          //const Icon(Icons.quiz_outlined),
          title: const Text('QRep'),
          actions: [
            isloggedIn
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      signUserOut();
                      setState(() {});
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LoginOrRegisterPage();
                          },
                        ),
                      );
                    },
                  )
          ]),
      body: pages[currentPage],
      //Navigation bar for the main pages
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(
                Icons.explore,
                color: Colors.white,
              ),
              label: 'Explore'),
          NavigationDestination(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
