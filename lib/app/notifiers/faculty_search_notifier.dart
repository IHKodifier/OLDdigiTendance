import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/services/search_service.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/states/faculty_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacultySearchNotifier extends StateNotifier<FacultySearchState> {
  FacultySearchNotifier(FacultySearchState state, this.ref) : super(state);
  final ProviderRefBase ref;

  Future<void> searchFaculty(String queryString) async {
    final course = ref.watch(courseProvider);
    switch (queryString.length) {
      case 0:
        state.clear();
        break;
      case 1:

        ///do firestore search
        state.clear;
        _firestoreSearch(queryString);
        break;
      case 2:
        //do local search
        break;
      default:
      //do local search
    }
  }

  Future<void> _firestoreSearch(String queryString) async {
    String start, end;
    start = queryString;
    int ascii;

    int nextAscii;
    ascii = start.codeUnitAt(0);
    nextAscii = ascii + 1;
    end = String.fromCharCode(nextAscii);
    Utilities.log('''  
  performing Firestore Search for Faculty with $queryString
  start string = $start  end string = $end
  Ascii of start string = ${ascii.toString()} Ascii of end string = ${(nextAscii).toString()}  
 
  
  ''');

    await FirestoreApi()
        .instance
        .collection('faculty')
        .where('firstName', isGreaterThanOrEqualTo: start)
        .where('firstName', isLessThan: end)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        state.add(Faculty.fromMap(element.data()));
      });
    });
  }
}
