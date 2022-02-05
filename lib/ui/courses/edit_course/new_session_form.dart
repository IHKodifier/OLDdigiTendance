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
  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        // width: MediaQuery.of(context).size.width*.65,
        padding: const EdgeInsets.symmetric(horizontal: 256),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Create new Session',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        )),
              ),
              buildId(),
              buildTitle(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildRegStart(context),
                  buildRegEnd(context),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              buildButtonBar(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
        // TextButton(
        //     onPressed: () {},
        //     child: const Text(
        //       'RESET',
        //       style: TextStyle(fontSize: 24),
        //     )),
        // const Spacer(flex: 1),
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

  Widget buildId() => Padding(
        padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(8.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Registration starts on ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 20),
          InkWell(
            child: Text(
              regStartDate != null
                  ? DateFormat.yMMMEd('en-US').format(regStartDate!)
                  : 'Select Date',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
            onTap: () => _datePicker(context),
          ),
        ],
      ),
    );
  }

  Widget buildRegEnd(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Registration Ends on ',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            child: Text(regEndTime?.toString() ?? 'Select Date & Time ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).primaryColor)),
            onTap: () => _timePicker(context),
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

  _timePicker(BuildContext context) async {
    final now = TimeOfDay.now();
    final selectectedTime =
        await showTimePicker(context: context, initialTime: regEndTime ?? now);
    setState(() {
      regEndTime = selectectedTime;
    });
  }
}
