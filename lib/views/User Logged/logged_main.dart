import 'package:cloud_firestore/cloud_firestore.dart';
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

int _selectedIndex = 1;
FirebaseAuth _auth = FirebaseAuth.instance;

String? getCurrentUserEmail() {
  User? user = _auth.currentUser;
  if (user != null) {
    return user.email;
  } else {
    return 'example@gmail.com';
  }
}

Future<String> getUserDetails(name) async {
  var collection = FirebaseFirestore.instance.collection('emailOTP');
  var docSnapshot = await collection.doc(getCurrentUserEmail()).get();

  Map<String, dynamic> data = docSnapshot.data()!;
  var fieldValue = data[name];
  return fieldValue;
}

void returnUserDetails(name) async {
  String userInfo = await getUserDetails(name);
  print(userInfo);
}

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
            padding: const EdgeInsets.all(10),
          ),
          const SizedBox(
            width: 20,
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
                    padding: const EdgeInsets.only(
                        top: 12, right: 12, bottom: 12, left: 14),
                    onPressed: () async {
                      final confirmLogOut = await showLogoutBox(context);

                      if (confirmLogOut == true) {
                        FirebaseAuth.instance.signOut();
                      } else {
                        (index) {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        };
                      }
                    },
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  if (index < _widgetOptions.length) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                }),
          ),
        ),
      ),
    );
  }

  Future<bool> showLogoutBox(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(top: 15, left: 27, right: 20),
            contentPadding:
                const EdgeInsets.only(left: 27, right: 32, top: 16, bottom: 10),
            backgroundColor: const Color.fromARGB(255, 10, 10, 10),
            title: const Text('Log Out', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Are you sure you want to logout ?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                )
              ]),
            ],
          );
        }).then((value) => value ?? false);
  }
}
