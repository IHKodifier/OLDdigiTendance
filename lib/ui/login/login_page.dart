import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../login/login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black.withOpacity(0.65),
      child: Center(
        child: Container(
          width: 500,
          height: MediaQuery.of(context).size.height * .60,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28)),
            child: LoginForm(),
            // children: [
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 16.0),
            //     child: Text(
            //       'LOGIN',
            //       style: Theme.of(context).textTheme.headline3,
            //     ),
            //   ),
            //  EmailTextField(),
            //   SizedBox(
            //     height: 20,
            //   ),
            //   // buildPasswordFormField(passwordController),
            //   SizedBox(
            //     height: 20,
            //   ),
            //   // buildLoginButton(ref),
            //   // buildForgotPassword(),
            // ],
          ),
        ),
      ),
    );
  }
}
