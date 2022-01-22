
// // import 'package:digitendance/app/models/course.dart';
// // import 'package:digitendance/app/providers.dart';
// // import 'package:digitendance/app/utilities.dart';
// // import 'package:digitendance/states/course_editing_state.dart';
// // import 'package:digitendance/ui/courses/edit_course/prereqs_editing_widget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class CourseEditingBodyWidget extends ConsumerStatefulWidget {
// //   CourseEditingBodyWidget();
// //   @override
// //   ConsumerState<ConsumerStatefulWidget> createState() =>
// //       _CourseEditingBodyState();
// // }

// // class _CourseEditingBodyState extends ConsumerState<CourseEditingBodyWidget> {
// //   TextEditingController courseTitleController = TextEditingController();
// //   TextEditingController courseIdController = TextEditingController();
// //   TextEditingController courseCreditController = TextEditingController();
// //   TextEditingController facultyController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   _buildCourseIdTextField() {
// //     return TextFormField(
// //       controller: courseIdController,
// //       // initialValue: state.originalState!.courseId,
// //       decoration: const InputDecoration(
// //         // prefixIcon: Icon(Icons.person),
// //         icon: Icon(Icons.person),
// //         hintText: 'Unique ID of this course',
// //         labelText: 'CourseId *',
// //       ),
// //       onChanged: (value) {
// //         // This optional block of code can be used to run
// //         .newState!.courseId = value;
// //         // code when the user saves the form.
// //       },
// //       validator: (String? value) {
// //         return (value != null && value.contains('@'))
// //             ? 'Do not use the @ char.'
// //             : null;
// //       },
// //     );
// //   }

// //   _buildCourseTitleTextFormField() {
// //     return TextFormField(
// //       controller: courseTitleController,
// //       // initialValue: state.originalState!.courseTitle,
// //       decoration: const InputDecoration(
// //         icon: Icon(Icons.title),
// //         hintText: 'Exact Title of The Course',
// //         labelText: 'Course Tiltle * ',
// //       ),
// //       onChanged: (String? value) {
// //         // This optional block of code can be used to run
// //         localPreviousState.courseTitle = value;
// //         // code when the user saves the form.
// //       },
// //       validator: (String? value) {
// //         return (value != null && value.contains('@'))
// //             ? 'Do not use the @ char.'
// //             : null;
// //       },
// //     );
// //   }

// //   _buildCourseCreditsFormField() {
// //     return TextFormField(
// //       controller: courseCreditController,
// //       // initialValue: state.originalState!.credits.toString(),
// //       decoration: const InputDecoration(
// //         icon: Icon(Icons.money),
// //         hintText: 'Number of Credits',
// //         labelText: 'Credits *',
// //       ),
// //       onSaved: (String? value) {
// //         // This optional block of code can be used to run
// //         // code when the user saves the form.
// //       },
// //       validator: (String? value) {
// //         return (value != null && value.contains('@'))
// //             ? 'Do not use the @ char.'
// //             : null;
// //       },
// //     );
// //   }

// //   Widget _buildButtons() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Spacer(
// //           flex: 2,
// //         ),
// //         TextButton(
// //             onPressed: onCancel,
// //             // icon: const Icon(Icons.cancel),
// //             child: const Text(
// //               'Cancel',
// //               style: TextStyle(fontSize: 24),
// //             )),
// //         Spacer(flex: 1),
// //         TextButton(
// //             onPressed: onReset,
// //             child: const Text(
// //               'RESET',
// //               style: TextStyle(fontSize: 24),
// //             )),
// //         Spacer(flex: 1),
// //         ElevatedButton.icon(
// //             onPressed: onSave,
// //             icon: const Icon(Icons.save),
// //             label: const Text(
// //               'Save',
// //               style: TextStyle(fontSize: 24),
// //             )),
// //         Spacer(
// //           flex: 2,
// //         ),
// //       ],
// //     );
// //   }

// //   void initiateTextControllers() {
// //     Utils.log(
// //         'Starting Execution of initiateTextControllers of CourseEditingBodyState');

// //     courseIdController.text = localState.previousState!.courseId!;
// //     courseTitleController.text = localState.previousState!.courseTitle!;
// //     courseCreditController.text = localState.previousState!.credits.toString();
// //     Utils.log(
// //         'Finished Execution of initiateTextControllers of CourseEditingBodyState');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     var _formKey = GlobalKey<_CourseEditingBodyState>();

// //     return Container(
// //       width: double.infinity,
// //       child: Padding(
// //         padding: EdgeInsets.all(8.0),
// //         child: Scrollbar(
// //           child: SingleChildScrollView(
// //             child: Form(
// //               key: _formKey,
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   _buildAllTextFormFields(),
// //                   PreReqsEditingWidget(),
// //                   Text(
// //                       'Both state are ${localState.isModified ? 'Absolutely' : 'NOT '} Equal'),
// //                   _buildButtons(),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   onSave() {
// //     // localState.newState = localState.previousState!
// //     //     .copyWith(courseTitle: localState.previousState!.courseTitle);
// //     // localState.newState!.courseId = courseIdController.text;
// //     // localState.newState!.courseTitle = courseTitleController.text;
// //     // localState.newState!.credits = int.parse(courseCreditController.text);

// //     Utils.log(
// //         'Are both states equal ? = ${(localState.newState == localState.previousState).toString()}');
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content:
// //             Text('Both state are ${state.isModified ? 'NOT' : ''} equal ')));
// //     // debugPrint({statement});
// //   }

// //   onReset() {}

// //   onCancel() {}
// //   Widget _buildAllTextFormFields() {
// //     return Column(children: [
// //       _buildCourseIdTextField(),
// //       _buildCourseTitleTextFormField(),
// //       _buildCourseCreditsFormField()
// //     ]);
// //   }
// // }


// //***************************************************************************************************************************************************************************************************************************************** */

// import 'package:digitendance/app/models/course.dart';
// import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
// import 'package:digitendance/app/providers.dart';
// import 'package:digitendance/app/utilities.dart';
// import 'package:digitendance/states/prereqs_editing_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PreReqsEditingWidget extends ConsumerStatefulWidget {
//   PreReqsEditingWidget({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _PreReqsEditingWidgetState();
//   // void resetSelection() {}
// }

// class _PreReqsEditingWidgetState extends ConsumerState<PreReqsEditingWidget> {
//   @override
//   // TODO: implement ref
//   WidgetRef get ref => super.ref;

//   List<Course?>? allCourses;
//   List<Course>? selectedCourses;
//   List<Course?> availableCourses = [];
//   AsyncValue? asyncData;
//   late final PreReqsEditingState state;

//   @override
//   void initState() {
//     super.initState();
//     state.previousState!.preReqs = ref.read(currentCourseProvider).preReqs;
//     state.newState!.preReqs = state.previousState!.preReqs;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final state = ref.watch(courseEditingProvider);
//     asyncData = ref.watch(allCoursesProvider);

//     return asyncData!.when(
//       error: (e, st, data) {
//         throw Exception(e);
//       },
//       loading: (data) {
//         return Center(child: CircularProgressIndicator());
//       },
//       data: onData,
//     );
//   }

//   Widget onData(dynamic data) {
//     // originalState = ref.read(currentCourseProvider);
//     allCourses = data;
//     selectedCourses = state.newState!.preReqs;
//     final courseEditingNotifier = ref.read(courseEditingProvider.notifier);
//     availableCourses.clear();
//     Utils.log('cleared available courses');
//     allCourses!.forEach((element) {
//       if (!selectedCourses!.contains(element) &
//           (element != state.previousState)) {
//         Utils.log('adding ${element!.courseId} to available courses');
//         availableCourses.add(element);
//       }
//     });
//     return Card(
//       elevation: 15,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Course Pre Requisites',
//               style: Theme.of(context).textTheme.headline5!.copyWith(
//                   color: Theme.of(context).primaryColor,
//                   fontWeight: FontWeight.w300),
//             ),
//           ),
//           Text(
//             'PreRequisites added to this course',
//             style:
//                 Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
//           ),
//           _buildSelectedCoursesFlex(removeFromSelected),
//           SizedBox(height: 25),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               // color: Colors.blueGrey[50],
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'available courses',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   _buildAvailableCoursesFlex(addToSelection),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Flexible _buildSelectedCoursesFlex(Function action) {
//     final notifier = ref.read(courseEditingProvider.notifier);
//     return Flexible(
//       fit: FlexFit.loose,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         child: Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: selectedCourses!
//               .map((e) => _buildActionChip(e, notifier, removeFromSelected))
//               .toList(),
//         ),
//       ),
//     );
//   }

//   void addToSelection(e, notifier) {
//     selectedCourses!.remove(e);
//     notifier.addSelectedCourse(e);
//     if (!availableCourses.contains(e)) {
//       availableCourses.add(e);
//     }
//   }

//   void removeFromSelected(e, notifier) {
//     selectedCourses!.remove(e);
//     notifier.addSelectedCourse(e);
//     if (!availableCourses.contains(e)) {
//       availableCourses.add(e);
//     }
//   }

//   Widget _buildActionChip(
//       Course e, PreReqsEditingNotifier notifier, Function action) {
//     return ActionChip(
//       elevation: 10,
//       labelPadding: EdgeInsets.all(8),
//       backgroundColor: Colors.white,
//       avatar: CircleAvatar(
//         backgroundColor: Theme.of(context).accentColor,
//         // minRadius: 200,
//         radius: 250,
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: FittedBox(
//             child: Text(
//               e.courseId!,
//               style: TextStyle(
//                   // fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//       label: Text(
//         e.courseTitle!,
//         style: TextStyle(fontSize: 18, color: Colors.black54),
//       ),
//       onPressed: () {
//         setState(() {
//           // addToSelection(e, notifier);
//           action(e, notifier);
//           // selectedCourses!.remove(e);
//           // notifier.addSelectedCourse(e);
//           // if (!availableCourses.contains(e)) {
//           //   availableCourses.add(e);
//         });
//       },
//     );
//   }

//   Flexible _buildAvailableCoursesFlex(
//     Function action,
//   ) {
//     final notifier = ref.read(courseEditingProvider.notifier);

//     return Flexible(
//       fit: FlexFit.loose,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         // color: Colors.blueGrey[50],
//         child: Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: availableCourses
//               .map((e) => _buildActionChip(e!, notifier, action))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
