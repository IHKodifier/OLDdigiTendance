import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/utilities.dart';

class Course {
  String? courseId;
  String? courseTitle;
  int? credits;
  List<Course>? preReqs = [];
  List<Session?>? sessions = [];

  Course({
    this.courseId,
    this.courseTitle,
    this.credits,
    // ignore: avoid_init_to_null
    this.preReqs = null,
  });
  Course.fromMap(Map<String, dynamic> data) {
    courseId = data['courseId'];
    courseTitle = data['courseTitle'];
    // preReqs = data['preReqs'];
    credits = data['credits'];
    // var x = data['preReqs'];
    // Utilities.log(' preReqs equals {$preReqs.toString()}');
    // preReqs = toList();
  }

  @override
  String toString() {
    return ''' 
    Course ($courseId,$courseTitle,${credits.toString()})
    ''';
  }
}
