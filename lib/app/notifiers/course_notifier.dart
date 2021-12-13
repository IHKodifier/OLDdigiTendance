import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseNotifier extends StateNotifier<Course> {
  final ProviderRefBase ref;
  CourseNotifier(state, this.ref) : super(state);

  void setPreReqsonCourse(QuerySnapshot<Map<String, dynamic>> data) {
    data.docs.forEach((element) {
      state.preReqs!.add(Course.fromData(element.data()));
      Utilities.log(
          'added ${element.data().toString()} to selected Course\'s preREQs ');
    });
  }

  void setSessiononCourseProvider(QuerySnapshot<Map<String, dynamic>> data) {
    state.sessions!.clear();
    data.docs.forEach((element) {
      // Utilities.log(element.data().toString());

      state.sessions!.add(Session.fromData(element.data()));

      Utilities.log(
          'ADDED  ${element.data()['sessionId'] + element.data()['faculty']} to selected Course\'s SESSIONS ');
    });
  }

  void removePreReq(Course courseElement) {
    final newState = state.copyWith();
    if (newState.preReqs!.isNotEmpty) {
      if (newState.preReqs!.contains(courseElement)) {
        newState.preReqs!.remove(courseElement);
      }
      state = newState;
    }
  }
}
/// just another commit to come out pf remote push cancelled syndro