// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/ui/courses/edit_course/faculty_list.dart';
import 'package:digitendance/ui/courses/edit_course/new_session_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class FacultySelectionWidget extends ConsumerStatefulWidget {
  const FacultySelectionWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FacultySelectionWidgetState();
}

class _FacultySelectionWidgetState
    extends ConsumerState<FacultySelectionWidget> {
  late Session newSession;

  @override
  Widget build(BuildContext context) {
    newSession = ref.watch(newSessionProvider);
    return Center(
      child: newSession == null
          ? Container(
              color: Colors.yellow,
              height: 100,
              width: 100,
            )
          : Text(
              newSession.toString(),
            ),
    );
  }
}
