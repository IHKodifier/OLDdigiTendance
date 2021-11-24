// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import '../states/auth_state.dart';

///TODO declare all providers here
///
///
///
///
///
///
///                                  INSTANCE PROVIDERS

//////[authInstanceProvider] shall provide the
///[FirebaseAuth] instance to the entire app
final Provider<FirebaseAuth> authInstanceProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

///
///
///[firestoreProvider] shall provide the firestore instance
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

///
///
///
///
///
///
///                                    SERVICE PROVIDERS
///shall provide the[AuthApi] instance
final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(
    ref.read(authInstanceProvider),
  ),
);

///
/// shall provide the [FirestoreApi] instance
final firestoreApiProvider = Provider<FirestoreApi>((ref) => FirestoreApi());

///
///
///
///
///
///                                      STATE PROVIDERS
///listens to [AuthStatechanges]  on [FirebaseAuth] instance and yields a firebase [User] or [null] when the auth state changes
final authStateChangesStreamProvider = StreamProvider<User?>(
    (ref) => ref.watch(authInstanceProvider).authStateChanges());

/// shall provide [AuthNotifier] and [AuthState]
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthState, ref);
});

///  checks for the [currentUser] property  of [FireBaseAuthInstance] to see if a user is already authenticated
final currentAuthUserProvider =
    FutureProvider<User?>((ref) => FirebaseAuth.instance.currentUser);

///fetches the [AppUser] for the currently signed

final currentAppUserProvider = FutureProvider<AppUser?>((ref) async {
  final User? authUser = ref.read(authInstanceProvider).currentUser;
  final FirestoreApi firestoreApi = ref.read(firestoreApiProvider);
  if (authUser != null) {
    var data = await firestoreApi.getAppUserDoc(userId: authUser.email!);
    AppUser _appUser = AppUser.fromJson(data!, data['email']);
    return _appUser;
  }
});

/// [coursesStreamProvider] provides stream of [Course] from firestore
final coursesStreamProvider = StreamProvider<Course?>((ref) async* {
  final fireStream =
      ref.watch(firestoreProvider).collection('courses').snapshots();
  fireStream.forEach((element) {






    // ignore: avoid_function_literals_in_foreach_calls
    // ignore: void_checks
    element.docs.forEach((doc) async* {

    
      yield Course.fromMap(doc.data());
    });
  });
});

///
///
///
// /// [hasExistingUserprovider] checks for the [currentUser] property
// /// of [FireBaseAuthInstance] to see if a user is already authenticated
// final hasExistingUserProvider = FutureProvider<User?>((ref) {
//   return ref.read(firebaseAuthInstanceProvider).currentUser;
// });
