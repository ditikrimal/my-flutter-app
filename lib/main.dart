// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myfirstapp/views/login_view.dart';
import 'package:myfirstapp/views/register_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const HomePage(),
    initialRoute: '/',
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginView(); // user is signed out
          } else {
            return HomeView();
          }
        } else {
          return CircularProgressIndicator(); // waiting for connection state to become active
        }
      },
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Notes',
          style: TextStyle(
              fontFamily: 'cursive', color: Colors.blue, fontSize: 35),
        ),
        toolbarHeight: 80,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                width: double.infinity,
                child: Text(
                  'Hello World',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.black,
              hoverColor: Colors.blue,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue,
              color: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  onPressed: () => {},
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                    icon: Icons.logout,
                    onPressed: () async =>
                        {await FirebaseAuth.instance.signOut()}),
              ],
              selectedIndex: 1,
            ),
          ),
        ),
      ),
    );
  }
}
