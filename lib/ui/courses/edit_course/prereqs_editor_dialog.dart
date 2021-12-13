import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditorDialog extends ConsumerWidget {
  var  previousState;
  PreReqsEditorDialog({Key? key}) : super(key: key);
  // AsyncValue<Course> coursesMap;
  List<Course?>? allCourses = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    previousState = ref.watch(courseProvider);
    allCourses = ref.watch(allCoursesProvider).asData!.value;
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width * .8,
      child: Column(
        children: [
          // Text('PreReqs Editor Dialog'),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tap on a course to add/remove'),
          ),

          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 3, color: Theme.of(context).primaryColor)),
            child: Expanded(
              child: Wrap(
                children: ref
                    .watch(courseProvider)
                    .preReqs!
                    .map((e) => Container(
                          width: 150,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(e.courseId!),
                            onTap: () {
                              final notifier =
                                  ref.watch(courseProvider.notifier);
                              notifier.removePreReq(e);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text('available courses'),
          Container(
            decoration: BoxDecoration(
                // color: Theme.of(context).primaryColor,
                border: Border.all(
                    width: 3, color: Theme.of(context).primaryColor)),
            // color: Colors.orange.shade200,
            child: Expanded(
              child: Wrap(
                children: allCourses!
                    .map((e) => Container(
                          width: 150,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(e!.courseId!),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      // color: Colors.red,
    );
  }
}
