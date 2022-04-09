import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/date_time_extention.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/edit_course/faculty_list.dart';
import 'package:digitendance/ui/shared/spaers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final newSessionProvider =
    StateNotifierProvider<SessionNotifier, Session>((ref) {
  return SessionNotifier(Session(parentCourseId: ref.read(currentCourseProvider).courseId!));
});

class SessionNotifier extends StateNotifier<Session> {
  SessionNotifier(state) : super(state);
  void setSession(Session session) {
    state = session.copyWith();
  }

  void setFaculty(Faculty value) {
    state.faculty = value;
    state = state.copyWith();
  }

  void nullify() {
    // dispose();
  }
}

class NewSessionForm extends ConsumerStatefulWidget {
  const NewSessionForm({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<NewSessionForm> {
  late final TextEditingController titleController;
  late final TextEditingController idController;
  late final _formKey = GlobalKey<FormState>();
  DateTime? regStartDate;
  DateTime? regEndDate;
  DateTime? sessionStartDate;
  DateTime? sessionEndDate;
  TimeOfDay? regEndTime;
  Session? newSession;
  SessionNotifier? newSessionNotifier;
  String? endDateString = 'Select Date & Time ';
  // String sessio
  Faculty? facultySelected;
  List<bool> tutoringDays = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final facultyList = ref.read(facultyListProvider);
    newSessionNotifier = ref.read(newSessionProvider.notifier);
    newSession = ref.watch(newSessionProvider);
    facultySelected = newSession?.faculty;
    return Container(
      width: MediaQuery.of(context).size.width * .65,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildFormTitle(context),
              buildTextIputCard(),

              const SpacerVertical(4),

              buildRegDates(context),
              const SpacerVertical(4),

              /// widget to display Faculty
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 20,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 96, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        newSession?.faculty?.userId == null
                            ? FacultyPicker()
                            : const FacultySelected()
                      ],
                    ),
                  ),
                ),
              ),
              const SpacerVertical(16),
              buildSessionCalendarCard(context),
              buildButtonBar(context),
              // const SizedBox(height: 20),
              const SpacerVertical(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSessionCalendarCard(BuildContext context) {
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(horizontal: 96, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Session Calendar ',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          // const SpacerVertical(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildSessionStart(context)),
              Expanded(child: buildSessionEnd(context)),
              const SpacerVertical(4),
            ],
          ),
          const SpacerVertical(8),
          buildWeekdayChoices(),
          const SpacerVertical(8),
        ],
      ),
    );
  }

  buildWeekdayChoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Tutoring Calendar'),
        ),
        Wrap(
          spacing: 16,
          children: [
            ChoiceChip(
              padding: const EdgeInsets.all(4),
              selectedColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.7),
              pressElevation: 15,
              label: const Text('M'),
              selected: tutoringDays[0],
              onSelected: (value) {
                tutoringDays[0] = value;
                setState(() {});
              },
            ),
            ChoiceChip(
              padding: const EdgeInsets.all(8),
              selectedColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.7),
              pressElevation: 15,
              label: const Text('T'),
              selected: tutoringDays[1],
              onSelected: (value) {
                tutoringDays[1] = value;
                setState(() {});
              },
            ),
            ChoiceChip(
              padding: const EdgeInsets.all(8),
              selectedColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.7),
              pressElevation: 15,
              label: const Text('W'),
              selected: tutoringDays[2],
              onSelected: (value) {
                tutoringDays[2] = value;
                setState(() {});
              },
            ),
            ChoiceChip(
              padding: const EdgeInsets.all(8),
              selectedColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.7),
              pressElevation: 15,
              label: const Text('T'),
              selected: tutoringDays[3],
              onSelected: (value) {
                tutoringDays[3] = value;
                Utils.log(tutoringDays.toString());
                setState(() {});
              },
            ),
            ChoiceChip(
              padding: const EdgeInsets.all(8),
              selectedColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(.7),
              pressElevation: 15,
              label: const Text('F'),
              selected: tutoringDays[4],
              onSelected: (value) {
                tutoringDays[4] = value;
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTextIputCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 96),
      elevation: 20,
      child: Column(
        children: [buildId(), buildTitle(), const SpacerVertical(16)],
      ),
    );
  }

  Widget buildRegDates(BuildContext context) {
    // facultySelected = ref.watch(newSessionProvider).faculty;
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(horizontal: 96, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Registration ',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          // const SpacerVertical(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildRegStart(context)),
              Expanded(child: buildRegEnd(context)),
              // const SpacerVertical(8),
            ],
          ),
          const SpacerVertical(16),
          // buildFacultySelectionCard(context),
        ],
      ),
    );
  }

  Padding buildFormTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Create new Session',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).primaryColorDark,
              )),
    );
  }

  buildButtonBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(
          flex: 2,
        ),
        TextButton(
            onPressed: (() => Navigator.pop(context)),
            // icon: const Icon(Icons.cancel),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 20),
              ),
            )),
        const Spacer(flex: 1),
        ElevatedButton.icon(
            onPressed: onCreateSession,
            icon: const Icon(Icons.save),
            label: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Create Session  ',
                style: TextStyle(fontSize: 20),
              ),
            )),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  onCreateSession() {
    newSession = Session(parentCourseId: ref.read(currentCourseProvider).courseId!);
    final notifier = ref.read(newSessionProvider.notifier);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      newSession?.parentCourseId = ref.read(currentCourseProvider).courseId!;
      newSession!.registrationStartDate = regStartDate;
      newSession!.registrationEndDate = Timestamp.fromDate(
        DateTime(regEndDate!.year).join(date: regEndDate!, time: regEndTime!),
      );
      newSession!.faculty = ref.read(newSessionProvider).faculty;
      // Utils.log(newSession.toString());
      // ref
      //     .read(firestoreProvider).doc(ref.read(currentCourseProvider).docRef!.path).collection('sessions')
      //   //   .collection('institutions')
      //   //   .doc(ref.read(InstitutionProvider).docRef.path)
      //   //   .collection('courses')
      //   //   .doc(ref.read(currentCourseProvider).docRef!.path)
      //   //   .collection('sessions')
      //     .add(newSession!.toMap())
      //     .then((value) {
      // }
      notifier.setSession(newSession!);
      var notif = ref.read(courseEditingProvider.notifier);
      notif.state.sessions!.add(newSession!);
      Utils.log(
          'New Session Added \n printing from Provider ${ref.read(newSessionProvider).toString()}');
      // ref.read(newSessionProvider)=

      Navigator.pop(context);

      // )
    } else {}
  }

  // buildBlankFaculty() {
  //   return SizedBox(
  //     width: 400,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: InkWell(
  //         onTap: _showSimpleDialog,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: const [
  //             Text('Select Faculty'),
  //             Icon(
  //               Icons.account_circle,
  //               size: 80,

  //               color: Color.fromARGB(255, 117, 118, 119),
  //               // child: const Center(child: Text('select Faculty')),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget buildFacultyFormTile() {
  //   if (facultySelected == null) {
  //     return InkWell(
  //       child: const Text('select Faculty'),
  //       onTap: () {},
  //     );
  //   } else {
  //     return ListTile(
  //       leading: const Icon(
  //         Icons.account_circle_outlined,
  //         size: 40,
  //         color: Colors.red,
  //       ),
  //       title:
  //           Text(facultySelected!.firstName! + ' ' + facultySelected!.lastName),
  //     );
  //   }
  // }

  Widget buildId() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Please enter a Session Id',
            label: Text('session Id'),
          ),
          controller: idController,
          onSaved: (newValue) {
            Utils.log('Saving Session Id');
            newSession!.sessionId = newValue;
          },
        ),
      );

  Widget buildTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Please enter a Session Title',
            label: Text('session Title'),
          ),
          controller: titleController,
          onSaved: (newValue) {
            Utils.log('Saving Session Title');
            newSession!.sessionTitle = newValue;
          },
        ),
      );

  Widget buildRegStart(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            ' starts on ',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          // const SizedBox(width: 20),
          const SpacerVertical(8),
          InkWell(
            child: regStartDate != null
                ? Text(
                    regStartDate != null
                        ? DateFormat.yMMMEd('en-US').format(regStartDate!)
                        : 'Select Date',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  )
                : const Icon(Icons.calendar_today_outlined),
            onTap: () => _datePicker_Registration(context),
          ),
        ],
      ),
    );
  }

  Widget buildRegEnd(BuildContext context) {
    //  endDate==null?

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            ' Ends on ',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SpacerVertical(8),
          InkWell(
            child: regStartDate != null
                ? Text(endDateString!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).primaryColor))
                : const Icon(Icons.calendar_today_rounded),
            onTap: () => _dateAndTimePicker(context),
          ),
        ],
      ),
    );
  }

  Widget buildSessionStart(BuildContext context) {
    return Container(
      child: Card(
        // color: const Color.fromARGB(137, 172, 166, 166),
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              ' starts on ',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            // const SizedBox(width: 20),
            const SpacerVertical(8),
            InkWell(
              child: sessionStartDate != null
                  ? Text(
                      regStartDate != null
                          ? DateFormat.yMMMEd('en-US').format(sessionStartDate!)
                          : 'Select Date',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    )
                  : const Icon(Icons.calendar_today_outlined),
              onTap: () => _datePicker_SessionStart(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSessionEnd(BuildContext context) {
    //  endDate==null?

    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            ' Ends on ',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SpacerVertical(8),
          InkWell(
            child: sessionEndDate != null
                ? Text(DateFormat.yMMMEd('en-US').format(sessionEndDate!),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).primaryColor))
                : const Icon(Icons.calendar_today_rounded),
            onTap: () => _datePicker_SessionEnd(context),
          ),
        ],
      ),
    );
  }

  _datePicker_Registration(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: regStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    setState(() {
      regStartDate = newDate;
    });
  }

  _datePicker_SessionStart(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: regStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        sessionStartDate = newDate;
      });
    } else {
      return;
    }
  }

  _datePicker_SessionEnd(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: regStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        sessionEndDate = newDate;
      });
    } else {
      return;
    }
  }

  _dateAndTimePicker(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: regEndDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    // TimeOfDay
    final now = TimeOfDay.now();
    final selectectedTime = await showTimePicker(
      context: context,
      initialTime: regEndTime ?? now,
    );
    setState(() {
      regEndDate = newDate;
      if (regEndDate == null) {
        endDateString = null;
      } else {
        endDateString = DateFormat.yMMMEd('en-US').format(regEndDate!);
      }
      regEndTime = selectectedTime;

      String temp = regEndTime!.format(context);
      endDateString = endDateString! + ' --  ' + temp;
    });
  }

  // _showSimpleDialog() {
  //   final list = ref.read(facultyListProvider);
  //   showDialog(
  //       context: context,
  //       builder: (context) => SimpleDialog(
  //             title: const Text('select Faculty'),
  //             children:
  //                 list.asData?.value.map((e) => FacultyLisTile(e: e)).toList(),
  //           ));

}

class FacultyPicker extends ConsumerWidget {
  FacultyPicker({Key? key}) : super(key: key);
  late AsyncValue<List<Faculty>> asyncList;
  late BuildContext thisContext;
  late WidgetRef thisRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    asyncList = ref.watch(facultyListProvider);
    thisContext = context;
    thisRef = ref;

    return asyncList.when(
        error: (e, st) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
        data: (data) => InkWell(
              child: const Tooltip(
                message: 'Click to Select Faculty',
                child: CircleAvatar(
                  child: Icon(
                    Icons.account_circle,
                    size: 80,
                  ),
                  radius: 41,
                ),
              ),
              onTap: () => pickFaculty(context, ref),
            ));
  }

  pickFaculty(BuildContext context, WidgetRef ref) {
    asyncList.when(
      data: (List<Faculty> data) {
        final notifier = ref.read(newSessionProvider.notifier);
        showDialog(
          context: thisContext,
          builder: (context) => SimpleDialog(
              title: const Text('select Faculty'),
              children: data.map((e) => FacultyLisTile(e: e)).toList()),
        );
      },
      error: (e, st) => [Text(e.toString())],
      loading: () => [
        const CircularProgressIndicator(),
      ],
    );
  }
}

class FacultySelected extends ConsumerWidget {
  const FacultySelected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faculty = ref.watch(newSessionProvider).faculty;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: ClipOval(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(faculty!.photoURL!, fit: BoxFit.fill),
                  )),
              // radius: 50,
            ),
            onTap: () {
              var asyncList = ref.read(facultyListProvider);
              asyncList.when(
                data: (List<Faculty> data) {
                  final notifier = ref.read(newSessionProvider.notifier);
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                        title: const Text('select Faculty'),
                        children:
                            data.map((e) => FacultyLisTile(e: e)).toList()),
                  );
                },
                error: (e, st) => [Text(e.toString())],
                loading: () => [
                  const CircularProgressIndicator(),
                ],
              );
            },
          ),
          const SpacerVertical(4),
          Text(
            faculty.title! + faculty.firstName! + faculty.lastName!,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
