import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_refresh.dart';

const eduCapBlue = Color(0xff5c8ec8);

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    super.initState();
    getStudent();
  }

  @override
  Widget build(BuildContext context) {
    getStudent();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black26,
            child: CircleAvatar(
              radius: 49.5,
              backgroundColor: Colors.white,
              child: Image.asset('images/output-onlinepngtools.png'),
            ),
          ),
          Text(
            'Frank',
            style: TextStyle(
              fontSize: 40.0,
              color: eduCapBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Estudiante',
            style: TextStyle(
              fontSize: 20.0,
              color: eduCapBlue,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
            width: 150,
            child: Divider(
              color: Colors.blue[800],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.mail,
                color: eduCapBlue,
              ),
              title: Text(
                'chalajr@gmail.com',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.settings_accessibility,
                color: eduCapBlue,
              ),
              title: Text(
                '25',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.menu_book,
                  color: eduCapBlue,
                ),
                title: Text(
                  'Mis lecciones',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {getStudent()},
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: eduCapBlue,
                ),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const port = 'http://10.0.2.2:8000/API';

Future getStudent() async {
  String accessCode = await getAccessTokenApi();

  final response = await http.get(
    Uri.parse('$port/get/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var user = User.fromJson(jsonDecode(response.body));

    return user;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

class User {
  String email;
  String firstName;
  String lastName;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
