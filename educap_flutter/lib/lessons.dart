import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'lesson.dart';
import 'token_refresh.dart';
import 'lesson_detail_view.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

const eduCapBlue = Color(0xff5c8ec8);
const port = 'https://gentle-lowlands-24763.herokuapp.com/API';
const imagePort = 'https://gentle-lowlands-24763.herokuapp.com';

class LessonArguments {
  final int id;
  LessonArguments(this.id);
}

class LessonsLayout extends StatefulWidget {
  const LessonsLayout({Key? key}) : super(key: key);

  @override
  LessonsLayoutState createState() => LessonsLayoutState();
}

class LessonsLayoutState extends State<LessonsLayout> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == 'LessonDetailView') {
          final args = settings.arguments as LessonArguments;
          return MaterialPageRoute(builder: (context) {
            return LessonDetailView(id: args.id);
          });
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const Lessons();
          });
        }
        return null;
      },
    );
  }
}

class Lessons extends StatefulWidget {
  const Lessons({Key? key}) : super(key: key);

  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  TextEditingController searchController = TextEditingController();
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lesson>>(
      future: getLesson(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes conexión a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Lecciones'),
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
                title: const Text('Lecciones'),
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
                                    .contains(searchString.toLowerCase()) ||
                                snapshot.data![index].descripcion
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
                                        context, LessonDetailView.routeName,
                                        arguments: LessonArguments(
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

Future<List<Lesson>> getLesson(context) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/lessons/getAll'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var lessonsDecode =
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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
