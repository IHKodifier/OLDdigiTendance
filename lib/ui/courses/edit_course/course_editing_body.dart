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
  late List<Course?> allCourses;
  List<Course?> availableCourses = [];
  List<Course> selectedCourses = [];
  AsyncValue? asyncAllCourses;

  final Course editedCourse = Course();
  late final unTouchedCourse;
  late GlobalKey<FormState> _formKey;
  bool get formIsModified => editedCourse != unTouchedCourse;

  @override
  void initState() {
    super.initState();

    ///TODO do custom initialozation logic below super call
    // state = ref.watch(courseEditingProvider);
    asyncAllCourses = ref.read(allCoursesProvider);
    unTouchedCourse = ref.read(currentCourseProvider).copyWith();
    selectedCourses = ref
        .read(currentCourseProvider)
        .copyWith(preReqs: ref.read(currentCourseProvider).preReqs)
        .preReqs!
        .toList();
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

    initiateTextControllers();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAllTextFields(),
                  _buildSelectedCoursesFlex(removeFromSelected),
                  _buildAvailableCoursesFlex(addToSelection),
                  // PreReqsEditingWidget(),
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
      decoration: const InputDecoration(
        // prefixIcon: Icon(Icons.person),
        icon: Icon(
          Icons.document_scanner_sharp,
          size: 40,
        ),
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
        icon: Icon(
          Icons.title,
          size: 40,
        ),
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
        icon: Icon(
          Icons.note_sharp,
          size: 40,
        ),
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
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    editedCourse.preReqs = selectedCourses;
    // state.newState = state.clone().previousState;
    // localState.newState = localState.previousState!
    //     .copyWith(courseTitle: localState.previousState!.courseTitle);
    // localState.newState!.courseId = courseIdController.text;
    // localState.newState!.courseTitle = courseTitleController.text;
    // localState.newState!.credits = int.parse(courseCreditController.text);
    if (formIsModified) {
      Utils.log('form has unsaved Changes');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text('form is Modified')));
    } else {
      Utils.log('form Does NOT has unsaved Changes');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text('form is NOT Modified')));
    }

    // Utils.log('${formIsModified.toString()}');
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content:
    //         Text('Both state are ${state.isModified ? 'NOT' : ''} equal ')));
    // debugPrint({statement});
  }

  onReset() {}

  onCancel() {}

  Widget _buildSelectedCoursesFlex(Function action) {
    final PreReqsEditingNotifier notifier =
        ref.read(preReqsEditingProvider.notifier);
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: selectedCourses
              .map((e) => _buildChip(e, removeFromSelected))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAvailableCoursesFlex(
    Function action,
  ) {
    return asyncAllCourses!.when(
      error: (error, stackTrace, previous) => const Text('error encountered'),
      loading: (previous) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const Text('loading available Courses'),
        ],
      ),
      data: (data) {
        //TODO purge available courses of thecurrent and selectd courses

        allCourses = data;
        availableCourses.clear();
        Utils.log('cleared available courses');
        availableCourses = allCourses;
        _purgeCurrent();

        var set1 = Set<Course>.from(availableCourses);
        var set2 = Set<Course>.from(selectedCourses);
        var setDiff = set1.difference(set2);
        Utils.log(setDiff.length.toString());
        availableCourses = List.from(setDiff);

        return Flexible(
          fit: FlexFit.loose,
          child: Container(
            padding: EdgeInsets.all(8),
            // color: Colors.blueGrey[50],
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableCourses
                  .map((e) => _buildChip(e!, addToSelection))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(Course e, Function action) {
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
        addToSelection(e);
        // selectedCourses.remove(e);
      },
    );
  }

  void removeFromSelected(e) {
    // state.newState!.preReqs!.remove(e);
    // notifier.removePreReq(e);
    // notifier.addSelectedCourse(e);
    if (!availableCourses.contains(e)) {
      // availableCourses.add(e);
      setState(() {});
    }
  }

  void _purgeCurrent() {
    Utils.log('''
PURGING  ${ref.read(currentCourseProvider).courseId}
from list of available courses i.e.${availableCourses.map((e) => e!.courseId)}...
availableCourses length =${availableCourses.length.toString()} 
         ''');
    availableCourses.removeWhere((course) =>
        course!.courseId == ref.read(currentCourseProvider).courseId);
    Utils.log(''' PURGE CURRENT COMPLETE
    availableCourses new length =${availableCourses.length.toString()} 
    ''');
  }

  void addToSelection(e) {
    setState(() {
      availableCourses.remove(e);
    });
    if (!selectedCourses.contains(e)) {
      selectedCourses.add(e);
    }
  }
}
