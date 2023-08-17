import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                    'Home',
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
