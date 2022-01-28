import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dummyFutureProvider = FutureProvider<void>((ref) {
  return Future.delayed(Duration(milliseconds: 500));
});

class TeacherAppHome extends ConsumerWidget {
  const TeacherAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(dummyFutureProvider);
    return asyncValue.when(
        data: (data) => Center(child: Text('Teacher Home',
        style: Theme.of(context).textTheme.headline2,)),
        error: (e, st, ) => Center(child: Text(e.toString())),
        loading: () => Center(child: CircularProgressIndicator()));
  }
}
