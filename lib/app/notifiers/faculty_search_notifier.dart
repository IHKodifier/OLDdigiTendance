import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacultySearchNotifier extends StateNotifier<List<Faculty?>> {
  FacultySearchNotifier(state, this.ref) : super(state);
  final ProviderRefBase ref;

  void searchFaculty(String? query) {
    final course = ref.watch(courseProvider);
    var searchApi = SearchApi();
    Future<CollectionReference> collectionReference = FirestoreApi()
        .instance
        .collection('courses')
        .where(course.courseId!)
        .get()
        .then((value) => value.docs[0].reference.collection('faculty'));

     searchApi
        .searchFireDocsbyName(
            collectionReference: collectionReference, query: query!)
        .then((value) => value!.docs.forEach((element) {
              state.add(Faculty.fromMap(element.data()!));
            }));
    
  }




}
