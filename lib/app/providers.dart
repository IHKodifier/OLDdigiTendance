// ignore_for_file: unused_local_variable, avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/app/notifiers/faculty_search_notifier.dart';
import 'package:digitendance/app/notifiers/institution_notifier.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/faculty_search_state.dart';
import 'package:digitendance/states/institution_state.dart';
import 'package:digitendance/states/prereqs_editing_state.dart';
import 'package:digitendance/ui/courses/edit_course/prereqs_editing_widget.dart';
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

/// INSTANCE PROVIDERS

//////[authInstanceProvider] shall provide the
///[FirebaseAuth] instance to the entire app
final Provider<FirebaseAuth> authInstanceProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// API PROVIDERS

///[firestoreProvider] shall provide the firestore instance
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

///
///                                    API PROVIDERS
///shall provide the[AuthApi] instance
final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(
    ref.read(authInstanceProvider),
  ),
);

///
/// shall provide the [FirestoreApi] instance
final firestoreApiProvider = Provider<FirestoreApi>((ref) => FirestoreApi());

///                                             STREAM PROVIDERS
///
///
///listens to [AuthStatechanges]  on [FirebaseAuth] instance and yields a firebase [User] or [null] when the auth state changes
final authStateChangesStreamProvider = StreamProvider<User?>(
    (ref) => ref.watch(authInstanceProvider).authStateChanges());

/// [coursesStreamProvider] provides stream of [Course] from firestore

final coursesStreamProvider =
    StreamProvider<QuerySnapshot<Map<String, dynamic>>>((ref) {
  var instituionId = ref.read(InstitutionProvider).docRef;

  return ref
      .watch(firestoreProvider)
      .doc(instituionId.path)
      .collection('courses')
      .snapshots();
});

///                                      STATE PROVIDERS

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
    var data =
        await firestoreApi.getAppUserDoc(userId: authUser.email!, refBase: ref);
    AppUser _appUser =
        AppUser.fromJson(data.docs[0].data(), data.docs[0].data()['email']);
    return _appUser;
  }
});

///                                STATE NOTIFIER PROVIDERS
///
///
///
///
///[currentCourseProvider] provides inatance of currently selected [Course] managedg by [CourseNotifier]
final currentCourseProvider =
    StateNotifierProvider<CourseNotifier, Course>((ref) {
  return CourseNotifier(Course(), ref);
});
///[courseEditingProvider] provides inatance of currently EDITED [Course] managedg by [CourseEditingNotifier]
final courseEditingProvider =
    StateNotifierProvider<CourseEditingNotifier, Course>((ref) {
  return CourseEditingNotifier(Course(), ref);
});

/// [preReqsProvider] provides a stream of [Course] located in the [courses/preReqs collection] of firestore
final preReqsProvider = FutureProvider<List<Course?>>((ref) async {
  var institutiondocRef = ref.read(InstitutionProvider).docRef;
  final course = ref.read(currentCourseProvider);
  return ref
      .read(firestoreProvider)
      .doc(institutiondocRef.path)
      .collection('courses')
      .where('courseId', isEqualTo: course.courseId)
      .get()
      .then((value) =>
          value.docs[0].reference.collection('preReqs').get().then((value) {
            final currentCourse = ref.read(currentCourseProvider);
            currentCourse.preReqs = value.docs.map((e) {
              Utils.log(
                  '${e.data()['courseId']} HAS BEEN ADDED TO CUURENT COURSE PROVIDER');

              return Course.fromData(e.data());
            }).toList();

            return value.docs
                .map(
                    (e) => Course.fromData(e.data(), e.reference))
                .toList();

            //
          }));
});

/// [sessionListProvider] provides all the session for a [Course]
///
final sessionListProvider =
    FutureProvider<QuerySnapshot<Map<String, dynamic>>>((ref) async {
  final docRef = ref.read(InstitutionProvider).docRef;
  final Course course = ref.watch(currentCourseProvider);
  return ref
      .watch(firestoreProvider)
      .doc(docRef.path)
      .collection('courses')
      .where('courseId', isEqualTo: course.courseId)
      .get()
      .then((value) =>
          value.docs[0].reference.collection('sessions').get().then((value) {
            final notifier = ref.read(currentCourseProvider.notifier);
            notifier.setSessiononCourseProvider(value);
            return value;
          }));
});

///[InstitutionProvider] will provide the state of [Instituion] and will be managed by [InstitutionNotifier]
final InstitutionProvider =
    StateNotifierProvider<InstitutionNotifier, Institution>((ref) {
  return InstitutionNotifier(Institution(), ref);
});

///[facultySearchProvider] provides searched  [Faculty]
final facultySearchProvider =
    StateNotifierProvider<FacultySearchNotifier, FacultySearchState>((ref) {
  return FacultySearchNotifier(FacultySearchState(), ref);
  // return [Faculty(userId: 'uimplemented error')];
});

final allCoursesProvider = FutureProvider<List<Course?>?>((ref) async {
  var docRef = ref.read(InstitutionProvider).docRef;
  // ref.listen(currentCourseProvider, (course ) {});
  return FirebaseFirestore.instance
      .doc(docRef.path)
      .collection('courses')
      .get()
      .then((value) => value.docs
          .map((e) => Course.fromData(e.data(), e.reference))
          .toList());
});

final preReqsEditingProvider =
    StateNotifierProvider<PreReqsEditingNotifier, PreReqsEditingState>((ref) {
  final previousPreReqsState = ref.read(currentCourseProvider).preReqs;
  var retval = PreReqsEditingNotifier(ref, previousPreReqsState);

  return retval;
});

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
