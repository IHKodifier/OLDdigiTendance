import 'package:equatable/equatable.dart';

class CourseRegistration extends Equatable {
  final String studentId;
  final DateTime registrationDate;

  CourseRegistration(this.studentId, this.registrationDate);
  // final
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
