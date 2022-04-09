import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/course_registration.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  late String? sessionId;
  late String? sessionTitle;
  late String parentCourseId;
  late DateTime? registrationStartDate;
  late Timestamp? registrationEndDate;
  late SessionStatus? sessionStatus;
  late DocumentReference sessionDocRef;
  late DocumentReference? parentCourseDocRef;
  late Faculty? faculty;
  late List<CourseRegistration>? courseRegistrations;
  RegistrationStatus get regStatus {
    final now = DateTime.now();
    if (now.isAfter(registrationStartDate!) &&
        now.isBefore(registrationEndDate!.toDate())) {
      return RegistrationStatus.registrationOpened;
    } else {
      return RegistrationStatus.registrationClosed;
    }
  }

  Session(
      {this.sessionId,
      this.sessionTitle,
      this.faculty,
      this.registrationStartDate,
      this.registrationEndDate,
      this.sessionStatus,
      this.courseRegistrations,
      required this.parentCourseId});
  Session.fromDataAndCourseId(
      Map<String, dynamic> data, String parentCourseId) {
    Timestamp timestamp = data['registrationStartDate'];
    this.parentCourseId = parentCourseId;
    registrationStartDate = timestamp.toDate();
    timestamp = data['registrationEndDate'];
    registrationEndDate = timestamp;
    faculty = Faculty(
        // firstName: data['faculty'],
        userId: data['facultyId']);
    sessionId = data['sessionId'];
    sessionTitle = data['sessionTitle'];
  }
  Session.fromDataAndSessionDocRef(
      Map<String, dynamic> data, DocumentReference docRef) {
    Timestamp timestamp = data['registrationStartDate'];
    // this.parentCourseId = parentCourseId;
    registrationStartDate = timestamp.toDate();
    timestamp = data['registrationEndDate'];
    registrationEndDate = timestamp;
    faculty = Faculty(
        // firstName: data['faculty'],
        userId: data['facultyId']);
    sessionId = data['sessionId'];
    sessionTitle = data['sessionTitle'];
    parentCourseDocRef = docRef.parent.parent;
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'faculty': faculty!.userId,
      'registrationStartDate': registrationStartDate,

      'registrationEndDate': registrationEndDate,

      ///todo add all field here
    };
  }

  Session.fromJsonOnly(Map<String, dynamic> data) {
    Timestamp timestamp = data['registrationStartDate'];
    this.parentCourseId = 'Not Set';
    registrationStartDate = timestamp.toDate();
    timestamp = data['registrationEndDate'];
    registrationEndDate = timestamp;
    faculty = Faculty(
        // firstName: data['faculty'],
        userId: data['facultyId']);
    sessionId = data['sessionId'];
    sessionTitle = data['sessionTitle'];
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        sessionId,
        sessionTitle,
        parentCourseId,
        // faculty,
        // registrationStartDate!,
        // registrationEndDate!,
      ];
  @override
  String toString() {
    return '''
  Id:$sessionId,Title: $sessionTitle, Facty: ${faculty!.userId}, parentCourseId: $parentCourseId
  ''';
  }

  Session copyWith({
    String? sessionId,
    String? sessionTitle,
    DateTime? registrationStartDate,
    Timestamp? registrationEndDate,
    SessionStatus? sessionStatus,
    Faculty? faculty,
    List<CourseRegistration>? courseRegistrations,
    String? parentCourseId,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      registrationStartDate:
          registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      faculty: faculty ?? this.faculty,
      courseRegistrations: courseRegistrations ?? this.courseRegistrations,
      parentCourseId: parentCourseId ?? this.parentCourseId,
    );
  }
}

enum RegistrationStatus {
  registrationOpened,
  registrationClosed,
}
enum SessionStatus {
  closed,
  inProgress,
}
