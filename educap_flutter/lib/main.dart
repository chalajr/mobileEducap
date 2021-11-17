import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:convert';
import 'register_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_layout.dart';

const port = 'http://10.0.2.2:8000/API';

void checkSession() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  final session = prefs.getBool('session') ?? false;
  if (session) {
    runApp(const Layout());
  } else {
    runApp(const Login());
  }
}

void main() {
  checkSession();
}

const eduCapBlue = Color(0xff5c8ec8);

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: eduCapBlue,
      ),
      title: "Login",
      home: const LoginForm(),
    );
  }
}
