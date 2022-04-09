// ignore_for_file: sdk_version_constructor_tearoffs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart' as utils;
import 'package:digitendance/states/institution_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities.dart';

class FirestoreApi {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  late DocumentReference _institutionDocRef;
  DocumentReference? get institutionDocRef {
    if (_institutionDocRef != null) {
      return _institutionDocRef;
    } else {
      throw UnimplementedError();
    }
  }

  Future<UserRole> getUserRoleDoc({required String roleId}) async {
    querySnapshot = await FirebaseFirestore.instance
        .collection('userRoles')
        .where('roleId', isEqualTo: roleId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      //create role Object and return
      Map<String, dynamic> data = querySnapshot.docs[0].data();
      var userRole = UserRole(data['roleName']);
      return userRole;
    } else {
      utils.Utils.log('roleId: $roleId not found in firesore');
      return null as UserRole;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppUserDoc(
      {required String? userId, required var refBase}) async {
    var userQuerySnapshot = await instance
        .collectionGroup('users')
        .where('userId', isEqualTo: userId)
        .get();

    utils.Utils.log(
        ' user\'s institutionPath : ${userQuerySnapshot.docs[0].reference.parent.parent.toString()}');
    _institutionDocRef = userQuerySnapshot.docs[0].reference.parent.parent!;
    var data = await instance
        .collection('institutions')
        .doc(_institutionDocRef.id)
        .get();
    Institution institution =
        Institution.fromData(data.data(), _institutionDocRef);
    final notifier = refBase.read(institutionProvider.notifier);
    // notifier.state.docRef = _institutionDocRef;
    await notifier.setInstitution(institution);

    utils.Utils.log(
        'Institution set to ${institution.title} with firestore Document reference equal to ${notifier.courseDocRef.toString()}');

    return userQuerySnapshot;

    //     .collection('appUsers')
    //     .where('userId', isEqualTo: userId)
    //     .get();
    // if (querySnapshot.docs.isNotEmpty) {
    //   return querySnapshot.docs[0].data();
    // } else {
    //   throw Exception('AppUserDoc not found in Firestore');
    // }
  }

  Future<QuerySnapshot<Map<String, dynamic>?>?>? getSessionsforCourse(
      {required String courseId}) async {
    querySnapshot = await instance
        .collection('courses')
        .where('courseId', isEqualTo: courseId)
        .get()
        .then((value) async {
      utils.Utils.log(
          ' sessions query length on $courseId equals ${value.docs.length.toString()}');

      return await value.docs[0].reference.collection('sessions').get();
    });
    return null;
  }

  Future<DocumentReference> addNewCourse(Course course) {
    ///TODO add institutionalized scope saving
    // final institution =

    return instance
        .collection('courses')
        .add(course.toMap())
        .then((value) => value);
  }

  // Future<DocumentReference<Map<String, dynamic>>?> getCourseDocRef(
  //     DocumentReference<Map<String, dynamic>>? insitutionDocRef,
  //     String courseId) async {
  //   var snapshot = await instance
  //       .collection('institutions')
  //       .doc(institutionDocRef!.path)
  //       .collection('courses')
  //       .where('courseId', isEqualTo: courseId)
  //       .get()
  //       .then((value) => value.docs[0].reference);
  //   return snapshot;
  // }
  Future<void> addSessionToCourse(Session session, DocumentReference? docRef) {
    return instance
        .doc(docRef!.path)
        .collection('sessions')
        .add(session.toMap());
  }

  getCoursesBySession(List<Session> sessions, ProviderRef ref) async {
    var db = ref.read(firestoreProvider);
    var institutionDocRef = ref.read(institutionProvider).InstitutionDocRef;
    //   Course course = db
    //       .collection('institutions')
    //       .doc(institutionDocRef.path)
    //       .collection(collectionPath);
  }

  ///get stream of [Session]from firestore for current faculty

  Future<AsyncValue<List<Session>>> getSessionsForFaculty(
    FutureProviderRef<AsyncValue<List<Session>>> ref,
  ) async {
    final institutionPath =
        ref.read(institutionProvider).InstitutionDocRef.path;
    Utils.log(' Instution psth  $institutionPath');
    final facultyId = ref.read(currentAppUserProvider).value?.email;
    List<Session> sessions = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await ref
        .read(firestoreProvider)
        .collectionGroup('sessions')
        .where('facultyId', isEqualTo: facultyId)
        .get();
    for (var doc in snapshot.docs) {
      Session session =
          Session.fromDataAndSessionDocRef(doc.data(), doc.reference);
      utils.Utils.log(
          'session read: reference =${session.parentCourseDocRef.toString()}');
      sessions.add(session);
    }
    return AsyncValue<List<Session>>.data(sessions);
  }

  ///TODO implement StreamTransformers where needed.
  // Stream<List<Session>> getfacultySessionStream(
  //     DocumentReference institutionDocRef, String facultyId) {
  //   return instance
  //       .collectionGroup('sessions')
  //       .where('facultyId', isEqualTo: facultyId)
  //       .snapshots()
  //       .transform(utils.Utils.streamTransformer(Session.fromJson));

  // }

}
