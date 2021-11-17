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
  }

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder<User>(
            future: getStudent(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Sin conexión');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Text('Esperando');
                case ConnectionState.done:
                  return Text(
                    snapshot.data!.firstName,
                    style: const TextStyle(
                      fontSize: 40.0,
                      color: eduCapBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  );

                default:
                  return const Text('default');
              }
            },
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
            child: FutureBuilder<User>(
              future: getStudent(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Sin conexión');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Text('Esperando');
                  case ConnectionState.done:
                    return ListTile(
                      leading: const Icon(
                        Icons.mail,
                        color: eduCapBlue,
                      ),
                      title: Text(
                        snapshot.data!.email,
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                  default:
                    return const Text('default');
                }
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: FutureBuilder<User>(
              future: getStudent(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Sin conexión');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Text('Esperando');
                  case ConnectionState.done:
                    return ListTile(
                      leading: const Icon(
                        Icons.mail,
                        color: eduCapBlue,
                      ),
                      title: Text(
                        '22',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontSize: 20.0,
                        ),
                      ),
                    );
                  default:
                    return const Text('default');
                }
              },
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

Future<User> getStudent() async {
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
