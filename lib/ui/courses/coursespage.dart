import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesStreamProvider);

    return Scaffold(
        appBar: AppBar(),
        body: courses.when(
          data: (data) => CoursesList(data: data),
          error: (e, st, data) => Center(child: Text(e.toString())),
          loading: (_) => const Center(child: CircularProgressIndicator()),
        ));
  }
}

class CoursesList extends StatelessWidget {
  const CoursesList({Key? key, required this.data}) : super(key: key);
  final QuerySnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8),
      child: ListView.builder(
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            final course = Course.fromMap(data.docs[index].data());
            return CourseCard(
              course: course,
            );
          }),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({Key? key, required this.course}) : super(key: key);
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: 
      // ListTile(
      //   contentPadding: EdgeInsets.all(16),
      //   title: RotatedBox(
      //     quarterTurns: 3,
      //     child: Text(
      //       course.courseId,
      //       style: Theme.of(context).textTheme.headline6,
      //     ),
      //   ),
      //   subtitle: Text(
      //     course.courseTitle,
      //     style: Theme.of(context).textTheme.bodyText2,
      //   ),
      //   trailing: Text('Credits: ${course.credits.toString()}'),
      // ),
    );
  }
}
