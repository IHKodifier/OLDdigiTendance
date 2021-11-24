import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class UserAvatar extends ConsumerWidget {
  UserAvatar({Key? key}) : super(key: key);
  late var user;
  late AuthState authState;
  // late AuthSt

  @override
  Widget build(context, ref) {
    authState = ref.watch(authStateProvider);
    // var notifier = ref.read(authStateProvider.notifier);
    user = ref.read(authStateProvider).authenticatedUser;

    return FocusedMenuHolder(openWithTap: true, onPressed: () {}, menuItems: [
      FocusedMenuItem(
        onPressed: () {},
        title: Text('User menu'),
      ),],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(authState.authenticatedUser!.email!),
                  _RolesDropDown(),
                ],
              ),
              Icon(
                Icons.account_circle,
                size: 45,
              ),
            ],
          ),
        );
      
    
  }
}

class _RolesDropDown extends ConsumerWidget {
  _RolesDropDown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.authenticatedUser;
    final notifier = ref.read(authStateProvider.notifier);
    return Container(
      width: 100,
      child: DropdownButton<String>(
        dropdownColor: Theme.of(context).primaryColorLight,
        isDense: true,
        autofocus: true,
        value: authState.selectedRole!.roleName,
        items: user!.roles
            .map(
              (e) => DropdownMenuItem<String>(
                  child: Text(e.roleName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white)),
                  value: e.roleName),
            )
            .toList(),
        onChanged: (val) {
          user.roles.forEach((role) {
            if (role.roleName == val) {
              notifier.setSelectedRole(role);

              Utilities.log('''selectedRole has been switched to
                  
                   ${notifier.state.selectedRole!.roleName}''
                      ''');
            }
          });
        },
      ),
    );
  }
}
