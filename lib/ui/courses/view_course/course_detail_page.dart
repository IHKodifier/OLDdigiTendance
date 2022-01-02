import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/ui/courses/edit_course/edit_course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/view_course/prereqs_viewer.dart';
import 'package:digitendance/ui/courses/view_course/sessions_viewer_widget.dart';
import 'package:digitendance/ui/courses/view_course/course_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailPage extends ConsumerWidget {
  CourseDetailPage({Key? key}) : super(key: key);
  bool editEnabled = false;
  late BuildContext localContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    localContext = context;
    final Course course = ref.watch(currentCourseProvider);
    final institution = ref.read(InstitutionProvider);
    final notifier = ref.watch(currentCourseProvider.notifier);
    String appBarTitle = course.courseId ?? 'New Course';
    // course.courseId = 'new course';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: CourseDetailBody(
        course: course,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(Icons.edit),
        label: Text(
          'Edit Course',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Colors.white,
                // fontFamily: Goog¿,
                fontSize: 22,
              ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  onPressed() {
    // Utilities.log('''
    //       Navigating to Edit course Route
    //       course state equals
    //       ${course.toString()}
    //       ''');
    Navigator.of(localContext)
        .push(MaterialPageRoute(builder: (_) => const EditCourse()));
  }
}
