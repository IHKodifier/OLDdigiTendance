// ignore_for_file: unused_local_variable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

final coursesStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreProvider).collection('courses').snapshots();
});

// ignore: deprecated_member_use
final colorPalleteProvider = Provider<dynamic>((ref) {
  return colorsList;
});

var colorsList = [
  Colors.red,
  Colors.red.shade100,
  Colors.red.shade500,
  Colors.deepOrange.shade100,
  Colors.deepOrange.shade500,
  Colors.redAccent,
  Colors.blueGrey.shade200,
  Colors.greenAccent,
  Colors.lightBlueAccent,
  Colors.cyanAccent,
  Colors.deepPurpleAccent,
  Colors.lightGreenAccent,
  Colors.indigoAccent,
  Colors.pinkAccent,
  Colors.tealAccent,
  Colors.cyanAccent,
  Colors.limeAccent,
  Colors.pinkAccent,
  Colors.amberAccent
];

///[courseProvider] provides inatance of [Course] managedg by [CourseNotifier]
final courseProvider = StateNotifierProvider<CourseNotifier, Course>((ref) {
  return CourseNotifier(Course(), ref);
});

/// [preReqsProvider] provides a stream of [Course] located in the [courses/preReqs collection] of firestore
final preReqsProvider =
    FutureProvider<QuerySnapshot<Map<String, dynamic>>>((ref) async {
  final course = ref.watch(courseProvider);
  return ref
      .read(firestoreProvider)
      .collection('courses')
      .where('courseId', isEqualTo: course.courseId)
      .get()
      .then((value) =>
          value.docs[0].reference.collection('preReqs').get().then((value) {
            final notifier = ref.read(courseProvider.notifier);
            notifier.setPreReqsonCourse(value);
            return value;
          }));
});

/// [sessionListProvider] provides all the session for a [Course]
final sessionListProvider =
    FutureProvider<QuerySnapshot<Map<String, dynamic>>>((ref) async {
  final Course course = ref.watch(courseProvider);
  return ref
      .watch(firestoreProvider)
      .collection('courses')
      .where('courseId', isEqualTo: course.courseId)
      .get()
      .then((value) =>
          value.docs[0].reference.collection('sessions').get().then((value) {
            final notifier = ref.read(courseProvider.notifier);
            notifier.setSessiononCourseProvider(value);
            return value;
          }));
});
