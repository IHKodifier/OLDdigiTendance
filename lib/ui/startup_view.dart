import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:digitendance/ui/home/app_home.dart';
import 'package:digitendance/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartupView extends ConsumerWidget {
  StartupView({Key? key}) : super(key: key);
  late WidgetRef thisRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _stream = ref.watch(authStateChangesStreamProvider);
    // final hasExistingUser = ref.watch(hasExistingUserProvider);
    return _stream.when(
      data: (data) => _handleWhenData(data,ref),
      error: (e, st, data) => Text('error: $e'),
      loading: (data) => const Center(child: CircularProgressIndicator()),
    );
  }

  _handleWhenData(User? user, WidgetRef ref) {
    if (user != null) {
      
      final notifier = ref.watch(authStateProvider.notifier);
      // final authState = thisRef.watch(authStateProvider);
      notifier.setUserInAuthState(user);
      return AppHomePage();
    } else {
      return LoginView();
    }
  }
}
