import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/models/session.dart';

final facultyAvailableSessionProvider =
    FutureProvider<AsyncValue<List<Session>>>((ref) async {
  Utils.log(ref.runtimeType.toString());
  return await ref.read(firestoreApiProvider).getSessionsForFaculty(ref);
});


// class FacultyStateNotifier extends StateNotifier<Future<AsyncValue<List<Session>>>> {
//   final ref;
//   AsyncValue<List<Session>>? sessions;
//   AsyncValue<List<Session>>? previousState;

//   FacultyStateNotifier(
//     this.ref, [
//     AsyncValue<List<Session>>? sessions,
//   ]) : super(sessions ?? Future<const AsyncValue.loading()) {
//     state = ref.read(firestoreApiProvider).getSessionsForFaculty(ref);
//   }
// }
