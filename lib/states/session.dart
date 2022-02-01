import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String id;
  final String title;
  DocumentReference? docRef;
  Session({
    required this.id,
    required this.title,
  });

  Session copyWith({
    String? id,
    String? title,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Session.fromMap(
      Map<String, dynamic> map, DocumentReference documentReference) {
    Session session = Session(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
    );
    session.docRef = documentReference;
    return session;
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source,
          {DocumentReference? documentReference}) =>
      Session.fromMap(json.decode(source), documentReference!);

  @override
  String toString() => 'Session(id: $id, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Session &&
      other.id == id &&
      other.title == title &&
      other.docRef == docRef;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ docRef.hashCode;
}
