import 'package:flutter/material.dart';

class Lessons extends StatefulWidget {
  Lessons({Key? key}) : super(key: key);

  @override
  LessonsState createState() => LessonsState();
}

class LessonsState extends State<Lessons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('Lessons')],
    );
  }
}
