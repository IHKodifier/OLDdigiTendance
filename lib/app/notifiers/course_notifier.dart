import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseNotifier extends StateNotifier<Course> {
  final StateNotifierProviderRef<CourseNotifier, Course> ref;
  CourseNotifier(state, this.ref) : super(state);
  DocumentReference? get docRef => state.docRef;

  // void setPreReqsonCourse(QuerySnapshot<Map<String, dynamic>> data) {
  //   data.docs.forEach((element) {
  //     state.preReqs!.add(Course.fromData(element.data()));
  //     Utils.log(
  //         'added ${element.data().toString()} to selected Course\'s preREQs ');
  //   });
  // }

  void setSessiononCourseProvider(QuerySnapshot<Map<String, dynamic>> data) {
    state.sessions!.clear();
    for (var element in data.docs) {
      // Utilities.log(element.data().toString());

      state.sessions!.add(Session.fromData(element.data()));

      Utils.log(
          'ADDED  ${element.data()['sessionId'] + element.data()['faculty']} to selected Course\'s SESSIONS ');
    }
  }

  // void removePreReq(Course courseElement) {
  //   final newState = state.copyWith();
  //   if (newState.preReqs!.isNotEmpty) {
  //     if (newState.preReqs!.contains(courseElement)) {
  //       newState.preReqs!.remove(courseElement);
  //     }
  //     state = newState;
  //   }
  // }
}

class CourseEditingNotifier extends StateNotifier<Course> {
  final StateNotifierProviderRef<CourseEditingNotifier, Course> ref;
  CourseEditingNotifier(state, this.ref) : super(state);
  DocumentReference? get docRef => state.docRef;

  // void setSessionOnCourseEditingProvider(
  //     QuerySnapshot<Map<String, dynamic>> data) {
  //   state.sessions!.clear();
  //   for (var element in data.docs) {
  //     // Utilities.log(element.data().toString());

  //     state.sessions!.add(Session.fromData(element.data()));

  //     Utils.log(
  //         'ADDED  ${element.data()['sessionId'] + element.data()['faculty']} to selected Course\'s SESSIONS ');
  //   }
  // }

  Course cloneFrom(Course source) => source.copyWith();
  void setCourseEditingState(Course source) {
    state = source;
  }

  void nullify() {
    state = state.copyWith();
    state.courseId = '';
    state.courseTitle = '';
    state.credits = 0;
    state.docRef = null;
    state.preReqs = [];
    state.sessions = [];
      }
}
