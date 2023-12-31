// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/constants/routes.dart';
import 'package:myfirstapp/services/auth/auth_exceptions.dart';
import 'package:myfirstapp/services/auth/auth_service.dart';
import '../../firebase_options.dart';
import '../../widgets/alert_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final db = FirebaseFirestore.instance;
  bool isButtonDisabled = false;
  String buttonText = 'Login';

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

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
              return Center(
                child: Column(
                  children: [
                    const Card(
                      elevation: 0,
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 10),
                      child: Text('Login to Continue',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      margin: const EdgeInsets.only(top: 40),
                      child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            prefixIconColor: Colors.white,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: ('Email'),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          )),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                          controller: _password,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            counterStyle: TextStyle(fontFamily: 'cursive'),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: ('Password'),
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.grey),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      margin: const EdgeInsets.only(top: 30),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            isButtonDisabled = true;
                            buttonText = 'Loding...';
                          });
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await AuthService.firebase()
                                .logIn(email: email, password: password);
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            setState(() {
                              isButtonDisabled = false;
                              buttonText = 'Login';
                            });
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          } on InvalidCredentialsAuthException {
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            setState(() {
                              isButtonDisabled = false;
                              buttonText = 'Login';
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(AlertSnackbar(
                              statusColor:
                                  const Color.fromARGB(255, 152, 18, 18),
                              messageStatus: 'Snap!',
                              message: 'Invalid Email or Password',
                              secondaryMessage: '',
                            ));
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(AlertSnackbar(
                              statusColor:
                                  const Color.fromARGB(255, 152, 18, 18),
                              messageStatus: 'Snap!',
                              message: 'An error has occured',
                              secondaryMessage: ' (Please try again)',
                            ));
                          } //catch
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side:
                              const BorderSide(width: 0.7, color: Colors.white),
                        ))),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(top: 10),
                                child: const Text('Dont\'have an account?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    )),
                              ),
                              Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(right: 40),
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      registerRoute,
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Signup',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 100, 119, 136),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ]))
                  ],
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
