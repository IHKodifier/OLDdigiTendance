// ignore_for_file: file_names

import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsViewerWidget extends ConsumerWidget {
  const PreReqsViewerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(preReqsProvider);

    return stream.when(
      error: (e, st, data) => Center(child: Text('error encountered \n $e')),
      loading: (data) => const Center(child: CircularProgressIndicator()),
      data: (data) => Center(
        child: Container(
          alignment: Alignment.center,
          // height: 250,
          width: MediaQuery.of(context).size.width * .40,
          child: Card(
            elevation: 25,
            // color: Theme.of(context).primaryColorDark,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
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
                    children: data.docs
                        .map((e) => Container(
                              width: 200,
                              child: Container(
                                margin: EdgeInsets.all(4),
                                child: ListTile(
                                 shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(
                                    e.data()['courseId'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(e.data()['courseTitle']),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  // Li
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
