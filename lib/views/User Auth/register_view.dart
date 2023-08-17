// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/firebase_options.dart';
import 'package:email_otp/email_otp.dart';

import 'verifyotp_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;
  EmailOTP myauth = EmailOTP();
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
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
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
                              controller: _name,
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

                              if (email == "" || password == "" || name == "") {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  isButtonDisabled = false;
                                  buttonText = 'SIGNUP';
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: SizedBox(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Snap!',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Empty Fields.',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 152, 18, 18),
                                ));
                              } else {
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(email);
                                if (emailValid == false) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  setState(() {
                                    isButtonDisabled = false;
                                    buttonText = 'SIGNUP';
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: SizedBox(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Snap!',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Not a valid email',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 152, 18, 18),
                                  ));
                                } else {
                                  myauth.setSMTP(
                                      host: "smtp.gmail.com",
                                      auth: true,
                                      username: "rml.ditik69@gmail.com",
                                      password: "puoorapmqqunupdh",
                                      secure: "TLS",
                                      port: 587);

                                  myauth.setConfig(
                                      appEmail: "rml.ditik69@gmail.com",
                                      appName: "My Notes",
                                      userEmail: email,
                                      otpLength: 6,
                                      otpType: OTPType.digitsOnly);

                                  FirebaseAuth auth = FirebaseAuth.instance;

                                  List<String> emailExist = await auth
                                      .fetchSignInMethodsForEmail(email);
                                  if (emailExist.isEmpty) {
                                    try {
                                      if (password.length < 8) {
                                        await Future.delayed(
                                            const Duration(milliseconds: 200));
                                        setState(() {
                                          isButtonDisabled = false;
                                          buttonText = 'SIGNUP';
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: SizedBox(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Snap!',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Weak password',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    '(At least 8 characters)',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          backgroundColor:
                                              Color.fromARGB(255, 152, 18, 18),
                                        ));
                                      } else if (await myauth.sendOTP() ==
                                          true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: SizedBox(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Great',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "An otp was sent to $email",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )),
                                          behavior: SnackBarBehavior.floating,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          backgroundColor: Colors.green,
                                        ));

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OtpPage(
                                                    myauth: myauth,
                                                    email: email,
                                                    password: password,
                                                    name: name,
                                                  )),
                                          (route) => false,
                                        );
                                      }
                                    } catch (e) {
                                      await Future.delayed(
                                          const Duration(milliseconds: 200));
                                      setState(() {
                                        isButtonDisabled = false;
                                        buttonText = 'SIGNUP';
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: SizedBox(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Snap!',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'An error has occured.',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '(Please try again)',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 152, 18, 18),
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: SizedBox(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Snap!',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Email is already taken',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 152, 18, 18),
                                    ));
                                  }
                                }
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
                                            '/login',
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
