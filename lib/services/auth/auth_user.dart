import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isLoggedIn;
  const AuthUser(this.isLoggedIn);

  factory AuthUser.fromFirebase(User user) {
    final isLoggedIn = user != null;
    return AuthUser(isLoggedIn);
  }
}
