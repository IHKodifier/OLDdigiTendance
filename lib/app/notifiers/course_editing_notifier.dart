import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/states/course_editing_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseEditingStateNotifier extends StateNotifier<CourseEditingState> {
  final ProviderRefBase ref;
  CourseEditingStateNotifier(this.ref, State)
      : super(CourseEditingState(State));

  Course? get newState => state.newState;
  Course? get previousState => state.previousState;
  bool get isModified => state.isModified;
  bool get isNotModified => state.isNotModified;

  void addSelectedCourse(Course course) {
    newState!.preReqs!.add(course);
  }

  void setNewState(Course course) {
    state.newState = course;
  }

  void addPreReq(Course course) {
    state.newState?.preReqs?.add(course);
  }

  void removePreReq(Course course) {
    state.newState?.preReqs?.remove(course);
  }

}
