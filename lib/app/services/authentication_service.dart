// ignore_for_file: unnecessary_const, constant_identifier_names

import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginProvider { EmailPassword, Google, Facebook, Twitter, Phone }

class AuthenticationService {
  final instance = FirebaseAuth.instance;
  late UserCredential userCredential;

  Future<AppUser?> login({
    required LoginProvider loginProvider,
    required String email,
    required String password,
  }) async {
    instance.setPersistence(Persistence.LOCAL);
    switch (loginProvider) {
      case LoginProvider.EmailPassword:
        try {
          userCredential = await instance.signInWithEmailAndPassword(
              email: email, password: password);
        } catch (e) {
          Utilities.log(e.toString());

          /// if (e.code == 'user-not-found') {
          ///   print('No user found for that email.');
          /// } else if (e.code == 'wrong-password') {
          ///  print('Wrong password provided for that user.');
        }
        if (userCredential.user != null) {
          Utilities.log('''
          sign in with EMAIL/PASSWORD successfull for ${userCredential.user!.email}...
          reading appUserdoc from Firestore...
          
          ''');

          Map<String, dynamic>? data;
          try {
            data = await FirestoreService()
                .getAppUserDoc(userId: userCredential.user!.email!);
          } catch (e) {
            Utilities.log(e.toString());
          }
          Utilities.log(data.toString());
          return AppUser.fromJson(data!, data['userId']);
        }
        break;
      //TODO: implement other cases

      default:
    }
  }

  bool checkExistingUser() {
    return instance.currentUser != null;
  }
}
