import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
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

  Course editedCourse = Course();
  late final Course unTouchedCourse;
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
      child: SizedBox(
        width: double.infinity,
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  _buildAllTextFields(),
                  _buildSelectedCoursesFlex(removeFromSelected),
                  _buildAvailableCoursesFlex(addToSelection),
                  // PreReqsEditingWidget(),
                  // SessionsEditorWidget(),
                  // buildButtons(),
                  const SizedBox(
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
        const Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: onCancel,
            // icon: const Icon(Icons.cancel),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 24),
            )),
        const Spacer(flex: 1),
        TextButton(
            onPressed: onReset,
            child: const Text(
              'RESET',
              style: TextStyle(fontSize: 24),
            )),
        const Spacer(flex: 1),
        ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save),
            label: const Text(
              'Save',
              style: TextStyle(fontSize: 24),
            )),
        const Spacer(
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
    //TODO.... do the form saving to firestore stuff

    if (formIsModified) {
      editedCourse.docRef = unTouchedCourse.docRef;
      Utils.log(unTouchedCourse.docRef.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'form is M o d i f i e d and courseRef equals ${editedCourse.docRef?.path.toString()}')));
      FirebaseFirestore.instance
          .doc(editedCourse.docRef!.path)
          .set(editedCourse.toMap(), SetOptions(merge: true));
    } else {
      Utils.log('form Does NOT has unsaved Changes');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('form is       N   O   T      Modified')));
    }
  }

  onReset() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.info_outline, size: 60, color: Colors.deepOrange),
                  Text('Warning'),
                ],
              ),
              content: const Text(
                  'All data in the form will bereset to its original .\n Are you sure...?'),
              actions: [
                TextButton(
                  onPressed: resetForm,
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ));
  }

  void resetForm() {
    editedCourse = unTouchedCourse;
    setState(() {});
    Navigator.pop(context);
  }

  onCancel() {
    _formKey.currentState!.validate();
    _formKey.currentState!.save();
    editedCourse.preReqs = selectedCourses;
    if (formIsModified) {
//show alert for unsaved changes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.warning,
                size: 50,
                color: Colors.deepOrange,
              ),
              Text(
                'Proceed With Caution',
                style: TextStyle(fontSize: 26),
              ),
            ],
          ),
          content: const Text(
            'You hve not Saved the edits.  \n Are you sure you want to cancel?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          editedCourse.nullify();
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No')),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      //just clear the state and pop the navigator
      editedCourse.nullify();
      Navigator.pop(context);
    }
  }

  Widget _buildSelectedCoursesFlex(Function action) {
    final PreReqsEditingNotifier notifier =
        ref.read(preReqsEditingProvider.notifier);
    int selectedPreReqsLegth;
    if (editedCourse.preReqs == null) {
      selectedPreReqsLegth = unTouchedCourse.preReqs!.length;
    } else {
      selectedPreReqsLegth = editedCourse.preReqs!.length;
    }

    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Pre Requisites (' +
                  selectedPreReqsLegth.toString() +
                  ')',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  selectedCourses.map((e) => _buildChip(e, action)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCoursesFlex(
    Function action,
  ) {
    return asyncAllCourses!.when(
      error: (
        error,
        stackTrace,
      ) =>
          const Text('error encountered'),
      loading: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text(
            'loading available Courses',
            style: TextStyle(fontSize: 18),
          ),
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
        int availablePreReqsLegth;
        if (editedCourse.preReqs == null) {
          availablePreReqsLegth = unTouchedCourse.preReqs!.length;
        } else {
          availablePreReqsLegth = editedCourse.preReqs!.length;
        }
        return Flexible(
          fit: FlexFit.loose,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pre Requisites Available to add (' +
                      availablePreReqsLegth.toString() +
                      ' available)',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // color: Colors.blueGrey[50],
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: availableCourses
                      .map((e) => _buildChip(e!, action))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(Course e, Function action) {
    return ActionChip(
      elevation: 10,
      labelPadding: const EdgeInsets.all(8),
      backgroundColor: Colors.white,
      avatar: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // minRadius: 200,
        radius: 250,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FittedBox(
            child: Text(
              e.courseId!,
              style: const TextStyle(
                  // fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      label: Text(
        e.courseTitle!,
        style: const TextStyle(fontSize: 18, color: Colors.black54),
      ),
      onPressed: () {
        action(e);
      },
    );
  }

  void removeFromSelected(e) {
    setState(() {
      selectedCourses.remove(e);
      availableCourses.add(e);
    });
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
