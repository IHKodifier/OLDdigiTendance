import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:digitendance/app/models/course_registration.dart';
import 'package:digitendance/app/models/faculty.dart';

class Session extends Equatable {
  late String? sessionId;
  late String? sessionTitle;
  late DateTime? registrationStartDate;
  late Timestamp? registrationEndDate;
  late SessionStatus? sessionStatus;
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

  Session({
    this.sessionId,
    this.sessionTitle,
    this.faculty,
    this.registrationStartDate,
    this.registrationEndDate,
    this.sessionStatus,
    this.courseRegistrations
  });
  Session.fromData(Map<String, dynamic> data) {
    Timestamp timestamp = data['registrationStartDate'];
    registrationStartDate = timestamp.toDate();
    timestamp = data['registrationEndDate'];
    registrationEndDate = timestamp;
    faculty = Faculty(
        // firstName: data['faculty'],
        userId: data['faculty']);
    sessionId = data['sessionId'];
    sessionTitle = data['sessionTitle'];
  }
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'sessionTitle':sessionTitle,
      'faculty':faculty!.userId,
      'registrationStartDate':registrationStartDate,

      'registrationEndDate': registrationEndDate,
      ///todoadd all field here
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    sessionId,
    sessionTitle,
    // faculty,
    // registrationStartDate!,
    // registrationEndDate!,
  ];
  @override
  String toString() {
    return '''
  Session Id:$sessionId
  Session Title: $sessionTitle
  Faculty: ${faculty!.userId}

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
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      registrationStartDate: registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      faculty: faculty ?? this.faculty,
      courseRegistrations:courseRegistrations ?? this.courseRegistrations,
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
