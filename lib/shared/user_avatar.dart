import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final authState = ref.watch(authenticationProvider);

    return Container(
      width: 50,
      child: Column(
        children: [
          // CircleAvatar(
          //   child: authState.photoURL == null
          //       ? Icon(Icons.account_circle)
          //       : Image.network(authState.photoURL),
          //   maxRadius: 20,
          // ),
          Text(authState.authenticatedUser!.userId.toString()),
        ],
      ),
    );
  }
}
