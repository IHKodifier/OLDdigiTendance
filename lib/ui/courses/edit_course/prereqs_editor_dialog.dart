import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditorDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreReqsEditorDialogState();
}

class _PreReqsEditorDialogState extends ConsumerState<PreReqsEditorDialog> {
  @override
  // TODO: implement ref
  WidgetRef get ref => super.ref;
  List<Course?>? allCourses;
  List<Course>? selectedCourses;
  List<Course?> availableCourses = [];
  AsyncValue? asyncData;
  Course? currentCourse;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//read allcourses from tempallcoursesAsync
    asyncData = ref.watch(allCoursesProvider);

    return asyncData!.when(
      error: (e, st, data) {
        throw Exception(e);
      },
      loading: (data) {
        return Center(child: CircularProgressIndicator());
      },
      data: onData,
    );
  }

  Widget onData(dynamic data) {
    allCourses = data;
    selectedCourses = ref.read(currentCourseProvider).preReqs;

    availableCourses.clear();
    Utilities.log('cleared available courses');
    allCourses!.forEach((element) {
      if (!selectedCourses!.contains(element)) {
        Utilities.log('adding ${element!.courseId} to available courses');
        availableCourses.add(element);
      }
    });
//build selectedand available lists

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
                children: selectedCourses!
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
                            onTap: () {
                              // final notifier = ref.watch(
                              //     currentCourseProvider.notifier);
                              // notifier.removePreReq(e);
                              setState(() {
                                selectedCourses!.remove(e);
                              });
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
                children: availableCourses
                    .map((e) => Container(
                          width: 150,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            onTap: () {
                              // final notifier = ref.watch(
                              //     currentCourseProvider.notifier);
                              // notifier.removePreReq(e);
                              setState(() {
                                selectedCourses!.add(e!);
                              });
                            },
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

  ///TODO
// Build list exlusivity functions
}
