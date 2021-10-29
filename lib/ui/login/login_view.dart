import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends ConsumerWidget {
  LoginView({Key? key}) : super(key: key);
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  bool isBusy = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Container(
      color: Colors.black.withOpacity(0.65),
      // width: 500,
      // height: 500,
      child: Center(
        child: Container(
          width: 500,
          height: MediaQuery.of(context).size.height * .60,
          child: Card(
            // elevation: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'LOGIN',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) => Container(
                      height: 30,
                      // color: Colors.pink.shade800,
                      child:
                          // ref.watch(authenticationProvider).isBusy
                          // buildBusy()
                      Container(),
                      ),
                ),
                buildEmailFormField(emailController),
                SizedBox(
                  height: 20,
                ),
                buildPasswordFormField(passwordController),
                SizedBox(
                  height: 20,
                ),
                buildLoginButton(),
                buildForgotPassword(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton buildForgotPassword() {
    return TextButton.icon(
        onPressed: () {},
        icon: FaIcon(
          FontAwesomeIcons.infoCircle,
          color: Colors.blueGrey.shade400,
          size: 25,
        ),
        label: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.blueGrey.shade300),
        ));
  }

  Container buildLoginButton() {
    return Container(
      // width: 300,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
            icon: FaIcon(FontAwesomeIcons.key),
            onPressed: () {
            },
            label: const Text(
              'Login',
              style: TextStyle(fontSize: 22),
            )),
      ),
    );
  }

  Widget buildBusy() {
    return const Center(child: LinearProgressIndicator());
  }

  Widget buildPasswordFormField(TextEditingController passwordController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        controller: passwordController,
        onChanged: (value) {},
        validator: (value) {},
        decoration: const InputDecoration(
            labelText: "Password",
            hintText: 'password',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: FaIcon(FontAwesomeIcons.key)),
      ),
    );
  }

  Widget buildEmailFormField(TextEditingController emailController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        // onSaved: (newValue) => email = newValue,
        onChanged: (value) {},
        validator: (value) {},
        decoration: const InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.email)),
      ),
    );
  }
}
