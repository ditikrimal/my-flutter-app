import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../firebase_options.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Column(
              children: [
                Container(
                  height: 100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                  width: double.infinity,
                  child: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
