import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:digitendance/ui/home/admin/admin_app_home.dart';
import 'package:digitendance/ui/home/home_route_resolver.dart';
import 'package:digitendance/ui/home/student_app_home.dart';
import 'package:digitendance/ui/home/faculty/_teacher_app_homeOLD%20APProach.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHomeView extends ConsumerWidget {
  // final String title;
  AppHomeView({Key? key}) : super(key: key);
  late AuthState authState;

  @override
  Widget build(context, ref) {
    authState = ref.watch(authStateProvider);
    final asyncUser = ref.watch(currentAppUserProvider);
    return asyncUser.when(
      error: onError,
      loading: onLoading,
      data: onData,
    );
  }

  Widget onError(
    error,
    st,
  ) {
    return Center(child: Text('error ${error.toString()}'));
  }

  Widget onLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget onData(
    AppUser? user,
  ) {
    return HomeRouteResolver();
  }
}
