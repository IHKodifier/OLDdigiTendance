import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsViewerWidget extends ConsumerWidget {
  SessionsViewerWidget({Key? key}) : super(key: key);
  late List<Session?>? _providedSessionList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionList = ref.watch(sessionListProvider);
    return sessionList.when(
      data: onData,
      error: onError,
      loading: onLoading,
    );
  }

  Widget onLoading(AsyncValue? data) {
    return Center(child: Container());
  }

  Widget onError(object, StackTrace? st, data) {
    Utilities.log(st.toString());
    return Center(child: Text('error Encountered ${object.toString()}\n $st'));
  }

  Widget onData(data) {
    return Consumer(
      builder: (context, ref, child) {
        _providedSessionList = ref.watch(courseProvider).sessions;

        return Card(
          margin: EdgeInsets.all(8),
           shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Sessions',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Container(
                // height: 220,
                width: MediaQuery.of(context).size.width * .40,
                child: Wrap(
                  children: _providedSessionList!
                      .map((e) => Card(
                         shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                        child: Container(
                         
                              width: 150,
                              height: 92,
                              margin: EdgeInsets.all(8),
                              child: ListTile(
                                // tileColor: Theme.of(context).primaryColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                title: Text(
                                  e!.sessionId,
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                subtitle: Text(
                                  e.sessionTitle,
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                      ))
                      .toList(),
                ),
              ),
              SizedBox(height: 15,),
            ],
          ),
        );
      },
    );
  }
}
