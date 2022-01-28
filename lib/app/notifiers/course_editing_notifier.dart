import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/states/prereqs_editing_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditingNotifier extends StateNotifier<PreReqsEditingState> {
   var ref;
  
  PreReqsEditingNotifier(this.ref, state)
      : super(PreReqsEditingState(
        previousPreReqsState: state,
        ));

  List<Course?>? get newPreqsState => state.newPreReqsState;
  List<Course?>? get actualPreReqsState => ref.read(currentCourseProvider).preReqs;
  bool get isModified => newPreqsState!=actualPreReqsState;
  bool get isNotModified => !isModified;

  // void addSelectedCourse(Course course) {
  //   newPreqsState!.add(course);
  // }

  // void setNewState(Course course) {
  //   state.newState = course;
  // }

  void addPreReq(Course course) {
    newPreqsState!.add(course);
  }

  void removePreReq(Course course) {
    newPreqsState!.remove(course);
  }

}
