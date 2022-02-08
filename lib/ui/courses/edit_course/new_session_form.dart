import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/ui/courses/edit_course/faculty_list.dart';
import 'package:digitendance/ui/shared/faculty_avatar.dart';
import 'package:digitendance/ui/shared/spaers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  TimeOfDay? regEndTime;
  String? endDateString = 'Select Date & Time ';
  Faculty? facultySelected;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final facultyList = ref.read(facultyListProvider);
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
              // buildId(),
              // buildTitle(),
              const SpacerVertical(8),
              buildRegDates(context),
              const SpacerVertical(8),
              buildFacultySelectionCard(context),
              buildButtonBar(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Card buildFacultySelectionCard(BuildContext context) {
    /// sir  naveed photo url =
    /// https://media-exp1.licdn.com/dms/image/C4D03AQEz30XNSb3Rvw/profile-displayphoto-shrink_200_200/0/1516899914494?e=1647475200&v=beta&t=ISMZPJwbuxbY5cHXaLhJpLewW9q8A2YmT5uUqjcX5HM
    ///
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(horizontal: 96, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Faculty',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SpacerVertical(4),
          facultySelected!=null
              ? FacultyAvatar(faculty: facultySelected)
              : FacultyAvatarBlank(),
        ],
      ),
    );
  }

  buildTextIputCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 96),
      elevation: 20,
      child: Column(
        children: [buildId(), buildTitle(), const SpacerVertical(16)],
      ),
    );
  }

  Widget buildRegDates(BuildContext context) {
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
          const SpacerVertical(8),
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
            onPressed: () {},
            // icon: const Icon(Icons.cancel),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 24),
            )),
        const Spacer(flex: 1),
        ElevatedButton.icon(
            onPressed: () {},
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

  Widget buildFacultyFormTile() {
    if (facultySelected == null) {
      return InkWell(
        child: const Text('select Faculty'),
        onTap: () {},
      );
    } else {
      return ListTile(
        leading: const Icon(
          Icons.account_circle_outlined,
          size: 40,
          color: Colors.red,
        ),
        title:
            Text(facultySelected!.firstName! + ' ' + facultySelected!.lastName),
      );
    }
  }

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
          onSaved: (newValue) {},
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
          onSaved: (newValue) {},
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
            onTap: () => _datePicker(context),
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

  _datePicker(BuildContext context) async {
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

  _dateAndTimePicker(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: regEndDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
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

  _showSimpleDialog() {
    final list = ref.read(facultyListProvider);
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text('select Faculty'),
              children:
                  list.asData?.value.map((e) => FacultyLisTile(e: e)).toList(),
            ));
  }
}
