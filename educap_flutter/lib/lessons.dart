import 'package:flutter/material.dart';

class Lessons extends StatefulWidget {
  const Lessons({Key? key}) : super(key: key);

  @override
  LessonsState createState() => LessonsState();
}

class LessonsState extends State<Lessons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Lessons')],
    );
  }
}
