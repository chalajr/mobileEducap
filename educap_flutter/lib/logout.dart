import 'package:educap_flutter/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(context) async {
  final prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  prefs.setString('refresh', 'No session');
  prefs.setBool('session', false);
  Navigator.pop(context);
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const Login()));
}
