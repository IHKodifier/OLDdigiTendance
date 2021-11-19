import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(state, this.thisref) : super(AuthState());
  // ignore: prefer_typing_uninitialized_variables
  AppUser? appUser;
  User? user;
  AuthApi? authApi;
  final thisref;

  Future<void> login({
    required LoginProvider loginProvider,
    required String email,
    required String password,
  }) async {
    authApi = thisref.watch(authApiProvider);
    user = await authApi!.login(
      loginProvider: LoginProvider.EmailPassword,
      email: email,
      password: password,
    );
    if (user != null) setUserInAuthState(user);
  }

  setUserInAuthState(User? user) async {
    //TODO transform to AppUser and set then set state
    final firestoreService = thisref.watch(firestoreApiProvider);
    var data = await firestoreService.getAppUserDoc(userId: user!.email);
    AppUser appUser = AppUser.fromJson(data, user.email);
    // appUser = AppUser.fromFirebaseUser(user!);
    // final authstate = thisref.watch(authStateProvider);
    // var newState = AuthState().initializeFrom(state);
    // newstate.

    state.authenticatedUser = appUser;
    state.authenticatedUser!.additionalAppUserInfo!.email = user.email;
    state.hasAuthenticatedUser = true;
    state.isBusy = false;
    state.selectedRole = state.authenticatedUser!.roles[0];
    Utilities.log(''''
      AuthState equals 
      ${state.toString()}
      ''');
    // state = newState;
  }

  Future<void> signOut() async {
    authApi = thisref.watch(authApiProvider);
    await authApi!.signOut();
    Utilities.log(FirebaseAuth.instance.currentUser.toString());
  }
}
