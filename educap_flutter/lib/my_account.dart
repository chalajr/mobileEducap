import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('MyAccount')],
    );
  }
}
