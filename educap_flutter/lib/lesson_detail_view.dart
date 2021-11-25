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

const imagePort = 'https://gentle-lowlands-24763.herokuapp.com';

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
                            FutureBuilder<bool>(
                              future: getFollow(context, id),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return const Text(
                                        'No tienes conección a internet.');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.grey),
                                        icon: const Icon(Icons.bookmark),
                                        label: const Text('Procesando'),
                                      ),
                                    );
                                  case ConnectionState.done:
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            setFollow(
                                                context, id, snapshot.data!);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: () {
                                            if (snapshot.data!) {
                                              return Colors.red;
                                            } else {
                                              return Colors.blue;
                                            }
                                          }(),
                                        ),
                                        icon: Icon(
                                          () {
                                            if (snapshot.data!) {
                                              return Icons.bookmark;
                                            } else {
                                              return Icons.bookmark_add;
                                            }
                                          }(),
                                        ),
                                        label: () {
                                          if (snapshot.data!) {
                                            return const Text(
                                                'Dejar de seguir');
                                          } else {
                                            return const Text('Seguir');
                                          }
                                        }(),
                                      ),
                                    );
                                  default:
                                    return const Text('default');
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
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
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                          child: Divider(
                            color: Colors.blue[800],
                          ),
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
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                          child: Divider(
                            color: Colors.blue[800],
                          ),
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
    var lesson = Lesson.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));

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
    var category = CategoryByName.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
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
    var categoriesDecode =
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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
    var categoriesDecode =
        jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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

class Follow {
  bool follow;

  Follow({
    required this.follow,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    if (json['follow']) {}
    return Follow(
      follow: json['follow'],
    );
  }
}

Future<bool> getFollow(context, id) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/followedLesson/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}

Future<void> setFollow(context, id, follow) async {
  String accessCode = await getAccessTokenApi(context);
  final response = await http.post(
    Uri.parse('$port/setFollowedLesson'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessCode',
    },
    body: jsonEncode(<String, String>{
      'id': '$id',
      'follow': '$follow',
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    await getFollow(context, id);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create user.');
  }
}
