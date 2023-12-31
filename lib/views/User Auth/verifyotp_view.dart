// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfirstapp/constants/routes.dart';
import 'package:myfirstapp/services/sendOTP_auth.dart';
import '../../widgets/alert_snackbar.dart';
import '/firebase_options.dart';

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

  // This function is called when the button gets pressed

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
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.pushNamedAndRemoveUntil(
                  context, loginRoute, (route) => false)
            },
            icon: const Icon(Icons.cancel),
            color: Colors.grey,
            iconSize: 30,
            padding: const EdgeInsets.only(bottom: 0, left: 10),
          ),
          const SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.black,
        title: const Text(
          'My Notes',
          style: TextStyle(
              fontFamily: 'cursive', color: Colors.blue, fontSize: 40),
        ),
        centerTitle: true,
        toolbarHeight: 125,
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
                                  .showSnackBar(AlertSnackbar(
                                statusColor: Colors.green,
                                messageStatus: 'Success',
                                message: 'OTP Verified',
                                secondaryMessage: ' (Redirecting to home)',
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
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(AlertSnackbar(
                                statusColor:
                                    const Color.fromARGB(255, 152, 18, 18),
                                messageStatus: 'Snap!',
                                message: 'Wrong OTP',
                                secondaryMessage: '',
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(AlertSnackbar(
                              statusColor:
                                  const Color.fromARGB(255, 152, 18, 18),
                              messageStatus: 'Snap!',
                              message: 'An error has occured',
                              secondaryMessage: ' (Please try again)',
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
