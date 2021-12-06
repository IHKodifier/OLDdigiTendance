import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCourse extends ConsumerWidget {
  const EditCourse({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(courseProvider.notifier);
    final state = notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course "${state.courseTitle}"'),
      ),
      body: EditCourseBody(state),
      // Center(child: Text(state.toString(),
    );
  }
}

class EditCourseBody extends ConsumerStatefulWidget {
  final course;

  EditCourseBody(this.course);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCourseBodyState(course);
}

class _EditCourseBodyState extends ConsumerState<EditCourseBody> {
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController courseCreditController = TextEditingController();
  TextEditingController facultyController = TextEditingController();

  _EditCourseBodyState(this.course);
  // final bool isEditMode;
  @override
  // TODO: implement ref
  WidgetRef get ref => super.ref;

  final Course course;

  @override
  void initState() {
    // TODO: implement initState
    courseTitleController.text = course.courseTitle!;
    courseIdController.text = course.courseId!;
    courseCreditController.text =
        course!.credits == 0 ? '' : course.credits.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<_EditCourseBodyState>();

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .55,
        child: Form(
          key: _formKey,
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
                TextFormField(
                  controller: facultyController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.book),
                    hintText: 'Faculty email',
                    labelText: 'Faculty *',
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

  onPressed() {
   
      // course.courseId = courseIdController.text;
      // course.courseTitle = courseTitleController.text;
      // course.credits = int.parse(courseCreditController.text);
      // course.preReqs = [Course(courseId: 'Agroo Id',
      // courseTitle: 'Bagroo CourseTitle',
      // credits: 199),
      // ];
      // course.sessions = [Session(sessionId: 'sessionId99', sessionTitle: 'SessionTtile 99', faculty: Faculty(userId: 'faculty 99@qw.com'))];

      // ref.read(firestoreApiProvider).addNewCourse(course);
    
  }
}
