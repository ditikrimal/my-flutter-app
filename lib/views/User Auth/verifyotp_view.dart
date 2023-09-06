// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class OtpPage extends StatefulWidget {
  var email = 'Admin';
  var password = 'Admin';
  var name = 'Admin';

  OtpPage(
      {super.key,
      required this.myauth,
      required this.email,
      required this.password,
      required this.name});
  final EmailOTP myauth;

  @override
  State<OtpPage> createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  late final TextEditingController _otp;
  // This variable determines whether the button is disable or not
  bool _isPressed = false;
  Color buttonColor = Colors.green;

  // This function is called when the button gets pressed
  void _myCallback() {
    setState(() {
      buttonColor = Colors.grey;
      _isPressed = true;
    });

    widget.myauth.setSMTP(
        host: "smtp.gmail.com",
        auth: true,
        username: "rml.ditik69@gmail.com",
        password: "puoorapmqqunupdh",
        secure: "TLS",
        port: 587);

    widget.myauth.setConfig(
        appEmail: "rml.ditik69@gmail.com",
        appName: "My Notes",
        userEmail: widget.email,
        otpLength: 6,
        otpType: OTPType.digitsOnly);

    widget.myauth.sendOTP();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: SizedBox(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Great!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            'OTP sent again.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      )),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      backgroundColor: Colors.green,
    ));
  }

  @override
  void initState() {
    super.initState();

    _otp = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _otp.dispose();
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
              return Form(
                child: Column(
                  children: [
                    const Card(
                      elevation: 0,
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 10),
                      child: Text('Verify Your OTP',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        'An otp has been sent to "${widget.email}"',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                          controller: _otp,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            prefixIconColor: Colors.white,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: ('OTP'),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      margin: const EdgeInsets.only(top: 30),
                      child: TextButton(
                        onPressed: () async {
                          var inputOTP = _otp.text;
                          try {
                            if (await widget.myauth.verifyOTP(otp: inputOTP) ==
                                true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: SizedBox(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Success',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'OTP Verified',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '(Redirecting to home)',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                backgroundColor: Colors.green,
                              ));

                              Map<String, String> dataToSave = {
                                'fullName': widget.name,
                                'email': widget.email,
                                'isVerified': 'true'
                              };
                              CollectionReference collectionRef =
                                  FirebaseFirestore.instance
                                      .collection('emailOTP');
                              collectionRef.doc(widget.email).set(dataToSave);

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              );

                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: widget.email,
                                        password: widget.password);
                              } on FirebaseAuthException {
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
                                        'Ann error occured.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
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
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: SizedBox(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Snap!',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Wrong OTP.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
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
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: SizedBox(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Snap!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Ann error occured.',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              backgroundColor: Color.fromARGB(255, 152, 18, 18),
                            ));
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side:
                              const BorderSide(width: 0.7, color: Colors.white),
                        ))),
                        child: const Text(
                          'VERIFY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.only(top: 20),
                                  child: const Text("Resend OTP once.",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      )),
                                ),
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 0),
                            child: ElevatedButton(
                              onPressed:
                                  _isPressed == false ? _myCallback : null,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor),
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ]),
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
