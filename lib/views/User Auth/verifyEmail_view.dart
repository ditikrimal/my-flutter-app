import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/constants/routes.dart';
import 'package:myfirstapp/firebase_options.dart';
import 'package:myfirstapp/views/User%20Auth/login_view.dart';

class VerifyEmailView extends StatefulWidget {
  var email;

  VerifyEmailView({super.key, required this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'My Notes',
            style: TextStyle(
                fontFamily: 'cursive', color: Colors.blue, fontSize: 40),
          ),
          centerTitle: true,
          toolbarHeight: 150,
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
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                          child: Text(' Snap! Email is not verified yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 255, 0, 0)))),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                          child: Text('Verificaiton link has been sent to:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text("${widget.email}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Colors.black, spreadRadius: 3),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () async {
                            FirebaseAuth.instance.currentUser?.reload();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Check Again',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
