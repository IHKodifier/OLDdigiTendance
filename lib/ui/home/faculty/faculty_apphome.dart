import 'dart:js';

import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/ui/home/faculty/_teacher_app_homeOLD%20APProach.dart';
import 'package:digitendance/ui/home/faculty/faculty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/utilities.dart';

class FacultyHomeScreen extends ConsumerWidget {
  const FacultyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(facultyAvailableSessionProvider);

    return sessions.when(
        data: onData,
        error: (error, st) {
          Utils.log(error.toString());
          Utils.log(st.toString());
          return Center(
              child: Text(
            error.toString(),
            style: TextStyle(fontSize: 32),
          ));
        },
        loading: () => Center(child: BusyShimmer()));
  }

  Widget onData(AsyncValue<List<Session>> data) {
    return Center(
      child: ListView.builder(
        itemCount: data.value?.length,
        itemBuilder: ((context, index) => Card(
              elevation: 20,
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(data.value![index].sessionId!),
                subtitle: Text(data.value![index].sessionTitle!),
              ),
            )),
      ),
    );
  }
}
