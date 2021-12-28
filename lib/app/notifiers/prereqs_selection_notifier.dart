import 'package:digitendance/app/models/course.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/prereqs_selection_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreReqsSelectionNotifier
    extends StateNotifier<AsyncValue<PreReqsSelectionState>> {
  final ProviderRefBase ref;
  PreReqsSelectionNotifier(this.ref) : super(const AsyncValue.loading()) {
    // initializePreReqsSelectionState();

    Utilities.log(
      state.whenData((data) => data).value.allCourses!.length.toString(),
    );
    //   Utilities.log(state.asData!.value.selectedCourses.toString());
    //   Utilities.log(state.asData!.value.availableCourses.toString());
  }

  // Future initializePreReqsSelectionState() async {
  //   state = const AsyncValue.loading();
  //   state =   await AsyncValue.

  //     // () async {
  //     // var allAsyncCourses =
  //     //     await ref.read(allCoursesProvider).whenData((value) => value);
  //     // var allCourses = allAsyncCourses.value;
  //     // var selectedCourses = ref.read(currentCourseProvider).preReqs;
  //     // state.whenData((value) => value).value.selectedCourses = selectedCourses;
  //     // state.whenData((value) => value).value.availableCourses =
  //     //     Set.from(allCourses!).difference(Set.from(selectedCourses!))
  //     //         as List<Course?>?;

  //     // return Future.value(state.value);
  //   });
  // }

  //  List<Course>? get allCourses=>state.;
//    List<Course?>? get selectedCourses=>state=await AsyncValue.guard(() => AsyncValue.data(value));
//  List<Course?>? get availableCourses=>state.availableCourses;

  void addSelectedCourse(Course course) {
    state.asData!.value.selectedCourses!.add(course);
    state.asData!.value.availableCourses!.remove(course);
  }

  void removeSelectedCourse(Course course) {
    state.asData!.value.selectedCourses!.remove(course);
    state.asData!.value.availableCourses!.add(course);
  }
}
