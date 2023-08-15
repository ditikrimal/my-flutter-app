// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/views/login_view.dart';

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
    home: HomePage(
      isOTPVerified: false,
    ),
  ));
}

class HomePage extends StatelessWidget {
  bool isOTPVerified;
  HomePage({super.key, required this.isOTPVerified});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Home',
            style: TextStyle(
                fontFamily: 'cursive', color: Colors.blue, fontSize: 40),
          ),
          toolbarHeight: 80,
          titleTextStyle: const TextStyle(
            fontSize: 35.0,
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
                final user = FirebaseAuth.instance.currentUser;
                final isEmailVerified = user?.emailVerified ?? false;
                if (isEmailVerified || isOTPVerified == true) {
                  print('Verified User');
                } else {
                  print('Email is not Verified');
                }
                return const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                );
              default:
                return const Text('Loading');
            }
          },
        ));
  }
}
