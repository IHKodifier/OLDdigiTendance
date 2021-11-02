// ignore_for_file: unnecessary_this

import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends Equatable {
  // AppUser(this.userId);

  List<UserRole> roles = [];
  String? userId;
  AdditionalAppUserInfo? additionalAppUserInfo;
  String? get email => additionalAppUserInfo!.email;

  AppUser.fromJson(Map<String, dynamic> data, this.userId) {
    // userId = data['userId'];
    // _handleUserRoles(data);
    this.userId = data['userId'];

    _handleUserRoles(data);
    // additionalAppUserInfo!.photoUrl = data['photoURL'];
    Utilities.log('printing AppUser.fromJson\n${this.toString()}');
  }

  AppUser.fromFirebaseUser(User user) {
    this.userId = user.email;
    this.additionalAppUserInfo!.disPlayName = user.displayName;
    this.additionalAppUserInfo!.email = user.email;
    this.additionalAppUserInfo!.photoUrl = user.photoURL;
    Utilities.log('printing AppUser.fromFirebaseUser\n${this.toString()}');
  }

  _handleUserRoles(Map<String, dynamic>? data) {
    String rolesString = data!['roles'];
    var userRole;
    List<String> rolesSplitStringList = rolesString.split(', ');
    for (var i = 0; i < rolesSplitStringList.length; i++) {
      switch (rolesSplitStringList[i]) {
        case 'admin':
          roles.add(UserRole.admin);
          break;
        case 'teacher':
          roles.add(UserRole.teacher);
          break;
        default:
          roles.add(UserRole.teacher);
          break;
      }

      if (i == 0) {}
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userId];

  @override
  String toString() {
    return '''
  PRINTING APPUSER
  userId=$userId
  roles=${roles.map((e) => e.roleName.toString())}

  ''';
  }
}

class AdditionalAppUserInfo {
  String? disPlayName;

  String? email;

  String? photoUrl;

  var providerId;

  AdditionalAppUserInfo({
    this.disPlayName,
    this.email,
    this.photoUrl,
    this.providerId = 'Email',
  }) {
    assert(email != null);
  }
}
