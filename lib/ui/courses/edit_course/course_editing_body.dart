import 'package:collection/collection.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/notifiers/course_editing_notifier.dart';
import 'package:digitendance/app/notifiers/course_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/coursespage.dart';
import 'package:digitendance/ui/courses/edit_course/new_session_form.dart';
import 'package:digitendance/ui/courses/edit_course/session_editor_widget.dart';
import 'package:digitendance/ui/shared/spaers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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
  late CourseEditingNotifier courseEditingNotifier;
  late GlobalKey<FormState> _formKey;
  bool get formIsModified => editedCourse != unTouchedCourse;
  bool get hasNewSession =>
      (editedCourse.sessions!.length > unTouchedCourse.sessions!.length);
  bool get formNeedsSaving =>
      formIsModified || hasNewSession || hasModifiedPreReqs;
  DeepCollectionEquality equality = const DeepCollectionEquality();
  bool get hasModifiedPreReqs =>
      !equality.equals(editedCourse.preReqs, unTouchedCourse.preReqs);

  @override
  void initState() {
    super.initState();

    ///TODO do custom initialozation logic below super call
    // state = ref.watch(courseEditingProvider);
    asyncAllCourses = ref.read(allCoursesProvider);
    unTouchedCourse = ref.read(currentCourseProvider);
    selectedCourses = ref
        .read(currentCourseProvider)
        .copyWith(preReqs: ref.read(currentCourseProvider).preReqs)
        .preReqs!
        .toList();
    editedCourse = ref.read(courseEditingProvider);
    courseEditingNotifier = ref.read(courseEditingProvider.notifier);
    editedCourse = courseEditingNotifier.cloneFrom(unTouchedCourse);
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
    final newSession = ref.watch(newSessionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
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
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) =>
                            SessionsEditorWidget(),
                  ),
                  // buildButtons(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildButtonBar(),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              )),
        ),
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
    final updateNotifier = ref.read(courseUpdateStatusProvider.notifier);

    ///validate TexFields before saving
    _formKey.currentState!.validate();

    ///prep [editedCourse] for saving
    courseEditingNotifier.setCourseEditingState(editedCourse);
    _formKey.currentState!.save();
    editedCourse.preReqs = selectedCourses;
    //add existing sessions to [editedCourse]
    editedCourse.sessions = ref
        .read(sessionListProvider)
        .value!
        .docs
        .map((e) => Session.fromData(e.data()))
        .toList();

    ///if new sessions are added  add them to editedcourse
    if (ref.read(newSessionProvider).faculty != null) {
      editedCourse.sessions!.insert(0, ref.read(newSessionProvider));
    }

    /// [editedCourse] has been prepped for Saving
    /// now save to firestore
    if (formNeedsSaving) {
      ///prep the [courseUpdateStatusProvider]
      var subtasks = ref.read(courseUpdateStatusProvider).microtasks;
      for (var task in subtasks!) {
        task.isBusy = true;
      }

      /// check if the form has new sessions have been created in the edited course
      /// if there are new sessions, first write the seessin docs to edited course
      if (hasNewSession) {
        _addNewSessionInFirestore();
      } else {
        //  no new sessions to write to firestore
      }

      ///TODO
      ///check if preReqs have changed. if preReqs have changed
      if (hasModifiedPreReqs) {
        ///find the newly added PreReqs, write the preReqs Doc in
        ///the editedCourse's firebase doc
        ///
        ///
        ///
        ///TODO
        ///find the preReqs that have been removed from the course in this
        /// edit and delete those prrReqs docs from editedCourses's firestore doc
        ///

        ///upDate [courseUpdateStatus]
      } else {
        ///did not have modified PreReqs, update the courseUpdateStatus
        updateNotifier.markCompleted(updateNotifier.state.microtasks![0]);
      }

      /// make sure the [CourseUpdateStatusProvider] is updated

      if (formIsModified) {
        ///update the course Fields in Firebase Course Doc
        ///
        _updateCourseInFirestore();
      } else {
        // updateNotifier.markCompleted(updateNotifier.state.microtasks![2]);

      }
      updateNotifier.markCompleted(updateNotifier.state.microtasks![2]);

      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      var state = ref.watch(courseUpdateStatusProvider);
                      var microtaskrows = state.microtasks!
                          .map((e) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e.title),
                                    e.isBusy
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                )),
                                          )
                                        : const Icon(Icons.done)
                                  ]))
                          .toList();
                      return SizedBox(
                        width: 600,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'updating course',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            const SpacerVertical(4),
                            microtaskrows[0],
                            const SpacerVertical(4),
                            microtaskrows[1],
                            const SpacerVertical(4),
                            microtaskrows[2],
                            ref
                                    .read(courseUpdateStatusProvider.notifier)
                                    .overallProgress
                                ? Container()
                                : Lottie.network(
                                    'https://assets3.lottiefiles.com/private_files/lf30_nrnx3s.json',
                                    repeat: false,
                                    animate: true,
                                    height: 180,
                                    width: 180),
                            ElevatedButton(
                                onPressed: () {
                                  //pop twice
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                  // final courseList = ref.read(allCoursesProvider.);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const CoursesPage()));
                                  // Navigator.pop(context);
                                },
                                child: const Text('Continue')),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form Does not need saving')));
      Utils.log('form does not need saving');
      ref.read(courseEditingProvider.notifier).nullify();
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
              'Pre Requisites (' + selectedPreReqsLegth.toString() + ')',
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

  void _updateCourseInFirestore() {
    Utils.log('Updating Course in Firestore');
    //check if preReqs have changed since form load
    print(
        ' PreReqsEquality is ${const ListEquality().equals(editedCourse.preReqs, unTouchedCourse.preReqs)}');
    // if (editedCourse.preReqs.l{
  }

  Future<void> _addNewSessionInFirestore() async {
    Utils.log('adding sessions in Firestore');
    var notifier = ref.read(courseUpdateStatusProvider.notifier);
    var progressState = ref.watch(courseUpdateStatusProvider);

    for (var session in editedCourse.sessions!) {
      if (unTouchedCourse.sessions!.contains(session)) {
        //do not add in firestore

      } else {
        //write this new session to firestore
        ref
            .read(firestoreApiProvider)
            .addSessionToCourse(session, editedCourse.docRef)
            .then((value) {
          notifier.markCompleted(
              ref.read(courseUpdateStatusProvider).microtasks![1]);
          ref.refresh(newSessionProvider);
        });
      }
    }
  }
}

final courseUpdateStatusProvider =
    StateNotifierProvider<CourseUpdateProgressNotifier, UpdateProgressState>(
        (ref) {
  return CourseUpdateProgressNotifier();
});

class CourseUpdateProgressNotifier extends StateNotifier<UpdateProgressState> {
  CourseUpdateProgressNotifier([state])
      : super(state ??
            UpdateProgressState(microtasks: [
              UpdateTask(title: 'updating PreReqs', isBusy: true),
              UpdateTask(title: 'updatingSessions', isBusy: true),
              UpdateTask(title: 'updating Course', isBusy: true),
            ]));

  bool get overallProgress =>
      state.microtasks![0].isBusy ||
      state.microtasks![1].isBusy ||
      state.microtasks![2].isBusy;
  bool get preReqsProgress => state.microtasks![1].isBusy;
  bool get sessionProgress => state.microtasks![2].isBusy;
  void markCompleted(UpdateTask task) {
    state = state.copyWith();
    for (var item in state.microtasks!) {
      if (item == task) {
        item.isBusy = false;
      }
    }
  }

  void markInProgress(UpdateTask task) {
    task.isBusy = false;
  }
}

class UpdateProgressState {
  List<UpdateTask>? microtasks = [
    UpdateTask(title: 'updating PreReqs', isBusy: true),
    UpdateTask(title: 'updatingSessions', isBusy: true),
    UpdateTask(title: 'updating Course', isBusy: true),
  ];

  UpdateProgressState({
    this.microtasks,
  });

  UpdateProgressState copyWith({
    List<UpdateTask>? microtasks,
  }) {
    return UpdateProgressState(
      microtasks: microtasks ?? this.microtasks,
    );
  }
}

class UpdateTask extends Equatable {
  final String title;
  bool isBusy;

  UpdateTask({required this.title, this.isBusy = true});

  @override
  // TODO: implement props
  List<Object?> get props => [title];
}
