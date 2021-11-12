import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('Categories')],
    );
  }
}
