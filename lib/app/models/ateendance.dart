class Attendance {
  final String userId;
  final bool isPresent = false;
  final DateTime date;

  Attendance(this.userId, this.date);
  @override
  String toString() {
    if (isPresent) {
      return 'user $userId is marked PRESENT on ${date.toIso8601String()}';
    } else {
      return 'user $userId is marked ABSENT on ${date.toIso8601String()}';
    }
  }
}
