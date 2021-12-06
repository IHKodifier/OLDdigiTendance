import 'dart:html';

import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCourse extends ConsumerWidget {
  const EditCourse({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(courseProvider.notifier);

    final state = notifier.state;

    return Scaffold(
      appBar: AppBar(
      title: Text('Edit Course \"${state.courseTitle}\"'),
      
      ),
      body: Center(child: Text(state.toString())),
    );
  }
}
