import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseEditingState extends Equatable {
  final Course? previousState;
  Course? newState;
  // final ProviderRefBase  ref;
  CourseEditingState([this.previousState]) {
    newState = previousState;
  }
  // static CourseEditingState cloneFrom(CourseEditingState oldState) {
  //   var tempNewState = CourseEditingState();
  //   tempNewState.previousState = oldState.previousState;
  //   return tempNewState;
  // }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [previousState, newState, previousState!.preReqs, newState?.preReqs];
  bool get isModified => (previousState != newState);
  bool get isNotModified => !isModified;

  CourseEditingState clone() {
    CourseEditingState temp = CourseEditingState(previousState);
    temp.newState = this.newState;
    return temp;
  }
}
