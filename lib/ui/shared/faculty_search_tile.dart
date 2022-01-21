import 'package:digitendance/app/models/faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacultySearchListTile extends ConsumerWidget {
  final Faculty faculty;
  const FacultySearchListTile({required this.faculty, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 300,
      height: 150,
      child: ListTile(
        leading: const Icon(
          Icons.account_circle_rounded,
          size: 65,
        ),
        title: Text(faculty.firstName! + ' ' + faculty.lastName!),
        subtitle: Text(faculty.userId),
      ),
    );
  }
}
