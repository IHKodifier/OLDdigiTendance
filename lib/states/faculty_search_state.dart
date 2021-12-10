import 'package:digitendance/app/models/faculty.dart';
import 'package:equatable/equatable.dart';

class FacultySearchState extends Equatable {
  List<Faculty?> searchResults = <Faculty>[];

  void add(Faculty faculty) {
    searchResults.add(faculty);
  }

  List<Faculty?> get facultyList => searchResults;
  void clear() {
    searchResults.clear();
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
