import 'dart:math';

import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/view_course/course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseCard extends ConsumerWidget {
  CourseCard({Key? key, required this.course}) : super(key: key);
  final Course course;
  late CourseNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.notifier = ref.read(currentCourseProvider.notifier);

    int i = Random().nextInt(ref.read(colorPalleteProvider).length);

    final bkColor = ref.read(colorPalleteProvider)[i];
    // final bkColor = Colors[i];
    Utils.log('pallete index i = ${i.toString()}');
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
    // notifier.state.preReqs=
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) =>  CourseDetailPage()));
  }
}
