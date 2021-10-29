import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState extends Equatable {
  bool isBusy = false;
  AppUser? authenticatedUser;
  String photoURL =
      'https://cdn1.iconfinder.com/data/icons/avatar-97/32/avatar-02-512.png';
  final someProvider = Provider<String>((ref) {
    return 'some value';
  });
  
  String asyncStatus = '';
  UserRole? selectedRole;

  handleUserRoles(Map<String, dynamic> data) async {
    // var userRole;
    // String rolesString = data['roles'];
    // List<String> rolesList = rolesString.split(',');
    // for (var i = 0; i < rolesList.length; i++) {
    //   try {
    //     userRole =
    //         await FirestoreService().getUserRoleDoc(roleId: rolesList[i]);
    //   } catch (e) {
    //     Utilities.log(e.toString());
    //   }

    //   if (i == 0) {
    //     this.selectedRole = userRole;
    //   }
    // //   // this.userRoles.add(userRole);
    // }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        isBusy,
        authenticatedUser,
        // photoURL,
        selectedRole ?? null,
        // hasAuthenticatedUser,
        asyncStatus,
      ];

  AuthState initializeFrom(AuthState source) {
    final clone = AuthState();
    // if (source._authenticatedUser != null) {
    //   clone._authenticatedUser = source._authenticatedUser;
    // }
    // clone.asyncStatus = source.asyncStatus;
    // clone.authenticatedUser = source.authenticatedUser;
    // clone.isBusy = source.isBusy;
    // clone.selectedRole = source.selectedRole;
    return clone;
  }

  @override
  String toString() {
    // TODO: implement toString

    return '''
    printing Authentication state
    
    authenticatedUser=${authenticatedUser!.toString()}
    userRoles=${authenticatedUser!.roles.map((e) => e.roleName)}
    selectedRole=${selectedRole!.roleName}
    isBusy=${isBusy.toString()}
    photoUrl=${photoURL}
    syncstatus = $asyncStatus
    ''';
  }

  Future<void> refreshUser() async {}
}
