import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/notifiers/edit_course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                SessionsListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
            color: Theme.of(context).primaryColorDark,
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
                          .copyWith(color: Colors.white),
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
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  tileColor: Colors.white,
                                  title: Text(e.data()['courseId'],
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(e.data()['courseTitle']),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: data.docs.length,
                  //   itemBuilder: (context, index) {
                  //     return Container(
                  //       margin: EdgeInsets.all(4),
                  //       child: Material(
                  //         // color: Colors.blueAccent,
                  //         elevation: 15,
                  //         child: ListTile(
                  //           title: Text(
                  //             data.docs[index].data()['courseId'],
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyText2!
                  //                 .copyWith(
                  //                     color: Theme.of(context).primaryColor,
                  //                     fontSize: 18),
                  //           ),
                  //           // subtitle: Text(data.docs[index].data()['courseTitle']),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionsListWidget extends ConsumerWidget {
  SessionsListWidget({Key? key}) : super(key: key);
  late List<Session?>? _providedSessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionList = ref.watch(sessionListProvider);
    return sessionList.when(
      data: onData,
      error: onError,
      loading: onLoading,
    );
  }

  Widget onLoading(AsyncValue? data) {
    return Center(child: Container());
  }

  Widget onError(object, StackTrace? st, data) {
    Utilities.log(st.toString());
    return Center(child: Text('error Encountered ${object.toString()}\n $st'));
  }

  Widget onData(data) {
    return Consumer(
      builder: (context, ref, child) {
        _providedSessionList = ref.watch(courseProvider).sessions;

        return Card(
          margin: EdgeInsets.all(8),
          elevation: 5,
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width * .40,
            child: ListView.builder(
              itemCount: _providedSessionList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: Material(
                    elevation: 20,
                    child: ListTile(
                      title: Text(_providedSessionList![index]!.sessionId),
                      subtitle:
                          Text(_providedSessionList![index]!.faculty.userId),
                      trailing:
                          Text(_providedSessionList![index]!.sessionTitle),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
