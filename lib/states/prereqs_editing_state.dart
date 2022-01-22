import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsEditingState extends Equatable {
  late List<Course> previousPreReqsState;
  late List<Course> newPreReqsState=[];

  PreReqsEditingState({required this.previousPreReqsState});

  @override
  // TODO: implement props
  List<Object?> get props => [newPreReqsState];
  bool get isModified => (previousPreReqsState != newPreReqsState);
  // bool get isNotModified => !isModified;

  PreReqsEditingState copy() {
    return PreReqsEditingState(previousPreReqsState: previousPreReqsState);
  }
}
