import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  // final String name;
  final String userId;
  String? firstName;
  late String? lastName, title, photoURL;
  late DocumentReference? docRef;

  Faculty({this.firstName, required this.userId, this.photoURL, this.docRef});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];

  static Faculty fromMap(Map<String, dynamic> data, DocumentReference docRef) {
    Faculty faculty = Faculty(userId: data['userId']);
    faculty.firstName = data['firstName'];
    faculty.lastName = data['lastName'];
    faculty.photoURL = data['photoURL'];
    faculty.docRef = docRef;
    faculty.title = data['title'] ?? 'NA';
    return faculty;
  }

  @override
  String toString() {
    return '''
    Faculty First Name: $firstName
    Faculty Last Name: $lastName
    User ID: $userId
    phtoURL: $photoURL    
    docRef:${docRef?.path}
     ''';
  }

  Faculty copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? title,
    String? photoURL,
    DocumentReference? docRef,
  }) {
    return Faculty(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      photoURL: photoURL ?? this.photoURL,
      docRef: docRef ?? this.docRef,
    );
  }
}
