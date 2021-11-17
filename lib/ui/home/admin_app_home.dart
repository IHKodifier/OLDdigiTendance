import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAppHome extends ConsumerWidget {
  const AdminAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, widgetRef) {
    final notifier = widgetRef.read(authStateProvider.notifier);
    widgetRef.watch(authStateChangesStreamProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('admin home'),
          ElevatedButton(
              onPressed: () {
                notifier.signOut();
              },
              child: Text('Log out ')),
        ],
      ),
    );
  }
}
