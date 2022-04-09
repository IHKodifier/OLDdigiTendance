import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/search_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/faculty_search_state.dart';
import 'package:digitendance/ui/shared/faculty_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewCourse extends ConsumerWidget {
  const NewCourse({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Course state = Course(
      courseId: '',
      courseTitle: '',
      credits: 0,
      preReqs: [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New Course: ${state.courseTitle}'),
      ),
      body: NewCourseBody(state),
      // Center(child: Text(state.toString(),
    );
  }
}

class NewCourseBody extends ConsumerStatefulWidget {
  final Course course;

  NewCourseBody(this.course);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCourseBodyState(course);
}

class _NewCourseBodyState extends ConsumerState<NewCourseBody> {
  final Course course;
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController courseCreditController = TextEditingController();
  TextEditingController facultyController = TextEditingController();
  SearchApi searchService = SearchApi();

  _NewCourseBodyState(this.course);
// @override
// void initState() {
//     // TODO: implement initState
//     courseTitleController.text = '';
//     courseIdController.text = ;
//     courseCreditController.text =
//         course!.credits == 0 ? '' : course.credits.toString();
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<_NewCourseBodyState>();

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .55,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///[CourseId] Form  Field
                TextFormField(
                  controller: courseIdController,
                  decoration: const InputDecoration(
                    // prefixIcon: Icon(Icons.person),
                    icon: Icon(Icons.person),
                    hintText: 'Unique ID of this course',
                    labelText: 'CourseId *',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),

                ///[courseTitle FormField]
                TextFormField(
                  controller: courseTitleController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Exact Title of The Course',
                    labelText: 'Course Tiltle * ',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),

                ///[courseCredits] Form Field
                TextFormField(
                  controller: courseCreditController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.money),
                    hintText: 'Number of Credits',
                    labelText: 'Credits *',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),

                ///[facutyId] Form Field
                TypeAheadField<Faculty?>(
                  // minCharsForSuggestions: 3,
                  // controller: facultyController,
                  suggestionsCallback: suggestionsCallback,
                  itemBuilder: (context, faculty) =>
                      FacultySearchListTile(faculty: faculty!),

                  onSuggestionSelected: facultySuggestionSelected,
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 18),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.book),
                      hintText: 'Faculty email',
                      labelText: 'Faculty *',
                    ),
                  ),
                  // onSaved: (String? value) {
                  //   // This optional block of code can be used to run
                  //   // code when the user saves the form.
                  // },
                  // validator: (String? value) {
                  //   return (value != null && value.contains('@'))
                  //       ? 'Do not use the @ char.'
                  //       : null;
                  // },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.save),
                    label: const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureOr<Iterable<Faculty?>> suggestionsCallback(String query) async {
    ///capitalize query for easy range selection
    String capitlizedQuery = '';
    if (query.isNotEmpty) {
      for (var i = 0; i < query.length; i++) {
        if (i == 0) {
          capitlizedQuery += query[i].toUpperCase();
        } else {
          capitlizedQuery += query[i];
        }
      }
    }

    final searchNotfier = ref.watch(facultySearchProvider.notifier);

     searchNotfier.searchFaculty(capitlizedQuery).then((value) =>searchNotfier.state.facultyList);

    return searchNotfier.state.facultyList;
  }

  facultySuggestionSelected(Faculty? faculty) {
    Utils.log('${faculty.toString()} has been selected from search');
    // course.
  }

  onPressed() {
    course.courseId = courseIdController.text;
    course.courseTitle = courseTitleController.text;
    course.credits = int.parse(courseCreditController.text);
    course.preReqs = [
      Course(
          courseId: 'Agroo Id',
          courseTitle: 'Bagroo CourseTitle',
          credits: 199),
    ];
    course.sessions = [
      Session(
          sessionId: 'sessionId99',
          parentCourseId: ref.read(currentCourseProvider).courseId!,
          sessionTitle: 'SessionTtile 99',
          faculty: Faculty(userId: 'faculty 99@qw.com'))
    ];

    ref.read(firestoreApiProvider).addNewCourse(course).then((value) =>
        ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
            content: Text(
                'New Course with Course ID  ${course.courseId} ]] has been Successsfully Saved'))));
  }
}
