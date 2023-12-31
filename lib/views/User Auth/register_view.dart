// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/constants/routes.dart';
import 'package:myfirstapp/services/auth/auth_exceptions.dart';
import 'package:myfirstapp/services/auth/auth_service.dart';
import 'package:myfirstapp/services/sendOTP_auth.dart';
import 'package:myfirstapp/views/User%20Auth/verifyotp_view.dart';
import '../../widgets/alert_snackbar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;
  bool isButtonDisabled = false;
  String buttonText = 'Signup';

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();

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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: EdgeInsets.only(top: 10),
                          child: Text('Register New User',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          margin: const EdgeInsets.only(top: 40),
                          child: TextField(
                              textCapitalization: TextCapitalization.words,
                              controller: _name,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.left,
                              decoration: const InputDecoration(
                                prefixIconColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: ('Full Name'),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                buttonText = 'Loading...';
                              });
                              final email = _email.text;
                              final password = _password.text;
                              final name = _name.text;

                              try {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                await AuthService.firebase().createUser(
                                    name: name,
                                    email: email,
                                    password: password);
                                EmailOTP myAuth;
                                myAuth = SendOTP(email);
                                if (myAuth != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(AlertSnackbar(
                                    statusColor: Colors.green,
                                    messageStatus: 'Great!',
                                    message: "An otp was sent to $email",
                                    secondaryMessage: '',
                                  ));

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpPage(
                                              myauth: myAuth,
                                              email: email,
                                              password: password,
                                              name: name,
                                            )),
                                    (route) => false,
                                  );
                                }
                              } on EmptyFieldAuthException {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(AlertSnackbar(
                                  statusColor:
                                      const Color.fromARGB(255, 152, 18, 18),
                                  messageStatus: 'Snap!',
                                  message: 'Empty fields',
                                  secondaryMessage: '',
                                ));
                              } on InvalidEmailAuthException {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(AlertSnackbar(
                                  statusColor:
                                      const Color.fromARGB(255, 152, 18, 18),
                                  messageStatus: 'Snap!',
                                  message: 'Not a valid email',
                                  secondaryMessage: '',
                                ));
                              } on WeakPasswordAuthException {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(AlertSnackbar(
                                  statusColor:
                                      const Color.fromARGB(255, 152, 18, 18),
                                  messageStatus: 'Snap!',
                                  message: 'Weak password',
                                  secondaryMessage: ' (At least 6 characters)',
                                ));
                              } on EmailAlreadyTakenAuthException {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(AlertSnackbar(
                                  statusColor:
                                      const Color.fromARGB(255, 152, 18, 18),
                                  messageStatus: 'Snap!',
                                  message: 'Email is already taken',
                                  secondaryMessage: '',
                                ));
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  width: 0.7, color: Colors.white),
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
                                    child:
                                        const Text('Already have an account?',
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
                                            loginRoute,
                                            (route) => false);
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 100, 119, 136),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]))
                      ],
                    ),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
