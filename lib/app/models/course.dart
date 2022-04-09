import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/session.dart';
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  late DocumentReference? courseDocRef;
  late DocumentReference<Map<String, dynamic>> parentInstitutionDocRef;
  String? courseId;
  String? courseTitle;
  int? credits;
  List<Course>? preReqs = [];
  List<Session>? sessions = [];

  Course({
    this.courseId,
    this.courseTitle,
    this.credits,
    this.preReqs,
    List<Session>? sessions,
    this.courseDocRef,
  });
  Course.fromData(Map<String, dynamic> data, [DocumentReference? docRef]) {
    courseId = data['courseId'];
    courseTitle = data['courseTitle'];
    // preReqs = data['preReqs'];
    courseDocRef = docRef;
    parentInstitutionDocRef = courseDocRef!.parent.parent!;
    preReqs = [];
    credits = data['credits'];
    // var x = data['preReqs'];
    // Utilities.log(' preReqs equals {$preReqs.toString()}');
    // preReqs = toList();
  }

  @override
  String toString() {
    return '''courseId: $courseId, courseTitle: $courseTitle Credits: ${credits.toString()}, number of preReqs: ${preReqs!.length}
    Course DocumentReference = 
    Doc Id = ${courseDocRef?.id}
    Doc parent  = ${courseDocRef?.parent.toString()}
    Course Doc path =${courseDocRef?.path}
    Parent Institution  Doc path =${parentInstitutionDocRef.path}
    number of Sessions: ${sessions!.length}
    PREREQS
     ${preReqs!.map((e) => e.courseId.toString())}

   SESSIONS;;
    ${sessions!.map((e) => e.sessionTitle)}
    )
    ''';
  }

  void nullify() {
    courseId = '';
    courseTitle = '';
    credits = null;
    preReqs = [];
    sessions = [];
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
        preReqs!,
        preReqs!.length,
        // sessions,
        sessions?.length,
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
        courseDocRef: courseDocRef ?? courseDocRef,
        sessions: sessions ?? this.sessions);
  }
}
