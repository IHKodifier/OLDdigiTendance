import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/states/prereqs_editing_state.dart';
import 'package:digitendance/ui/courses/edit_course/course_editing_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCourse extends ConsumerWidget {
  const EditCourse({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(currentCourseProvider.notifier);
    final state = ref.read(currentCourseProvider);
    // state.docRef = FirestoreApi().getCourseDocRef(ref.read(InstitutionProvider).docRef,state.courseId!) as DocumentReference<Object?>;

    return Scaffold(
        appBar: AppBar(
          title: Text('Editing  ...${state.courseTitle}...'),
          centerTitle: true,
        ),
        body: Scrollbar(
          child: CourseEditingBodyWidget(),
        ));
  }
}
