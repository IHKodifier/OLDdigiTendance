import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseDetailPage extends ConsumerWidget {
  const CourseDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Course course = ref.watch(courseProvider);
    final notifier = ref.watch(courseProvider.notifier);
    String courseTitle = course.courseId ?? 'New Course';
    // course.courseId = 'new course';

    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
        centerTitle: true,
      ),
      body: _CourseDetailBody(
        course: course,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Edit Course',
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Colors.white,
                // fontFamily: Goog¿,
                fontSize: 28,
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
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course.courseTitle!,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${course.credits!} credits',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            PreReqsList(),
            SessionsListWidget(),
          ],
        ),
      ),
    );
  }
}

class PreReqsList extends ConsumerWidget {
  const PreReqsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(preReqsProvider);

    return stream.when(
      error: (e, st, data) => Center(child: Text('error encountered \n $e')),
      loading: (data) => const Center(child: CircularProgressIndicator()),
      data: (data) => Center(
        child: Container(
          alignment: Alignment.center,
          height: 250,
          width: 400,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Material(
                elevation: 15,
                child: ListTile(
                  title: Text(data[index].data()['courseId']),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SessionsListWidget extends ConsumerWidget {
  const SessionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionList = ref.watch(sessionListProvider);
    return sessionList.when(data: onData, error: onError, loading: onLoading);
  }

  Widget onLoading(AsyncValue? data) {
    return Center(child: Container());
  }

  Widget onError(object, StackTrace? st, AsyncData<dynamic>? data) {
    return Center(child: Text('error Encountered ${object.toString()}'));
  }

  Widget onData(dynamic data) {
    return Center(child: Text(data.toString()));
  }
}
