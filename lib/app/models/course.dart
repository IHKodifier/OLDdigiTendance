class Course {
  final String courseId;
  final String courseTitle;
  final int credits;

  Course(
      {required this.courseId,
      required this.courseTitle,
      required this.credits});
  Course.fromMap(Map<String, dynamic> data) :
  courseId=data['courseId'],
  courseTitle=data['courseTitle'],
  credits=data['credits'];


  

  @override
  String toString() {
    return ''' 
    Course ($courseId,$courseTitle,${credits.toString()})
    ''';
  }
}
