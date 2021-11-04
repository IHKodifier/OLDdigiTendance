import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentAppHome extends ConsumerWidget {
  const StudentAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final AuthNotifier notifier = ref.watch(authStateProvider.notifier);
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Student Home'),
        SizedBox(height: 10,),
        ElevatedButton(
            onPressed: () {
              notifier.signOut();
            },
            child: Text('Log out')),
      ],
    ));
  }
}
