import 'package:educap_flutter/my_account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'lesson.dart';
import 'token_refresh.dart';
import 'lesson_detail_view.dart';

const eduCapBlue = Color(0xff5c8ec8);
const port = 'http://10.0.2.2:8000/API';
const imagePort = 'http://10.0.2.2:8000';

class MyLessonArguments {
  final int id;
  MyLessonArguments(this.id);
}

class MyLessonList extends StatefulWidget {
  const MyLessonList({Key? key}) : super(key: key);

  @override
  _MyLessonListState createState() => _MyLessonListState();
}

class _MyLessonListState extends State<MyLessonList> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == 'LessonDetail') {
          final args = settings.arguments as MyLessonArguments;
          return MaterialPageRoute(builder: (context) {
            return LessonDetail(id: args.id);
          });
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const MyLessonListLayout();
          });
        }

        return null;
      },
    );
  }
}

class MyLessonListLayout extends StatefulWidget {
  static const routeName = 'MyLessonList';

  const MyLessonListLayout({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  MyLessonsListState createState() => MyLessonsListState();
}

class MyLessonsListState extends State<MyLessonListLayout> {
  TextEditingController searchController = TextEditingController();
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>>(
      future: getMyLessons(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes conexión a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mis Lecciones'),
                backgroundColor: eduCapBlue,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                          labelText: "Buscar Lecciones",
                          hintText: "Buscar",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            );
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mis Lecciones'),
                backgroundColor: eduCapBlue,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                          labelText: "Buscar Lecciones",
                          hintText: "Buscar",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data![index].titulo
                                .toLowerCase()
                                .contains(searchString.toLowerCase())
                            ? Card(
                                child: ListTile(
                                  leading: Image.network(
                                      imagePort + snapshot.data![index].imagen),
                                  title: Text(snapshot.data![index].titulo),
                                  subtitle: Text(
                                    snapshot.data![index].descripcion,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, LessonDetail.routeName,
                                        arguments: MyLessonArguments(
                                            snapshot.data![index].id));
                                  },
                                  dense: false,
                                  trailing:
                                      const Icon(Icons.chevron_right_rounded),
                                ),
                              )
                            : const Text('');
                      },
                    ),
                  ),
                ],
              ),
            );
          default:
            return const Text('default');
        }
      },
    );
  }
}

Future<List<Lesson>> getMyLessons(context) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/getUserLessons'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var lessonsDecode = jsonDecode(response.body);
    List<Lesson> lessons = [];
    for (var lesson in lessonsDecode) {
      dynamic lessonToAdd;
      lessonToAdd = Lesson.fromJson(lesson);
      lessons.add(lessonToAdd);
    }
    return lessons;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}