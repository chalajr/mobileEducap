import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
