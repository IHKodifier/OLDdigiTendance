import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  UserAvatar({Key? key}) : super(key: key);
  late AppUser user;
  late AuthState authState;
  // late AuthSt

  @override
  Widget build(context, ref) {
    authState = ref.watch(authStateProvider);
    // user = ref.read(currentAuthUserProvider).whenData((value) => value ) as AppUser;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.account_circle,
          size: 30,
        ),
        Text(authState.authenticatedUser!.email!),
        // DropdownButton<String>(
        //   dropdownColor: Theme.of(context).primaryColorLight,
        //   isDense: true,
        //   autofocus: true,
        //   value: authState.selectedRole.roleName,
        //   items: user.userRoles
        //       .map(
        //         (e) => DropdownMenuItem<String>(
        //             child: Text(e.roleName), value: e.roleName),
        //       )
        //       .toList(),
        //   onChanged: (val) {
        //     user.userRoles.forEach((role) {
        //       if (role.roleName == val) {
        //         authState.selectedRole = role;

        //         Utilities.log('''selectedRole has been switched to
        //              ${authState.selectedRole.roleName}
        //                 ''');
        //       }
        //     });
        //   },
        // ),
      ],
    );
  }
}
