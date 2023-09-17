// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/constants/routes.dart';
import 'package:myfirstapp/services/auth/auth_service.dart';
import 'package:myfirstapp/services/emailAuth.dart';
import 'package:myfirstapp/views/User%20Auth/login_view.dart';
import 'package:myfirstapp/views/User%20Auth/register_view.dart';
import 'package:myfirstapp/views/User%20Auth/verifyEmail_view.dart';
import 'package:myfirstapp/views/User%20Logged/logged_main.dart';
import 'package:myfirstapp/widgets/alert_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize;

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const HomePage(),
    initialRoute: '/',
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        try {
          final user = AuthService.firebase().currentUser;
          final userEmail = FirebaseAuth.instance.currentUser?.email;

          if (user != null) {
            return FutureBuilder<bool>(
              future: checkEmail(user, userEmail),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true ||
                    user.isEmailVerified == true) {
                  updateEmailVerification(userEmail);

                  return LoggedMainView();
                } else {
                  AuthService.firebase().sendEmailVerification();
                  return VerifyEmailView(
                    email: userEmail,
                  );
                  // return AlertSnackbar(
                  //   statusColor: Colors.red,
                  //   messageStatus: 'Snap!',
                  //   message: 'Email is not Verified',
                  //   secondaryMessage: 'Verifiction link has been sent to mail.',
                  // );
                }
              },
            );
          } else {
            return LoginView();
          }
        } catch (e) {
          return LoginView();
        }
      },
    );
  }
}
