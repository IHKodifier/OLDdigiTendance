import 'package:digitendance/app/models/user_role.dart';
import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:digitendance/shared/user_avatar.dart';
import 'package:digitendance/ui/courses/coursespage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHomeBody extends ConsumerWidget {
  AdminHomeBody({Key? key}) : super(key: key);
  late Widget returnedWidget;
  late UserRole selectedRole;

  @override
  Widget build(BuildContext context, widgetRef) {
    final notifier = widgetRef.watch(authStateProvider.notifier);
    selectedRole = widgetRef.watch(authStateProvider).selectedRole!;

    widgetRef.watch(authStateChangesStreamProvider);
    return Center(
      child: SingleChildScrollView(
        child: _AdminBody(notifier: notifier),
      ),
    );
  }

  // void setBodyreturnWidget(AuthNotifier notifier) {
  //   switch (selectedRole) {
  //     case UserRole.admin:
  //       returnedWidget = _AdminBody(notifier: notifier);
  //       break;
  //     case UserRole.teacher:
  //       returnedWidget =
  //           Container(color: Colors.amberAccent, width: 50, height: 50);
  //       break;
  //     default:
  //       returnedWidget = Center(
  //         child: Text('default Student Home'),
  //       );
  //   }
  // }
}

class _AdminBody extends StatelessWidget {
  const _AdminBody({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final AuthNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Welcome Admin!', style: Theme.of(context).textTheme.headline3),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Wrap(
            alignment: WrapAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const _AdminMenuCard(
                iconData: Icons.auto_stories,
                title: 'Courses',
              ),
              const _AdminMenuCard(
                // assetName: 'student.jpg',
                iconData: Icons.people,
                title: 'Students',
              ),
              const _AdminMenuCard(
                // assetName: 'faculty.png',
                iconData: Icons.school,
                title: 'Faculty',
              ),
              const _AdminMenuCard(
                // assetName: 'about.png',
                iconData: Icons.info,
                title: 'About Digitendance',
              ),
              const _AdminMenuCard(
                // assetName: 'settings.png',
                iconData: Icons.settings,
                title: 'Settings',
              ),
              const _AdminMenuCard(
                // assetName: 'reports.jpg',
                iconData: Icons.bar_chart_sharp,
                title: 'Reports',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              notifier.signOut();
            },
            child: Text('Log out ')),
      ],
    );
  }
}

class _TeacherBody extends StatelessWidget {
  const _TeacherBody({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final AuthNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Welcome Teacher!', style: Theme.of(context).textTheme.headline3),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Wrap(
            alignment: WrapAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const _AdminMenuCard(
                iconData: Icons.auto_stories,
                title: 'Courses',
              ),
              //   const _AdminMenuCard(
              //     // assetName: 'student.jpg',
              //     iconData: Icons.people,
              //     title: 'Students',
              //   ),
              //   const _AdminMenuCard(
              //     // assetName: 'faculty.png',
              //     iconData: Icons.school,
              //     title: 'Faculty',
              //   ),
              //   const _AdminMenuCard(
              //     // assetName: 'about.png',
              //     iconData: Icons.info,
              //     title: 'About Digitendance',
              //   ),
              //   const _AdminMenuCard(
              //     // assetName: 'settings.png',
              //     iconData: Icons.settings,
              //     title: 'Settings',
              //   ),
              //   const _AdminMenuCard(
              //     // assetName: 'reports.jpg',
              //     iconData: Icons.bar_chart_sharp,
              //     title: 'Reports',
              //   ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              notifier.signOut();
            },
            child: Text('Log out ')),
      ],
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  // final String assetName;
  final IconData iconData;
  final String title;
  const _AdminMenuCard({Key? key, required this.iconData, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.20,
        margin: EdgeInsets.all(4),
        height: 220,
        child: InkWell(
          hoverColor: Colors.purple.shade300,
          splashColor: Colors.purple.shade100,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CoursesPage()));},
            
          
          child: Card(
            // shape: ShapeBorder(),
            elevation: 25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  size: 80,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
