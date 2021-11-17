import 'package:digitendance/app/models/app_user.dart';
import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/shared/user_avatar.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:digitendance/ui/home/admin_app_home.dart';
import 'package:digitendance/ui/home/student_app_home.dart';
import 'package:digitendance/ui/home/teacher_app_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHomePage extends ConsumerWidget {
  // final String title;
  const AppHomePage({Key? key}) : super(key: key);
  Widget onError(error, st, user) {
    return Center(child: Text('error ${error.toString()}'));
  }

  Widget onLoading(user) {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(context, ref) {
    // final AuthState authstate = ref.watch(authStateProvider);
    final asyncUser = ref.watch(currentAppUserProvider);
    return asyncUser.when(
      error: onError,
      loading: onLoading,
      data: onData,
    );
  }

  Widget onData(AppUser? user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DigiTendance'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white54,
      body: getUserHome(user!),
    );
  }

  getUserHome(AppUser user) {
    int x = 2;
    if (user.roles[0] == UserRole.admin) {
      return const AdminAppHome();
    }
    if (user.roles[0] == UserRole.teacher) {
      return const TeacherAppHome();
    } else {
      return const StudentAppHome();
    }
  }
}
