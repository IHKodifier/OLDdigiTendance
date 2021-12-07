import 'package:digitendance/app/models/faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacultySearchTile extends ConsumerWidget {
  final Faculty faculty;
  const FacultySearchTile({required this.faculty, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 300,
      height: 150,
      child: Text(faculty.userId),

    );
  }
}
