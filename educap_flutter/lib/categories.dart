import 'package:educap_flutter/home_page.dart';
import 'package:educap_flutter/login.dart';
import 'package:educap_flutter/main.dart';
import 'package:educap_flutter/my_account.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_refresh.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

const port = 'http://10.0.2.2:8000/API';
const imagePort = 'http://10.0.2.2:8000';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  TextEditingController searchController = TextEditingController();
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getCategory(),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyAccount(),
                                    ),
                                  );
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

Future<List<Category>> getCategory() async {
  String accessCode = await getAccessTokenApi();

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
  String nombre;
  String descripcion;
  String imagen;
  int? categoriaPadre;

  Category(
      {required this.nombre,
      required this.descripcion,
      required this.imagen,
      this.categoriaPadre});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        imagen: json['imagen'],
        categoriaPadre: json['categoriaPadre']);
  }
}
