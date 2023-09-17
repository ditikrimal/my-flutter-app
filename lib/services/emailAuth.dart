import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfirstapp/services/auth/auth_user.dart';

Future<bool> checkEmail(AuthUser? user, email) async {
  // Check if the email is verified or not
  var collection = FirebaseFirestore.instance.collection('emailOTP');
  var docSnapshot = await collection
      .doc(
        email,
      )
      .get();

  Map<String, dynamic> data = docSnapshot.data()!;

  final isVerified = data['isVerified'];
  if (isVerified == 'true') {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateEmailVerification(email) async {
  // Check if the email is verified or not

  Map<String, String> dataToUpdate = {'isVerified': 'true'};
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('emailOTP');
  collectionRef.doc(email).update(dataToUpdate);
  return true;
}
