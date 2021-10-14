import 'package:digitendance/app/notifiers/authentication_notifier.dart';
import 'package:digitendance/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../states/authentication_state.dart';

///declare all providers here

// ignore: prefer_function_declarations_over_variables
final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>(
        (ref) => AuthenticationNotifier(AuthenticationState()));
