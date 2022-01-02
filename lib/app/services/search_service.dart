import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/services/firestore_service.dart';
import 'package:digitendance/app/utilities.dart';

class SearchApi {
  late List<Faculty?> fireList = [];
  late List<Faculty?> localList = [];
  late List<Faculty?> returnList = [];
  late List<Faculty?> retval = [];
  late int ascii;

  // Future<QuerySnapshot<Map<String, dynamic>?>?> searchFireDocsbyName(
  //     {required Future<CollectionReference> collectionReference,
  //     String? fieldName,
  //     required String query}) async {
  //   ascii = query.codeUnitAt(0);
  //   var collection = collectionReference;
  //   collection.then((value) => value
  //       .where(fieldName!, isGreaterThanOrEqualTo: query[0].toUpperCase())
  //       .where(fieldName,
  //           isLessThan: String.fromCharCode(query.codeUnitAt((ascii + 1))))
  //       .get()
  //       .then((value) => value));
  // }

  Future<List<Faculty?>> searchFaculty(String query) async {
    // print('query length equals ${query.length.toString()}');
    return await searchFacultyByLeadingCharacter(query);
     
  }

  Future<List<Faculty?>> searchFacultyByLeadingCharacter(String query) async {
    final FirestoreApi firestoreApi = FirestoreApi();
    // read the query string [0] as Ascii
    String startRange, endRange;
    startRange = query[0];
    startRange = startRange.toUpperCase();
    endRange = String.fromCharCode(startRange.codeUnitAt(0 + 1)).toUpperCase();

    try {
      final results = await firestoreApi.instance
          .collection('faculty')
          .where('firstName', isGreaterThanOrEqualTo: startRange)
          .where('firstName', isLessThan: endRange)
          .get();
      retval = results.docs.map((e) => Faculty.fromMap(e.data())).toList();
    } catch (e) {
      Utils.log(e.toString());
    }
    return retval;
  }

  Future<List<Faculty?>> searchFacultyByEmail(String query) async {
    final FirestoreApi firestoreApi = FirestoreApi();
    // read the query string [0] as Ascii
    ascii = query.codeUnitAt(0);
    try {
      final results = await firestoreApi.instance
          .collection('faculty')
          .where('userId', isGreaterThanOrEqualTo: query[0].toUpperCase())
          .where('userId', isLessThan: String.fromCharCode(ascii + 1))
          .get();
      retval = results.docs.map((e) => Faculty.fromMap(e.data())).toList();
    } catch (e) {
      Utils.log(e.toString());
    }
    return retval;
  }

  List<Faculty?> searchFacultyByNameSubString(String query) {
    String tempquery;
    tempquery = query.toLowerCase();
    tempquery = query.replaceRange(0, 1, query[0].toUpperCase());
    // this._query = _query;

    returnList = [];
    fireList.forEach((faculty) {
      if (faculty!.firstName!.startsWith(tempquery)) {
        // isSearching = true;
        returnList.add(faculty);
      }
    });

    return returnList;
  }

  List<Faculty?> searchFacultyByEmailSubString(String query) {
    String tempquery;
    tempquery = query.toLowerCase();
    tempquery = query.replaceRange(0, 1, query[0].toUpperCase());
    // this._query = _query;

    returnList = [];
    fireList.forEach((faculty) {
      if (faculty!.firstName!.startsWith(tempquery)) {
        // isSearching = true;
        returnList.add(faculty);
      }
    });

    return returnList;
  }
}
