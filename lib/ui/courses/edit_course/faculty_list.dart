import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facultyListProvider = FutureProvider<List<Faculty>>((ref) async {
  final institutionDocRef = ref.read(InstitutionProvider).docRef;
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
  late AsyncValue<List<Faculty>> list;
  late BuildContext thisContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    thisContext = context;
    list = ref.watch(facultyListProvider);
    return list.when(data: onData, error: onError, loading: onLoading);
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

class FacultyLisTile extends StatelessWidget {
  const FacultyLisTile({Key? key, required this.e}) : super(key: key);
  final Faculty e;

  @override
  Widget build(BuildContext context) {
    // Navigator.pop
    return Material(
      child: SimpleDialogOption(
        child: Text(e.title + ' ' + e.firstName! + ' ' + e.lastName),
        padding: const EdgeInsets.all(8),
        // subtitle: Text(e.title!),
      ),
    );
  }
}
