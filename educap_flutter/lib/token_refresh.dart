import 'package:educap_flutter/logout.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const port = 'https://gentle-lowlands-24763.herokuapp.com/API';

Future<String> getAccessTokenApi(context) async {
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
  if (access.statusCode == 200) {
    // If the server did return a 200 OK access,
    // then parse the JSON.
    String accessConversion(Map<String, dynamic> json) {
      return json["access"];
    }

    var acessCode = accessConversion(jsonDecode(access.body));

    return acessCode;
  } else {
    // If the server did not return a 200 OK access,
    // then throw an exception.
    logout(context);
    return 'No session';
  }
}
