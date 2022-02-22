import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/edit_course/new_session_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsEditorWidget extends ConsumerWidget {
  SessionsEditorWidget({Key? key}) : super(key: key);
  late BuildContext thisContext;

  late List<Session?>? _providedSessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    thisContext = context;
    final newSessions = ref.watch(newSessionProvider);
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
    var newSessionFAB = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: thisContext,
            builder: (_) => const Dialog(
              elevation: 15,
              insetAnimationDuration: Duration(milliseconds: 999),
              insetAnimationCurve: Curves.easeIn,
              child: NewSessionForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
    return Consumer(
      builder: (context, ref, child) {
        _providedSessionList = ref.watch(currentCourseProvider).sessions;
        var newSessionNotifier = ref.watch(newSessionProvider.notifier);
        var newSession = ref.read(newSessionProvider);
        var courseEditingNotifier = ref.read(courseEditingProvider.notifier);
        List<Widget> sessionsListWrap = [];
        sessionsListWrap.insert(0, newSessionFAB);
// if (newSession.sessionId!=null) {
//   sessionsListWrap.insert(1, SessionCard(e: newSession));
// }



        
        for (var item in _providedSessionList!) {
          sessionsListWrap.add(SessionCard(e: item!));
        }

        /// if [newSessionProvider] is not null, add it to the session Wrap widget
        /// at index 1 so it is always after add Button

        if (newSessionNotifier.state.sessionId != null) {
          sessionsListWrap.insert(1, SessionCard(e: newSessionNotifier.state));
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
                  crossAxisAlignment: WrapCrossAlignment.center,
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
        side: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
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
            e.sessionId!,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(
            e.sessionTitle!,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
