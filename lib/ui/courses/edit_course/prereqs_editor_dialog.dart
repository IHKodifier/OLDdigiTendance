import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditorDialog extends ConsumerStatefulWidget {
  Course? originalState;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreReqsEditorDialogState();
  void resetSelection() {
    
  }
}

class _PreReqsEditorDialogState extends ConsumerState<PreReqsEditorDialog> {
  @override
  // TODO: implement ref
  WidgetRef get ref => super.ref;
  List<Course?>? allCourses;
  List<Course>? selectedCourses;
  List<Course?> availableCourses = [];
  AsyncValue? asyncData;
  Course? originalState;
  @override
  void initState() {
    super.initState();
    widget.originalState = this.originalState;
  }

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
    originalState = ref.read(currentCourseProvider);
    allCourses = data;
    selectedCourses = ref.read(currentCourseProvider).preReqs;
    availableCourses.clear();
    Utils.log('cleared available courses');
    allCourses!.forEach((element) {
      if (!selectedCourses!.contains(element) & (element != originalState)) {
        Utils.log('adding ${element!.courseId} to available courses');
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
            // decoration: BoxDecoration(
            //     border: Border.all(
            //         width: 3, color: Theme.of(context).primaryColor)),
            child: Expanded(
              flex: 0,
              child: Card(
                // shape: ShapeBorder(),
                elevation: 5,
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: selectedCourses!
                        .map((e) => InputChip(
                              elevation: 10,
                              labelPadding: EdgeInsets.all(8),
                              backgroundColor: Colors.white,
                              avatar: CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                // minRadius: 200,
                                radius: 250,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FittedBox(
                                    child: Text(
                                      e.courseId!,
                                      style: TextStyle(
                                          // fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              label: Text(
                                e.courseTitle!,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                              onDeleted: () {
                                setState(() {
                                  selectedCourses!.remove(e);
                                  availableCourses.add(e);
                                });
                              },
                              deleteIcon: Icon(
                                Icons.cancel,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text('available courses'),
          Container(
            // decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            // border: Border.all(
            //     width: 3, color: Theme.of(context).primaryColor)),
            // color: Colors.orange.shade200,
            child: Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableCourses
                    .map((e) => ActionChip(
                          elevation: 10,
                          labelPadding: EdgeInsets.all(8),
                          backgroundColor: Colors.white,
                          avatar: CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            // minRadius: 200,
                            radius: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FittedBox(
                                child: Text(
                                  e!.courseId!,
                                  style: TextStyle(
                                      // fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          label: Text(
                            e.courseTitle!,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCourses!.add(e);
                            });
                          },

                          // deleteIcon: Icon(
                          //   Icons.cancel,
                          //   color:
                          //       Theme.of(context).primaryColor.withOpacity(0.7),
                          // ),
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
// reset state to original
  void resetState() {
    setState(() {
      widget.originalState = this.originalState;
    });
  }
}
