import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsSelectionState extends Equatable {
  late List<Course?>? allCourses;
  final ProviderRefBase ref;
 late  List<Course?>? selectedCourses;
  late List<Course?>? availableCourses;

  PreReqsSelectionState(this.ref) {
    final currentCourse = ref.read(currentCourseProvider);
    final selectedCourses = currentCourse.preReqs;
   
  }


  @override
  // TODO: implement props
  List<Object?> get props => [selectedCourses, availableCourses];
}
