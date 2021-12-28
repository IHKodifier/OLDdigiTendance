import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/ui/courses/edit_course/edit_course_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCourse extends ConsumerWidget {
  const EditCourse({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(currentCourseProvider.notifier);
    final state = ref.watch(currentCourseProvider);
    final oldState = state;
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course "${state.courseTitle}"'),
      ),
      body: EditCourseBody(state),
      // Center(child: Text(state.toString(),
    );
  }
}
