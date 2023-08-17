import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myfirstapp/views/User%20Logged/home_view.dart';
import 'package:myfirstapp/views/User%20Logged/profile_view.dart';

import '../../firebase_options.dart';

class LoggedMainView extends StatefulWidget {
  const LoggedMainView({super.key});

  @override
  State<LoggedMainView> createState() => _LoggedMainViewState();
}

int _selectedIndex = 0;

class _LoggedMainViewState extends State<LoggedMainView> {
  static const List<Widget> _widgetOptions = <Widget>[
    ProfileView(),
    HomeView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            iconSize: 30,
            padding: const EdgeInsets.only(right: 20),
          )
        ],
        backgroundColor: Colors.black,
        title: const Text(
          'My Notes',
          style: TextStyle(
              fontFamily: 'cursive', color: Colors.blue, fontSize: 35),
        ),
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
              return Column(
                children: [
                  Container(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue,
                color: Colors.white,
                tabs: [
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                    onPressed: () => {},
                  ),
                  const GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                      icon: Icons.logout,
                      onPressed: () => {
                            FirebaseAuth.instance.signOut(),
                          }),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  if (index < _widgetOptions.length) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  } else {
                    print('Index out of range');
                  }
                }),
          ),
        ),
      ),
    );
  }
}
