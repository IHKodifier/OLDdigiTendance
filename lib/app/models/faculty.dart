import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  final String name;
  final String userId;

  Faculty(this.name, this.userId);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
