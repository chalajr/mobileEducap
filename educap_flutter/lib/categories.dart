import 'package:educap_flutter/category_lesson_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'category.dart';
import 'sub_categories.dart';
import 'token_refresh.dart';

import 'lesson_detail_view.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

const eduCapBlue = Color(0xff5c8ec8);
const port = 'https://gentle-lowlands-24763.herokuapp.com/API';
const imagePort = 'https://gentle-lowlands-24763.herokuapp.com';

class CategoriesLayout extends StatefulWidget {
  const CategoriesLayout({Key? key}) : super(key: key);

  @override
  CategoriesLayoutState createState() => CategoriesLayoutState();
}

class CategoriesLayoutState extends State<CategoriesLayout> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == 'SubCategories') {
          final args = settings.arguments as CategoryArguments;
          return MaterialPageRoute(builder: (context) {
            return SubCategories(id: args.id);
          });
        }
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const Categories();
          });
        }
        if (settings.name == 'CategoryLessonList') {
          final args = settings.arguments as CategoryArguments;
          return MaterialPageRoute(builder: (context) {
            return CategoryLessonList(id: args.id);
          });
        }
        if (settings.name == 'LessonDetailView') {
          final args = settings.arguments as CategoryArguments;
          return MaterialPageRoute(builder: (context) {
            return LessonDetailView(id: args.id);
          });
        }

        return null;
      },
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextEditingController searchController = TextEditingController();
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getCategory(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes conexión a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Categorías'),
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
                          labelText: "Buscar Categorías",
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
                title: const Text('Categorías'),
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
                          labelText: "Buscar Categorías",
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
                        return snapshot.data![index].nombre
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase()) ||
                                snapshot.data![index].descripcion
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                            ? Card(
                                child: ListTile(
                                  leading: Image.network(
                                      imagePort + snapshot.data![index].imagen),
                                  title: Text(snapshot.data![index].nombre),
                                  subtitle: Text(
                                    snapshot.data![index].descripcion,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SubCategories.routeName,
                                        arguments: CategoryArguments(
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

Future<List<Category>> getCategory(context) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/category/getAll'),
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
    List<Category> categories = [];
    for (var category in categoriesDecode) {
      dynamic categoryToAdd;
      categoryToAdd = Category.fromJson(category);
      categories.add(categoryToAdd);
    }
    return categories;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load User');
  }
}
