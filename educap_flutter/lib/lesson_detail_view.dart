import 'package:flutter/material.dart';

const imagePort = 'http://10.0.2.2:8000';

const eduCapBlue = Color(0xff5c8ec8);

class LessonDetail extends StatefulWidget {
  static const routeName = 'LessonDetail';

  final int id;

  const LessonDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _LessonDetailState createState() => _LessonDetailState(id);
}

class _LessonDetailState extends State<LessonDetail> {
  final int id;

  //Constructor
  _LessonDetailState(this.id);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
