import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:digitendance/ui/courses/edit_course/new_session_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facultyListProvider = FutureProvider<List<Faculty>>((ref) async {
  DocumentReference institutionDocRef =
      ref.read(institutionProvider).InstitutionDocRef;
  Utils.log(institutionDocRef.path);

  return ref
      .read(firestoreProvider)
      // .collection('instututions')
      .doc(institutionDocRef.path)
      .collection('faculty')
      .get()
      .then((value) => value.docs
          .map((e) => Faculty.fromMap(e.data(), e.reference))
          .toList());

  // final facultyList = ref.read(facu)
});

class FacultyList extends ConsumerWidget {
  FacultyList({Key? key}) : super(key: key);
  late AsyncValue<List<Faculty>> asyncList;
  late BuildContext thisContext;
  late WidgetRef thisRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    thisContext = context;
    thisRef = ref;
    asyncList = ref.watch(facultyListProvider);
    return asyncList.when(data: onData, error: onError, loading: onLoading);
  }

  Widget onData(List<Faculty> data) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: data.map((e) => FacultyLisTile(e: e)).toList(),
      ),
    );
  }

  Widget onError(e, st) {
    return Text(e.toString());
    Utils.log(st.toString());
  }

  Widget onLoading() {
    return const Center(child: CircularProgressIndicator());
  }
}

class FacultyLisTile extends ConsumerWidget {
  const FacultyLisTile({Key? key, required this.e}) : super(key: key);
  final Faculty e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Navigator.pop
    var sessionNotifier = ref.read(newSessionProvider.notifier);
    var session = ref.watch(newSessionProvider);

    return Material(
      child: SimpleDialogOption(
        onPressed: () {
          sessionNotifier.setFaculty(e);
          Utils.log(session.faculty.toString());

          Navigator.pop(context);
        },
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: Text(e.title! + ' ' + e.firstName! + ' '),
              leading: CircleAvatar(child: Image.network(e.photoURL!)),
            ),
          ),
        ),
        padding: const EdgeInsets.all(4),
        // subtitle: Text(e.title!),
      ),
    );
  }
}
