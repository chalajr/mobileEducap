import 'package:educap_flutter/logout.dart';
import 'package:educap_flutter/my_lesson_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'token_refresh.dart';
import 'lesson_detail_view.dart';
import 'my_lesson_list.dart';
import 'lesson_detail.dart';

const eduCapBlue = Color(0xff5c8ec8);
const port = 'https://gentle-lowlands-24763.herokuapp.com/API';
const imagePort = 'https://gentle-lowlands-24763.herokuapp.com';

class MyAccountLayout extends StatefulWidget {
  const MyAccountLayout({Key? key}) : super(key: key);

  @override
  _MyAccountLayoutState createState() => _MyAccountLayoutState();
}

class _MyAccountLayoutState extends State<MyAccountLayout> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == 'MyLessonList') {
          return MaterialPageRoute(builder: (context) {
            return const MyLessonListLayout();
          });
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const MyAccount();
          });
        }
        if (settings.name == 'LessonDetailView') {
          final args = settings.arguments as MyLessonArguments;
          return MaterialPageRoute(builder: (context) {
            return LessonDetailView(id: args.id);
          });
        }
        return null;
      },
    );
  }
}

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getStudent(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Sin conexión');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mi cuenta'),
                backgroundColor: eduCapBlue,
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mi cuenta'),
                backgroundColor: eduCapBlue,
              ),
              body: Center(
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
                      snapshot.data!.firstName + ' ' + snapshot.data!.lastName,
                      style: const TextStyle(
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
                          snapshot.data!.email,
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
                          Icons.person,
                          color: eduCapBlue,
                        ),
                        title: Text(
                          '${snapshot.data!.age} años',
                          style: TextStyle(
                            color: Colors.teal.shade900,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 25.0,
                        ),
                        child: ListTile(
                          onTap: () => {
                            Navigator.pushNamed(
                              context,
                              MyLessonListLayout.routeName,
                            )
                          },
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
                      onTap: () => {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                children: const [
                                  Flexible(
                                    child: Text(
                                      'Estas seguro que deseas cerrar tu sesión?',
                                    ),
                                  ),
                                ],
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'Una vez que cierres sesión tendras que volver a entrar a la aplicacion utilizando tus credenciales.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Text('Continuar'),
                                      Icon(Icons.logout),
                                    ],
                                  ),
                                  onPressed: () {
                                    logout(context);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      },
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
              ),
            );
          default:
            return const Text('default');
        }
      },
    );
  }
}

Future<User> getStudent(context) async {
  String accessCode = await getAccessTokenApi(context);
  final response = await http.get(
    Uri.parse('$port/get/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );

  final response2 = await http.get(
    Uri.parse('$port/get/student'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200 && response2.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var student = Student.fromJson(
        jsonDecode(const Utf8Decoder().convert(response2.bodyBytes)));
    var user = User.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes)),
        student.age);

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
  int age;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json, int age) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: age,
    );
  }
}

class Student {
  int age;
  Student({
    required this.age,
  });
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      age: json['edad'],
    );
  }
}
