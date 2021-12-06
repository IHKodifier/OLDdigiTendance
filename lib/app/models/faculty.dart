import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  // final String name;
  final String userId;
  String? firstName;
  String? lastName, title, photoURL;

  Faculty({ this.firstName, required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
