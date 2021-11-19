import 'package:educap_flutter/category_by_name.dart';
import 'package:educap_flutter/file.dart';
import 'package:educap_flutter/lesson.dart';
import 'package:educap_flutter/token_refresh.dart';
import 'package:educap_flutter/video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

const imagePort = 'http://10.0.2.2:8000';

const eduCapBlue = Color(0xff5c8ec8);

String? url;

class LessonDetailView extends StatefulWidget {
  static const routeName = 'LessonDetailView';
  final int id;

  const LessonDetailView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _LessonDetailState createState() => _LessonDetailState(id);
}

class _LessonDetailState extends State<LessonDetailView> {
  final int id;

  @override
  void initState() {
    super.initState();
  }

  //Constructor
  _LessonDetailState(this.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lesson>(
      future: getLesson(context, id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes conexión a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Cargando',
                ),
                backgroundColor: eduCapBlue,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  snapshot.data!.titulo,
                ),
                backgroundColor: eduCapBlue,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        Image.network(
                          imagePort + snapshot.data!.imagen,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                snapshot.data!.titulo,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark),
                              label: const Text('Follow'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          width: 250,
                          child: Divider(
                            color: Colors.blue[800],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(snapshot.data!.descripcion),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          width: 250,
                          child: Divider(
                            color: Colors.blue[800],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Flexible(
                              child: Text(
                                'Contenido',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<List<Archivo>>(
                            future: getFile(context, id),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return const Text(
                                      'No tienes conección a internet.');
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return const Text('Esperando conexión');
                                case ConnectionState.done:
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Center(child: Icon(() {
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "PDF") {
                                                  return Icons.picture_as_pdf;
                                                }
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "IMG") {
                                                  return Icons.image;
                                                }
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "DOC") {
                                                  return Icons.description;
                                                }
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "XLX") {
                                                  return Icons.table_view;
                                                }
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "PPX") {
                                                  return Icons.file_present;
                                                }
                                                if (snapshot
                                                        .data![index].lipo ==
                                                    "ANY") {
                                                  return Icons.folder;
                                                }
                                              }())),
                                            ),
                                            ListTile(
                                              title: Center(
                                                child: Text(snapshot
                                                    .data![index].titulo),
                                              ),
                                              subtitle: Center(
                                                child: Text(snapshot
                                                    .data![index].descripcion),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  child:
                                                      const Text('Descargar'),
                                                  onPressed: () {
                                                    launch(imagePort +
                                                        snapshot
                                                            .data![index].path);
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                default:
                                  return const Text('default');
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Flexible(
                              child: Text(
                                'Videos',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<List<Video>>(
                            future: getVideo(context, id),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return const Text(
                                      'No tienes conección a internet.');
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return const Text('Esperando conexión');
                                case ConnectionState.done:
                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: Center(
                                                child: Text(snapshot
                                                    .data![index].titulo),
                                              ),
                                              subtitle: Center(
                                                child: Text(snapshot
                                                    .data![index].descripcion),
                                              ),
                                            ),
                                            //TODO: VIDEOPLAYER
                                            YoutubePlayer(
                                              controller:
                                                  YoutubePlayerController(
                                                initialVideoId: parseYT(
                                                    snapshot.data![index].link),
                                                flags: const YoutubePlayerFlags(
                                                  mute: false,
                                                  autoPlay: false,
                                                ),
                                              ),
                                              showVideoProgressIndicator: true,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                default:
                                  return const Text('default');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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

Future<Lesson> getLesson(context, id) async {
  String accessCode = await getAccessTokenApi(context);
  final response = await http.get(
    Uri.parse('$port/lesson/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var lesson = Lesson.fromJson(jsonDecode(response.body));

    return lesson;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

Future<CategoryByName> getCategory(context, id) async {
  String accessCode = await getAccessTokenApi(context);
  final response = await http.get(
    Uri.parse('$port/getCategoryById/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var category = CategoryByName.fromJson(jsonDecode(response.body));
    return category;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

Future<List<Archivo>> getFile(context, id) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/getFiles/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var categoriesDecode = jsonDecode(response.body);
    List<Archivo> categories = [];
    for (var file in categoriesDecode) {
      dynamic fileToAdd;
      fileToAdd = Archivo.fromJson(file);
      categories.add(fileToAdd);
    }
    return categories;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

Future<List<Video>> getVideo(context, id) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/getVideos/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var categoriesDecode = jsonDecode(response.body);
    List<Video> categories = [];
    for (var video in categoriesDecode) {
      dynamic videoToAdd;
      videoToAdd = Video.fromJson(video);
      categories.add(videoToAdd);
    }
    return categories;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

String parseYT(String url) {
  return url.replaceAll('https://youtu.be/', '');
}
