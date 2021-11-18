import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'token_refresh.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

const port = 'http://10.0.2.2:8000/API';
const imagePort = 'http://10.0.2.2:8000';

class CategoryArguments {
  final int id;
  CategoryArguments(this.id);
}

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
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            return const Categories();
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
            return const Text('No tienes coneccion a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Column(
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
              ],
            );
          case ConnectionState.done:
            return Column(
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
                              .contains(searchString.toLowerCase())
                          ? Card(
                              child: ListTile(
                                leading: Image.network(
                                    imagePort + snapshot.data![index].imagen),
                                title: Text(snapshot.data![index].nombre),
                                subtitle:
                                    Text(snapshot.data![index].descripcion),
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
            );
          default:
            return const Text('default');
        }
      },
    );
  }
}

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
      future: getCategory(context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('No tienes coneccion a internet.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Column(
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
              ],
            );
          case ConnectionState.done:
            return Column(
              children: [
                Text('$id'),
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
                              .contains(searchString.toLowerCase())
                          ? Card(
                              child: ListTile(
                                leading: Image.network(
                                    imagePort + snapshot.data![index].imagen),
                                title: Text(snapshot.data![index].nombre),
                                subtitle:
                                    Text(snapshot.data![index].descripcion),
                                onTap: () {},
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
    var categoriesDecode = jsonDecode(response.body);
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

class Category {
  int id;
  String nombre;
  String descripcion;
  String imagen;
  int? categoriaPadre;

  Category({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.categoriaPadre,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        imagen: json['imagen'],
        categoriaPadre: json['categoriaPadre']);
  }
}
