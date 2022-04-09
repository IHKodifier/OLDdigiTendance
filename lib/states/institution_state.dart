import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Institution extends Equatable {
  late DocumentReference InstitutionDocRef;
  late String? title;
  late String? id;

  Institution();
  // late String address;
  // TODO: implement props
  List<Object?> get props => [this.id, this.title];

  static Institution fromData(
      Map<String, dynamic>? data, DocumentReference docRef) {
    Institution institution = Institution();
    institution.title = data!['title'];
    institution.id = data['id'];
    institution.InstitutionDocRef = docRef;
    return institution;
  }

  @override
  String toString() {
    return '''
    Institution title =$title
    Institution Id = $id
    DocumentReference = 
    Doc Id = ${InstitutionDocRef.id}
    Doc parent  = ${InstitutionDocRef.parent.toString()}
    Doc path =${InstitutionDocRef.path}

    ''';
  }
}
