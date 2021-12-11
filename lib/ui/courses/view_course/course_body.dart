import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/ui/courses/view_course/prereqs_viewer.dart';
import 'package:digitendance/ui/courses/view_course/sessions_viewer_widget.dart';
import 'package:flutter/material.dart';

class CourseDetailBody extends StatelessWidget {
  const CourseDetailBody({Key? key, required this.course}) : super(key: key);
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
                        height: 15,
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
