import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  // final String name;
  final String userId;
  String? firstName;
  String? lastName, title, photoURL;

  Faculty({this.firstName, required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  static Faculty fromMap(Map<String, dynamic> data) {
    Faculty faculty = Faculty(userId: data['userId']);
    faculty.firstName = data['firstName'];
    faculty.lastName = data['lastName'] ?? 'NA';
    faculty.photoURL = data['photoURL']??'NA';
    return faculty;
  }
}
