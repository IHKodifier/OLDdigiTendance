import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/ui/courses/edit_course/prereqs_editor.dart';
import 'package:digitendance/ui/courses/edit_course/session_editor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        width: MediaQuery.of(context).size.width * .40,
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

                SizedBox(
                  height: 20,
                ),
                PreReqsEditorWidget(),
                SessionsEditorWidget(),

                Divider(),
                SizedBox(height: 10),

                ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.save),
                    label: const Text('Save')),
                SizedBox(height: 10),
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
