import 'package:digitendance/app/models/course_registration.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  late final String sessionId;
 late  final String sessionTitle;
  late final DateTime? registrationStartDate;
  late final DateTime? registrationEndDate;
  late final SessionStatus? sessionStatus;
  late final Faculty faculty;
  late List<CourseRegistration> courseRegistrations;

  RegistrationStatus get regStatus {
    final now = DateTime.now();
    if (now.isAfter(registrationStartDate!) &&
        now.isBefore(registrationEndDate!)) {
      return RegistrationStatus.registrationOpened;
    } else {
      return RegistrationStatus.registrationClosed;
    }
  }

  Session({
    required this.sessionId,
    required this.sessionTitle,
    required this.faculty,
    this.registrationStartDate,
    this.registrationEndDate,
    this.sessionStatus,
  });
  Session.fromData(Map<String, dynamic> data) {
    registrationStartDate = data['registrationStartDate'];
    registrationEndDate = data['registrationEndDate'];
    faculty = data['faculty'];
    sessionId = data['sessionId'];

  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

enum RegistrationStatus {
  registrationOpened,
  registrationClosed,
}
enum SessionStatus {
  closed,
  inProgress,
}
