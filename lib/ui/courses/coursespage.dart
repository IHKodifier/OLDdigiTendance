import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/ui/courses/edit_course/edit_course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/new_course.dart/add_new_course.dart';
import 'package:digitendance/ui/courses/view_course/course_card.dart';
import 'package:digitendance/ui/courses/view_course/course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitendance > Courses'),
        // centerTitle: true,
      ),
      body: courses.when(
        data: (data) => CoursesList(data: data),
        error: (e, st, data) => Center(child: Text(e.toString())),
        loading: (_) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final courseNotifier = ref.watch(currentCourseProvider.notifier);
          navigateToAddCourse(context);
        },
        label: Text(
          'New Course',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Colors.white,
                // fontFamily: Goog¿,
                fontSize: 22,
              ),
        ),
        icon: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  navigateToAddCourse(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewCourse()));
  }
}

class CoursesList extends StatelessWidget {
  const CoursesList({Key? key, required this.data}) : super(key: key);
  final QuerySnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8),
          child: ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                final course = Course.fromData(
                    data.docs[index].data(), data.docs[index].reference);
                return CourseCard(
                  course: course,
                );
              }),
        ),
      ),
    );
  }
}
