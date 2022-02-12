import 'package:digitendance/app/models/faculty.dart';
import 'package:digitendance/app/utilities.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class FacultyAvatar extends StatelessWidget {
  FacultyAvatar({Key? key, required this.faculty}) : super(key: key);
  final Faculty? faculty;
  RandomColor randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    Color _color =
        randomColor.randomColor(colorBrightness: ColorBrightness.light);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: _color,
        foregroundColor: Colors.black,
        backgroundImage: NetworkImage(faculty!.photoURL),
        radius: 50,
        child: Text(faculty!.firstName![0] + faculty!.lastName[0],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
      ),
    );
  }
}

class FacultyAvatarBlank extends StatelessWidget {
  FacultyAvatarBlank({Key? key}) : super(key: key);
  // final Faculty? faculty;
  RandomColor randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    Color _color =
        randomColor.randomColor(colorBrightness: ColorBrightness.light);

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: _color,
          foregroundColor: Colors.black,
          radius: 50,
          child: const Icon(
            Icons.person,
            size: 90,
          ),
        ),
      ),
      onTap: () async {
        var value = await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Faculty'),
            children: [
              SimpleDialogOption(
                  child: const ListTile(
                    title: Text('One'),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'One');
                  }),
              SimpleDialogOption(
                  child: const ListTile(
                    title: Text('Two'),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'Two');
                  }),
            ],
          ),
        );
        Utils.log('$value was selected by user');
      },
    );
  }
}
