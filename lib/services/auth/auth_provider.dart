import 'package:email_otp/email_otp.dart';

import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logOut();
}
