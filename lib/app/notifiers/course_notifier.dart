import 'package:digitendance/app/models/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseNotifier extends StateNotifier<Course> {
  final ProviderRefBase ref;
  CourseNotifier(state, this.ref) : super(state);
}
