import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/home/app_home.dart';
import 'package:digitendance/ui/login/login_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class StartupView extends ConsumerWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authenticationProvider);
    // auth.

// auth.resolveStartupLogin();

    if (auth.hasAuthenticatedUser) {
      Utilities.log('authenticated User detected');
      // Navigator.of(context).pushNamed(routes.HomeRoute);
      return const Material(child: AppHomePage());
    } else {
      Utilities.log('NO authenticated User detected');
      return Material(child: LoginView());
    }
  }

  resolveStartupLogin() {
    Utilities.log('resolving Startup Login');
    // auth
  }
}
