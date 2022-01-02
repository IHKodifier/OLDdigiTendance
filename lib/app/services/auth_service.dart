// ignore_for_file: unnecessary_const, constant_identifier_names

import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginProvider { EmailPassword, Google, Facebook, Twitter, Phone }

class AuthApi {
  final FirebaseAuth instance;
  late UserCredential userCredential;
  String _email = '';
  String _password = '';
  // ignore: prefer_final_fields
  String _phone = '';

  AuthApi(this.instance);

  Stream<User?> get authStateChanges => instance.authStateChanges();

  Future<User?> login({
    required LoginProvider loginProvider,
    required String email,
    required String password,
  }) async {
    _email = email;
    _password = password;
    dynamic returnvalue;
    switch (loginProvider) {
      case LoginProvider.EmailPassword:
        returnvalue = signInwithEmail();
        break;
      case LoginProvider.Facebook:
        returnvalue = signInwithFacebook();
        break;
      case LoginProvider.Google:
        returnvalue = signInwithGoogle();
        break;
      case LoginProvider.Phone:
        returnvalue = signInwithPhone();
        break;

      default:
    }
    return returnvalue;
  }

  bool checkExistingUser() {
    return instance.currentUser != null;
  }

  Future<User?> signInwithEmail() async {
    try {
      userCredential = await instance.signInWithEmailAndPassword(
          email: _email, password: _password);
    } catch (e) {
      Utils.log(e.toString());
    }
    if (userCredential.user != null) {
      return userCredential.user;
    } else {
      return null;
    }
  }

  Future<User?> signInwithGoogle() async {
    throw UnimplementedError();
  }

  Future<User?> signInwithFacebook() async {
    throw UnimplementedError();
  }

  Future<User?> signInwithPhone() async {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    await instance.signOut();
  }
}


//TODO
          /// if (e.code == 'user-not-found') {
          ///   print('No user found for that email.');
          /// } else if (e.code == 'wrong-password') {
          ///  print('Wrong password provided for that user.');