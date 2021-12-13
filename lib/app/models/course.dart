import 'package:digitendance/app/models/session.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:equatable/equatable.dart';

class Course extends Equatable {
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
    this.preReqs = null, List<Session?>? sessions,
  });
  Course.fromData(Map<String, dynamic> data) {
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
    Printing Course====courseId: $courseId, courseTitle: $courseTitle
    Credits ${credits.toString()}, number of preReqs: ${preReqs!.length}
    ${preReqs!.map((e) => e.toString())}

   number of Sessions: ${sessions!.length} ${sessions!.map((e) => e.toString())}
    )
    ''';
  }

  Map<String, dynamic> toMap() {
    var _map = {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'credits': credits,
//   preReqs = [];
//  sessions = [];
    };
    return _map;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [courseId, courseTitle, preReqs, sessions];

  Course copyWith(
      {String? courseId,
      String? courseTitle,
      int? credits,
      List<Course>? preReqs,
      List<Session>? sessions}) {
    return Course(
      courseId: courseId?? this.courseId,
      courseTitle: courseTitle?? this.courseTitle,
      credits: credits?? this.credits,
      preReqs: preReqs ?? this.preReqs,
      sessions: sessions?? this.sessions

    );
  }
}
