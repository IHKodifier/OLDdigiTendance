import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAppHome extends ConsumerWidget {
  const AdminAppHome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef) {
    return Center(child: const Text('admin home'));
  }
}