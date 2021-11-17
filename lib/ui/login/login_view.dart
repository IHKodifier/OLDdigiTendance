import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/auth_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/home/app_home.dart';
import 'package:digitendance/ui/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends ConsumerWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(authStateChangesStreamProvider);

    // final authState = ref.watch(authStateProvider);
    // final notifier = ref.read(authStateProvider.notifier);

    return stream.when(
      error: (e, st, data) {
      return Container(
        height: 50,
        color: Colors.blue,
      );
    }, 
    loading: (data) {
      return Center(child: CircularProgressIndicator());
    }, 
    data: (data) {
      
      return _haandleUserInData(data);
      // return Container(
      //   color: Colors.black.withOpacity(0.65),
      //   child: Center(
      //     child: Container(
      //       width: 500,
      //       height: MediaQuery.of(context).size.height * .60,
      //       child: Card(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(28)),
      //         child: _LoginForm(),
      //         // children: [
      //         //   Padding(
      //         //     padding: const EdgeInsets.symmetric(vertical: 16.0),
      //         //     child: Text(
      //         //       'LOGIN',
      //         //       style: Theme.of(context).textTheme.headline3,
      //         //     ),
      //         //   ),
      //         //  EmailTextField(),
      //         //   SizedBox(
      //         //     height: 20,
      //         //   ),
      //         //   // buildPasswordFormField(passwordController),
      //         //   SizedBox(
      //         //     height: 20,
      //         //   ),
      //         //   // buildLoginButton(ref),
      //         //   // buildForgotPassword(),
      //         // ],
      //       ),
      //     ),
      //   ),
      // );
    });
  }

  _haandleUserInData(var user) {
    if (user.runtimeType == User) {
      return AppHomePage();
    } else {
      return LoginPage();
    }
  }
}

class _LoginForm extends ConsumerWidget {
  _LoginForm({
    Key? key,
  }) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final stream = ref.watch(authStateChangesStreamProvider);
    final notifier = ref.read(authStateProvider.notifier);

    // ignore: unused_local_variable

    return stream.when(
      error: (e, st, data) {
        return Container(
          height: 50,
          color: Colors.blue,
        );
      },
      loading: (data) {
        return CircularProgressIndicator();
      },
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'LOGIN',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              _emailTextField(),
              SizedBox(
                height: 20,
              ),
              _passwordTextField(),
              SizedBox(
                height: 20,
              ),
              buildLoginButton(ref),
              // buildForgotPassword(),
            ],
          ),
        );
      },
    );

    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 16.0),
    //         child: Text(
    //           'LOGIN',
    //           style: Theme.of(context).textTheme.headline3,
    //         ),
    //       ),
    //       _emailTextField(),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       _passwordTextField(),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       buildLoginButton(ref),
    //       // buildForgotPassword(),
    //     ],
    //   ),
    // );
  }

  _emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        // onSaved: (newValue) => email = newValue,
        onSaved: (value) {
          email = value!;
        },
        validator: (value) {},
        decoration: const InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.email)),
      ),
    );
  }

  _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: passwordController,
        onSaved: (value) {
          password = value!;
        },
        validator: (value) {},
        decoration: const InputDecoration(
            labelText: "Password",
            hintText: "Passwords are case SENSITIVE",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.email)),
      ),
    );
  }

  buildLoginButton(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final notifier = ref.read(authStateProvider.notifier);
    return Container(
      // width: 300,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
            icon: FaIcon(FontAwesomeIcons.key),
            onPressed: () {
              // isBusy = true;
              notifier.login(
                  loginProvider: LoginProvider.EmailPassword,
                  email: emailController.text,
                  password: passwordController.text);
              // isBusy = false;
            },
            label: const Text(
              'Login',
              style: TextStyle(fontSize: 22),
            )),
      ),
    );
  }
}
