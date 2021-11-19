import 'package:digitendance/app/notifiers/auth_notifier.dart';
import 'package:digitendance/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAppHome extends ConsumerWidget {
  const AdminAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, widgetRef) {
    final notifier = widgetRef.read(authStateProvider.notifier);
    widgetRef.watch(authStateChangesStreamProvider);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome Admin!',
                style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Wrap(
                alignment: WrapAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const AdminMenuCard(
                    iconData: Icons.auto_stories,
                    title: 'Courses',
                  ),
                  const AdminMenuCard(
                    // assetName: 'student.jpg',
                    iconData: Icons.people,
                    title: 'Students',
                  ),
                  const AdminMenuCard(
                    // assetName: 'faculty.png',
                    iconData: Icons.school,
                    title: 'Faculty',
                  ),
                  const AdminMenuCard(
                    // assetName: 'about.png',
                    iconData: Icons.info,
                    title: 'About Digitendance',
                  ),
                  const AdminMenuCard(
                    // assetName: 'settings.png',
                    iconData: Icons.settings,
                    title: 'Settings',
                  ),
                  const AdminMenuCard(
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
        ),
      ),
    );
  }
}

class AdminMenuCard extends StatelessWidget {
  // final String assetName;
  final IconData iconData;
  final String title;
  const AdminMenuCard({Key? key, required this.iconData, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      height: 220,
      child: InkWell(
        hoverColor: Colors.purple.shade300,
        onTap: () {},
        child: Card(
          elevation: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
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
    );
  }
}
