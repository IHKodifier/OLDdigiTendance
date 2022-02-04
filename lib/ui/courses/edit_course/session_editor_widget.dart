import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsEditorWidget extends ConsumerWidget {
  SessionsEditorWidget({Key? key}) : super(key: key);
  late BuildContext thisContext;

  late List<Session?>? _providedSessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    thisContext = context;
    final sessionList = ref.watch(sessionListProvider);
    return sessionList.when(
      data: onData,
      error: onError,
      loading: onLoading,
    );
  }

  Widget onLoading() {
    return Center(child: Container());
  }

  Widget onError(
    object,
    StackTrace? st,
  ) {
    Utils.log(st.toString());
    return Center(child: Text('error Encountered ${object.toString()}\n $st'));
  }

  Widget onData(data) {
    var element = Card(
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: thisContext, builder: (_) => NewSessionForm());
        },
        child: const Icon(Icons.add),
      ),
    );
    return Consumer(
      builder: (context, ref, child) {
        _providedSessionList = ref.watch(currentCourseProvider).sessions;
        List<Widget> sessionsListWrap = [];
        sessionsListWrap.insert(0, element);
        for (var item in _providedSessionList!) {
          sessionsListWrap.add(SessionCard(e: item!));
        }

        // _providedSessionList!.map((e) => SessionCard(e: e!)).toList();

        // sessionsListWrap.insert(0, element);.

        return Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'Sessions',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 220,
                width: MediaQuery.of(context).size.width * .40,
                child: Wrap(
                  children: sessionsListWrap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NewSessionForm extends HookWidget {
  NewSessionForm({Key? key}) : super(key: key);

  late final titleHook = useTextEditingController();
  late final idHook = useTextEditingController();
  late final _formKey = GlobalKey<FormState>();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      child: Container(
        // width: MediaQuery.of(context).size.width*.65,
        padding: const EdgeInsets.symmetric(horizontal: 256),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildId(),
              // buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildId() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Please enter a Session Id',
            label: Text('session Id'),
          ),
          controller: idHook,
          onSaved: (newValue) {},
        ),
  );
}

class SessionCard extends StatelessWidget {
  final Session e;
  const SessionCard({
    Key? key,
    required this.e,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 150,
        height: 92,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          // tileColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          title: Text(
            e.sessionId,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(
            e.sessionTitle,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
