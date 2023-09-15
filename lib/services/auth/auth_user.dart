import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isOTPVerified;
  const AuthUser(this.isOTPVerified);

  static Future<AuthUser> fromFirebase(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('emailOTP')
        .doc(user.uid)
        .get();
    final data = doc.data();
    return AuthUser(data != null && data['isVerified'] == true);
  }
}
