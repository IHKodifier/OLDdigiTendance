import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/models/course.dart';
import '../../../app/models/session.dart';
import '../../../app/providers.dart';
import '../../../app/utilities.dart';
import '../../courses/coursespage.dart';

const double pi = 3.1415926535897932;

final facultyAvailableSessionsProvider =
    FutureProvider<List<Session>>((ref) async {
  var db = ref.read(firestoreProvider);
  var intitutionDocRef = ref.read(institutionProvider);
  List<Session> sessions = [];
  await db
      .collectionGroup('sessions')
      .where('facultyId',
          isEqualTo: ref.read(currentAppUserProvider).value?.email)
      .snapshots()
      .forEach(
    (element) async {
      DocumentReference<Map<String, dynamic>>? parentDocRef =
          element.docs[0].reference.parent.parent;
      String parentCourseId;
      await ref.read(firestoreProvider).doc(parentDocRef!.path).get().then(
        (value) {
          parentCourseId = value.data()!['courseId'];
          Utils.log(' parentCourse Id $parentCourseId');
          Session tempSession = Session.fromDataAndCourseId(
              element.docs[0].data(), parentCourseId);
          tempSession.parentCourseDocRef = element.docs[0].reference;
          Utils.log(
              ' Temp session = ${tempSession.toString()}\n sessions length = ${sessions.length.toString()}');
          sessions.add(tempSession);
        },
      );
    },
  );

  return sessions;
});

final facultyAvailableCoursesProvider =
    FutureProvider<List<Course>>((ref) async {
  List<Course> courses = [];
  AsyncValue<List<Session>> asyncSessions;
  List<Session> sessions;
  asyncSessions = ref.watch(facultyAvailableSessionsProvider);
  List<Session> data(AsyncData<List<Session>> data) {
    return data.value;
  }

  List<Session>? error(AsyncError<List<Session>> data) {
    return data.value;
  }

  List<Session>? loading(AsyncLoading<List<Session>> data) {
    return data.value;
    // return AsyncLoading<data>;
  }

  sessions = asyncSessions.map(data: data, error: error, loading: loading)!;
  Session session;

  for (var element in sessions) {
    await ref
        .read(firestoreApiProvider)
        .instance
        .doc(ref.read(institutionProvider).InstitutionDocRef.path)
        .collection('courses')
        .doc(element.parentCourseDocRef!.path)
        .get()
        .then((results) {
      var course = Course.fromData(results.data()!, results.reference);
      courses.add(course);
    });
  }
  return courses;
});

class TeacherAppHomeOLD extends ConsumerWidget {
  const TeacherAppHomeOLD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final asyncValue = ref.watch(facultyAvailableCoursesProvider);
    return Center(child: TeacherHomeBodyOLD());
  }
}

class BusyShimmer extends StatelessWidget {
  const BusyShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: SizedBox(
        width: 292,
        height: 212,
        child: Container(
          color: const Color.fromARGB(221, 97, 92, 92),
        ),
      ),
      baseColor: const Color.fromARGB(221, 97, 92, 92),
      highlightColor: const Color.fromARGB(131, 255, 255, 255),
    );
  }
}

class TeacherHomeBodyOLD extends ConsumerWidget {
  // List<Course>? data;
  TeacherHomeBodyOLD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facultyTitle = ref.read(currentAppUserProvider).value!.email;
    final asyncData = ref.watch(facultyAvailableCoursesProvider);
    return asyncData.when(loading: () {
      return const BusyShimmer();
    }, error: (Object error, StackTrace? stackTrace) {
      return Center(
        child: Text(error.toString()),
      );
    }, data: (List<Course> data) {
      return SingleChildScrollView(
        child: Scrollbar(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(facultyTitle!,
                    style: Theme.of(context).textTheme.headline2),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Active Courses',
                    style: Theme.of(context).textTheme.headline4),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children:
                      data!.map((course) => ActiveCourseTile(course)).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // notifier.signOut();
                  },
                  child: const Text('Log out ')),
            ],
          ),
        ),
      );
    });
  }
}

class ActiveCourseTile extends ConsumerWidget {
  final Course course;
  const ActiveCourseTile(this.course, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.20,
        margin: const EdgeInsets.all(8),
        height: 220,
        child: InkWell(
          hoverColor: Colors.purple.shade300,
          splashColor: Colors.purple.shade100,
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CoursesPage()));
          },
          child: Card(
            // shape: Bordersh(),
            elevation: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: 3 * pi / 2,
                  child: Container(
                    // height: 80,
                    // width: double.infinity,
                    color: const Color.fromARGB(255, 240, 102, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        course.courseId!,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
