import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/course_editing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditingWidget extends ConsumerStatefulWidget {
  PreReqsEditingWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreReqsEditingWidgetState();
  // void resetSelection() {}
}

class _PreReqsEditingWidgetState extends ConsumerState<PreReqsEditingWidget> {
  @override
  // TODO: implement ref
  WidgetRef get ref => super.ref;

  late List<Course?> allCourses;
  // List<Course>? selectedCourses;
  List<Course?> availableCourses = [];
  AsyncValue? asyncData;
  late CourseEditingState state;

  @override
  void initState() {
    super.initState();
    state = ref.read(courseEditingProvider);
    asyncData = ref.read(allCoursesProvider);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

  void _purgeCurrent() {
    Utils.log(
        '''PURGING CURRENT course of ${ref.read(currentCourseProvider).courseId}
    from available courses [[[${availableCourses.map((e) => e!.courseId)}]]]
        availableCourses length =${availableCourses.length.toString()} 
         to purge ${ref.read(currentCourseProvider).courseId}
         ''');
    availableCourses.remove(ref.read(currentCourseProvider));
    Utils.log(''' PURGE CURRENT COMPLETE
    availableCourses new length =${availableCourses.length.toString()} 
    ''');
  }

  // void _purgeSelected() {
  //   Utils.log('''PURGING SELECTED
  //       availableCourses length =${availableCourses.length.toString()}
  //       .... starting to purge..... ''');
  //   availableCourses.forEach((course) {
  //     Utils.log('''
  //     checking ${course!.courseId} in selected Courses....found = ${state.newState!.preReqs!.contains(course).toString()}
  //     and will be purged...
  //     ''');
  //     if (availableCourses.contains(course)) {
  //       Utils.log('deleted ${course.courseId}');
  //     }
  //   });
  // }

  Widget onData(dynamic data) {
    state = ref.read(courseEditingProvider);
    allCourses = data;
    availableCourses.clear();
    Utils.log('cleared available courses');

    availableCourses = allCourses;
    _purgeCurrent();

    var set1 = Set.from(availableCourses);
    var set2 = Set.from(state.previousState!.preReqs!);
    var setDiff = set1.difference(set2);
    Utils.log(setDiff.length.toString());
    availableCourses = List.from(setDiff);

    return Card(
      elevation: 15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Course Pre Requisites',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Text(
            'PreRequisites added to this course \(${state.previousState!.preReqs!.length.toString()}\)',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
          ),
          _buildSelectedCoursesFlex(removeFromSelected),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // color: Colors.blueGrey[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'available courses \(${availableCourses.length.toString()})',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  _buildAvailableCoursesFlex(addToSelection),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Flexible _buildSelectedCoursesFlex(Function action) {
    final CourseEditingStateNotifier notifier =
        ref.read(courseEditingProvider.notifier);
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.previousState!.preReqs!
              .map((e) => _buildActionChip(e, notifier, removeFromSelected))
              .toList(),
        ),
      ),
    );
  }

  void addToSelection(e, CourseEditingStateNotifier notifier) {
    setState(() {
      availableCourses.remove(e);
    });
    if (!state.newState!.preReqs!.contains(e)) {
      notifier.addPreReq(e);
    }
  }

  void removeFromSelected(e, CourseEditingStateNotifier notifier) {
    // state.newState!.preReqs!.remove(e);
    notifier.removePreReq(e);
    // notifier.addSelectedCourse(e);
    if (!availableCourses.contains(e)) {
      // availableCourses.add(e);
      setState(() {});
    }
  }

  Widget _buildActionChip(
      Course e, CourseEditingStateNotifier notifier, Function action) {
    return ActionChip(
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
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
      onPressed: () {
        setState(() {
          // addToSelection(e, notifier);
          action(e, notifier);
          // selectedCourses!.remove(e);
          // notifier.addSelectedCourse(e);
          // if (!availableCourses.contains(e)) {
          //   availableCourses.add(e);
        });
      },
    );
  }

  Flexible _buildAvailableCoursesFlex(
    Function action,
  ) {
    final notifier = ref.read(courseEditingProvider.notifier);

    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.all(8),
        // color: Colors.blueGrey[50],
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableCourses
              .map((e) => _buildActionChip(e!, notifier, addToSelection))
              .toList(),
        ),
      ),
    );
  }
}
