import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/shared/user_avatar.dart';
import 'package:digitendance/ui/home/admin_app_home.dart';
import 'package:digitendance/ui/home/student_app_home.dart';
import 'package:digitendance/ui/home/teacher_app_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeRouteResolver extends ConsumerWidget {
  const HomeRouteResolver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    final selectedRole = state.selectedRole;
    Utilities.log(
        'selectedRole equals \n ${selectedRole!.roleName} \n at time of HomeRouteResolver');
    return Scaffold(
      appBar: AppBar(
        actions: [UserAvatar()],
      ),
      body: _HomeBodyResolver(
          // selectedRole: selectedRole,
          ),
    );
  }
}

class _HomeBodyResolver extends ConsumerWidget {
  // final UserRole selectedRole;
  const _HomeBodyResolver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(authStateProvider).selectedRole;
    switch (selectedRole) {
      case UserRole.admin:
        return AdminHomeBody();
        break;
      case UserRole.teacher:
        return const TeacherAppHome();
        break;

      default:
        return const StudentAppHome();
    }

    return Container();
  }
}
