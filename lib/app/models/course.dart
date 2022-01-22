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
    this.preReqs,
    List<Session?>? sessions,
  });
  Course.fromData(Map<String, dynamic> data) {
    courseId = data['courseId'];
    courseTitle = data['courseTitle'];
    // preReqs = data['preReqs'];
    preReqs = [];
    credits = data['credits'];
    // var x = data['preReqs'];
    // Utilities.log(' preReqs equals {$preReqs.toString()}');
    // preReqs = toList();
  }

  @override
  String toString() {
    return '''courseId: $courseId, courseTitle: $courseTitle Credits: ${credits.toString()}, number of preReqs: ${preReqs!.length}
    number of Sessions: ${sessions!.length}
    PREREQS
     ${preReqs!.map((e) => e.courseId.toString())}

   SESSIONS;;
    ${sessions!.map((e) => e!.sessionTitle)}
    )
    ''';
  }

  Map<String, dynamic> toMap() {
    var _map = {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'credits': credits,
      // preReqs = [],
//  sessions = [],
    };
    return _map;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        courseId,
        courseTitle,
        credits,
        preReqs,
        preReqs!.length,
      ];

  Course copyWith(
      {String? courseId,
      String? courseTitle,
      int? credits,
      List<Course>? preReqs,
      List<Session>? sessions}) {
    return Course(
        courseId: courseId ?? this.courseId,
        courseTitle: courseTitle ?? this.courseTitle,
        credits: credits ?? this.credits,
        preReqs: preReqs ?? this.preReqs,
        sessions: sessions ?? this.sessions);
  }
}
