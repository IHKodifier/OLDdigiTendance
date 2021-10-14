import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/services/authentication_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  AuthenticationNotifier(state) : super(state);
  // ignore: prefer_typing_uninitialized_variables
  late final appUser;

  Future<void> login({
    required LoginProvider loginProvider,
    required String email,
    required String password,
  }) async {
    var newState = AuthenticationState().initializeFrom(state);
    newState.isBusy = true;
    state = newState;

    appUser = await AuthenticationService().login(
      loginProvider: LoginProvider.EmailPassword,
      email: email,
      password: password,
    );
    if (appUser != null) {
      var newState = AuthenticationState().initializeFrom(state);
      // newstate.
      newState.authenticatedUser = appUser;
      newState.hasAuthenticatedUser = true;
      newState.isBusy = false;
      newState.asyncStatus =
          'user authenticated successfully... loading user data';

      newState.selectedRole = newState.authenticatedUser!.roles[0];
      newState.isBusy = false;
      Utilities.log('selected role = ${newState.selectedRole}');
      state = newState;
      Utilities.log(state.toString());

      Utilities.log('''
      Authentication state\'s authenticated user has been set to ${state.authenticatedUser.toString()}
      the UI should update now...''');
    }
  }

  @override
  void initState() {
    state.hasAuthenticatedUser = AuthenticationService().checkExistingUser();
  }
}
