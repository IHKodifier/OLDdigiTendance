import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/states/institution_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InstitutionNotifier extends StateNotifier<Institution> {
  final StateNotifierProviderRef<InstitutionNotifier, Institution> ref;
  // late final DocRef;
  InstitutionNotifier(state, this.ref) : super(state);
  DocumentReference get courseDocRef => state.InstitutionDocRef;
  // DocumentReference get docRef => state.InstitutionDocRef;
  setInstitution(value) {
    state = value;
  }
  // String
}
