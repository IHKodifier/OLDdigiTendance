import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    // final authState = ref.watch(authenticationProvider);

    return Container(
      width: 50,
      child: Column(
        children: [
          const Text('abc'),
        ],
      ),
    );
  }
}
