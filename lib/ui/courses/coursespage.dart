import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/course_detail_page.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddCourse(context);
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  navigateToAddCourse(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CourseDetailPage()));
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
                final course = Course.fromData(data.docs[index].data());
                return CourseCard(
                  course: course,
                );
              }),
        ),
      ),
    );
  }
}

class CourseCard extends ConsumerWidget {
  CourseCard({Key? key, required this.course}) : super(key: key);
  final Course course;
  late CourseNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.notifier = ref.watch(courseProvider.notifier);

    int i = Random().nextInt(ref.read(colorPalleteProvider).length);

    final bkColor = ref.read(colorPalleteProvider)[i];
    // final bkColor = Colors[i];
    Utilities.log('pallete index i = ${i.toString()}');
    return InkWell(
      onTap: () {
        _setCourseInStateProvider(context);
      },
      hoverColor: Colors.purple.shade300,
      child: Card(
        elevation: 15,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: bkColor,
                minRadius: 50,
                child: FittedBox(
                  child: Text(
                    course.courseId!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseTitle!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${course.credits.toString()} Credits',
                      style: Theme.of(context).textTheme.overline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setCourseInStateProvider(BuildContext context) {
    notifier.state = course;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_)=>const CourseDetailPage()));
  }
}
