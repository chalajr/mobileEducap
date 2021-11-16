import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:convert';
import 'register_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

var auth = true;
const port = 'http://10.0.2.2:8000/API';

void main() {
  if (auth) {
    runApp(const EduCap());
  } else {}
}

const eduCapBlue = Color(0xff5c8ec8);

class EduCap extends StatelessWidget {
  const EduCap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: eduCapBlue,
      ),
      title: "EduCap",
      home: const LoginForm(),
    );
  }
}
