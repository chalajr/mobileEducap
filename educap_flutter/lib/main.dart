import 'package:flutter/material.dart';
import 'app_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:convert';
import 'register_form.dart';

var auth = true;
const port = '10.0.2.2:8000/API';

void main() {
  if (auth) {
    runApp(const EduCap());
  } else {}
}

Future<String> getResponse() async {
  final response = await http.get(Uri.parse('http://$port/auth/test'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return convertResponse(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

var variable;

convertResponse(String json) {
  developer.log(json);
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
      home: MyCustomForm(),
    );
  }
}
