import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:digitendance/states/institution_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreApi {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;
  late DocumentReference _institutionDocRef;
  DocumentReference? get institutionDocRef {
    if (_institutionDocRef != null) {
      return _institutionDocRef;
    } else
      throw UnimplementedError();
  }

  Future<UserRole> getUserRoleDoc({required String roleId}) async {
    querySnapshot = await FirebaseFirestore.instance
        .collection('userRoles')
        .where('roleId', isEqualTo: roleId)
        .get();
    if (querySnapshot.docs.length > 0) {
      //create role Object and return
      Map<String, dynamic> data = querySnapshot.docs[0].data();
      var userRole = UserRole(data['roleName']);
      return userRole;
    } else {
      Utils.log('roleId: $roleId not found in firesore');
      return null as UserRole;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAppUserDoc(
      {required String? userId, required ProviderRefBase refBase}) async {
    var userQuerySnapshot = await instance
        .collectionGroup('users')
        .where('userId', isEqualTo: userId)
        .get();

    Utils.log(
        ' user doc\'s parent\'s path equals  ${userQuerySnapshot.docs[0].reference.parent.parent.toString()}');
    _institutionDocRef = userQuerySnapshot.docs[0].reference.parent.parent!;
    var data = await instance
        .collection('institutions')
        .doc(_institutionDocRef.id)
        .get();
    Institution institution =
        Institution.fromData(data.data(), _institutionDocRef);
    final notifier = refBase.read(InstitutionProvider.notifier);
    // notifier.state.docRef = _institutionDocRef;
    await notifier.setInstitution(institution);

    Utils.log(
        'Institution set to ${institution.title} with firestore Document reference equal to ${notifier.docRef.toString()}');

    // querySnapshot.then((value) => value.docs[0].reference.parent.parent.toString())

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
      Utils.log(
          ' sessions query length on $courseId equals ${value.docs.length.toString()}');

      return await value.docs[0].reference.collection('sessions').get();
    });
  }

  Future<DocumentReference> addNewCourse(Course course) {
    ///TODO add institutionalized scope saving 
    // final institution = 

    return instance
        .collection('courses')
        .add(course.toMap())
        .then((value) => value);
  }
}
