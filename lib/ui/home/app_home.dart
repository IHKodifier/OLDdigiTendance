import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/shared/user_avatar.dart';
import 'package:digitendance/ui/home/admin_app_home.dart';
import 'package:digitendance/ui/home/student_app_home.dart';
import 'package:digitendance/ui/home/teacher_app_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppHomePage extends ConsumerWidget {
  // final String title;
  const AppHomePage({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final authState = ref.watch(authenticationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DigiTendance'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white54,
      body: getUserHome(authState.selectedRole!),
    );
  }

  getUserHome(UserRole role) {
    if (role == UserRole.admin) {
      return const AdminAppHome();
    }
    if (role == UserRole.teacher) {
      return const TeacherAppHome();
    } else {
      return const StudentAppHome();
    }
  }
}
