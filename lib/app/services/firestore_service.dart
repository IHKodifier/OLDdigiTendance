import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';

class FirestoreApi {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> querySnapshot;

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
      Utilities.log('roleId: $roleId not found in firesore');
      return null as UserRole;
    }
  }

  Future<Map<String, dynamic>?> getAppUserDoc({required String? userId}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await instance
        .collection('appUsers')
        .where('userId', isEqualTo: userId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0].data();
    } else {
      throw Exception('AppUserDoc not found in Firestore');
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>?>?>? getSessionsforCourse(
      {required String courseId}) async {
    querySnapshot = await instance
        .collection('courses')
        .where('courseId', isEqualTo: courseId)
        .get()
        .then((value) async {
      Utilities.log(
          ' sessions query length on $courseId equals ${value.docs.length.toString()}');

      return await value.docs[0].reference.collection('sessions').get();
    });
  }
}
