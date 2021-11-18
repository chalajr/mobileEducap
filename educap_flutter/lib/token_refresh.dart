import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const port = 'http://10.0.2.2:8000/API';

Future<String> getAccessTokenApi() async {
  final prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  final refresh = prefs.getString('refresh') ?? 'No session';

  final access = await http.post(
    Uri.parse('$port/auth/refresh'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'refresh': refresh,
    }),
  );

  String accessConversion(Map<String, dynamic> json) {
    return json["access"];
  }

  var acessCode = accessConversion(jsonDecode(access.body));
  developer.log(acessCode);
  return acessCode;
}
