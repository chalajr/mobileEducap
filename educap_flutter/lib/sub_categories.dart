import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'category.dart';
import 'category_lesson_list.dart';
import 'token_refresh.dart';

const imagePort = 'https://gentle-lowlands-24763.herokuapp.com';
const port = 'https://gentle-lowlands-24763.herokuapp.com/API';

const eduCapBlue = Color(0xff5c8ec8);

class SubCategories extends StatefulWidget {
  static const routeName = 'SubCategories';

  final int id;

  const SubCategories({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _SubCategoriesState createState() => _SubCategoriesState(id);
}

class _SubCategoriesState extends State<SubCategories> {
  final int id;

  //Constructor
  _SubCategoriesState(this.id);

  TextEditingController searchController = TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getSubCategory(context, id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes conexión a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Subcategorías'),
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
                title: const Text('Subcategorías'),
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
                                        context, CategoryLessonList.routeName,
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

Future<List<Category>> getSubCategory(context, id) async {
  String accessCode = await getAccessTokenApi(context);

  final response = await http.get(
    Uri.parse('$port/category/getSub/$id'),
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
