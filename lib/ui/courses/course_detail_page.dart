import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/ui/courses/edit_course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/prereqs_viewer.dart';
import 'package:digitendance/ui/courses/sessions_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailPage extends ConsumerWidget {
  const CourseDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Course course = ref.watch(courseProvider);
    final notifier = ref.watch(courseProvider.notifier);
    String appBarTitle = course.courseId ?? 'New Course';
    // course.courseId = 'new course';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: _CourseDetailBody(
        course: course,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Utilities.log(''' 
          Navigating to Edit course Route 
          course state equals 
          ${course.toString()}          
          ''');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const EditCourse()));
        },
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
}

class _CourseDetailBody extends StatelessWidget {
  const _CourseDetailBody({Key? key, required this.course}) : super(key: key);
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 25,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          width: MediaQuery.of(context).size.width * .5,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        course.courseTitle!,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Theme.of(context).primaryColorDark),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${course.credits!} credits',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                PreReqsViewerWidget(),
                SessionsViewerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


