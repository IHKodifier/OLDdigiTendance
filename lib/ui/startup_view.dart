import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/home/app_home.dart';
import 'package:digitendance/ui/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartupView extends ConsumerWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _stream = ref.watch(authStateChangesStreamProvider);
    return _stream.when(
      data: (data) => _handleWhenData(data),
      error: (e, st, data) => Text('error: $e'),
      loading: (data) => const Center(child: CircularProgressIndicator()),
    );
  }

  _handleWhenData(data) {
    if (data != null) {
      return const AppHomePage();
    } else {
      return LoginView();
    }
  }
}
