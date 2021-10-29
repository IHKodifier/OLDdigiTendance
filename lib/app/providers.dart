// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import '../states/auth_state.dart';

///TODO declare all providers here
///
///[firebaseAuthInstanceProvider] shall provide the
///[FirebaseAuth] instance to the entire app
final firebaseAuthInstanceProvider = Provider<FirebaseAuth>((ref) {
  final val = FirebaseAuth.instance;
  val.setPersistence(Persistence.LOCAL);
  return val;
});

//[firestoreProvider] shall provide the firestore instance
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

///[authServiceProvider] shall provide the[AuthService]
///instance app wide
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firebaseAuthInstanceProvider));
});

///[authStateChangesStreamProvider] listens to [AuthStatechanges] and yields a
///firebase [User] or [null] when the auth state changes
final authStateChangesStreamProvider = StreamProvider<User?>((ref) async* {
  yield* ref.watch(firebaseAuthInstanceProvider).authStateChanges();
});



///[authStateProvider] shall provide []AuthNotifier]
/// and [AuthState] app wide
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthState);
});
