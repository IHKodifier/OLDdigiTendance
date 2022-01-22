import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/prereqs_editing_state.dart';
import 'package:digitendance/ui/courses/edit_course/prereqs_editing_widget.dart';
import 'package:digitendance/ui/courses/edit_course/session_editor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseEditingBodyWidget extends ConsumerStatefulWidget {
  const CourseEditingBodyWidget();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourseEditingBodyState();
}

class _CourseEditingBodyState extends ConsumerState<CourseEditingBodyWidget> {
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController courseCreditController = TextEditingController();
  TextEditingController facultyController = TextEditingController();
  late final PreReqsEditingState state;
  late final PreReqsEditingNotifier notifier;
  late final Course editedCourse = Course();
  late final unTouchedCourse ;//ref.read(currentCourseProvider);
  late GlobalKey<FormState> _formKey;
  bool get formIsModified => editedCourse != unTouchedCourse;

  @override
  void initState() {
    super.initState();

    ///TODO do custom initialozation logic below super call
    // state = ref.watch(courseEditingProvider);
    unTouchedCourse = ref.read(currentCourseProvider);
  }

  _buildAllTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIdField(),
        _buildTitleField(),
        _buildCourseCreditsFormField()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _formKey = GlobalKey<FormState>();
    state = ref.read(preReqsEditingProvider);
    // state.newState = state.clone().previousState;
    notifier = ref.read(preReqsEditingProvider.notifier);
    initiateTextControllers();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAllTextFields(),
                  PreReqsEditingWidget(),
                  // SessionsEditorWidget(),
                  // buildButtons(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildButtonBar()
                ],
              )),
        )),
      ),
    );
  }

  _buildIdField() {
    return TextFormField(
      controller: courseIdController,
      // initialValue: state.originalState!.courseId,
      decoration: const InputDecoration(
        // prefixIcon: Icon(Icons.person),
        icon: Icon(Icons.person),
        hintText: 'Unique ID of this course',
        labelText: 'CourseId *',
      ),
      onSaved: (value) {
        editedCourse.courseId = value;
      },
      validator: (String? value) {
        return (value != null && value.contains('@'))
            ? 'Do not use the @ char.'
            : null;
      },
    );
  }

  _buildTitleField() {
    return TextFormField(
      controller: courseTitleController,
      // initialValue: state.originalState!.courseTitle,
      decoration: const InputDecoration(
        icon: Icon(Icons.title),
        hintText: 'Exact Title of The Course',
        labelText: 'Course Tiltle * ',
      ),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        editedCourse.courseTitle = value;
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value != null && value.contains('@'))
            ? 'Do not use the @ char.'
            : null;
      },
    );
  }

  _buildCourseCreditsFormField() {
    return TextFormField(
      controller: courseCreditController,
      // initialValue: state.originalState!.credits.toString(),
      decoration: const InputDecoration(
        icon: Icon(Icons.money),
        hintText: 'Number of Credits',
        labelText: 'Credits *',
      ),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        Utils.log('onSave for CourseCredits');
        editedCourse.credits = int.tryParse(value!);
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value != null && value.contains('@'))
            ? 'Do not use the @ char.'
            : null;
      },
    );
  }

  Widget _buildButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: onCancel,
            // icon: const Icon(Icons.cancel),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 24),
            )),
        Spacer(flex: 1),
        TextButton(
            onPressed: onReset,
            child: const Text(
              'RESET',
              style: TextStyle(fontSize: 24),
            )),
        Spacer(flex: 1),
        ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save),
            label: const Text(
              'Save',
              style: TextStyle(fontSize: 24),
            )),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }

  void initiateTextControllers() {
    Utils.log(
        'Starting Execution of initiateTextControllers of CourseEditingBodyState');

    courseIdController.text = unTouchedCourse.courseId!;
    courseTitleController.text = unTouchedCourse.courseTitle!;
    courseCreditController.text = unTouchedCourse.credits.toString();
    Utils.log(
        'Finished Execution of initiateTextControllers of CourseEditingBodyState');
  }

  onSave() {
    // editedCourse = Course();
    // unTouchedCourse = ref.read(currentCourseProvider);

    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    editedCourse.preReqs = state.newPreReqsState;
    // state.newState = state.clone().previousState;
    // localState.newState = localState.previousState!
    //     .copyWith(courseTitle: localState.previousState!.courseTitle);
    // localState.newState!.courseId = courseIdController.text;
    // localState.newState!.courseTitle = courseTitleController.text;
    // localState.newState!.credits = int.parse(courseCreditController.text);
    if (formIsModified) {
      Utils.log('form has unsaved Changes');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('form has unsaved Changes')));
    } else {
      Utils.log('form Does NOT has unsaved Changes');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('form has NO unsaved Changes')));
    }

    // Utils.log('${formIsModified.toString()}');
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content:
    //         Text('Both state are ${state.isModified ? 'NOT' : ''} equal ')));
    // debugPrint({statement});
  }

  onReset() {}

  onCancel() {}
}
