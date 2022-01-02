import 'package:digitendance/app/providers.dart';
import 'package:digitendance/ui/courses/edit_course/prereqs_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditorWidget extends ConsumerWidget {
  late var state;
  PreReqsEditorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final stream = ref.read(currentCourseProvider);
    final stream = ref.read(preReqsProvider);

    return stream.when(
      error: (e, st, data) => Center(child: Text('error encountered \n $e')),
      loading: (data) => const Center(child: CircularProgressIndicator()),
      data: (data) => Center(
        child: Container(
          alignment: Alignment.center,
          // height: 250,
          width: MediaQuery.of(context).size.width * .40,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 25,
            // color: Theme.of(context).primaryColorDark,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Course Pre Requisites',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  // Divider(),
                  Wrap(
                    children: data
                        .map((e) => Container(
                              width: 200,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.white,
                                title: Text(
                                  e!.courseId!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(e.courseTitle!),
                              ),
                            ))
                        .toList(),
                  ),

                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Select course prerequisites'),
                                scrollable: true,
                                content: PreReqsEditorDialog(),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        
                                      },
                                      child: Text('Cancel')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        //TODO restore previous state
                                      },
                                      child: Text(
                                        'DONE',
                                      )),
                                ],
                              )).then((value) => state = value);
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
