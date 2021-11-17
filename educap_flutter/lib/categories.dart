import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'token_refresh.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  TextEditingController editingController = TextEditingController();
  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      for (var item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: const InputDecoration(
                labelText: "Buscar Categorías",
                hintText: "Buscar",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(items[index]),
                  subtitle: const Text('Lorem Ipsum Isoceles'),
                  //onTap:
                  dense: false,
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<Category> getCategory() async {
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
    var category = Category.fromJson(jsonDecode(response.body));
    print(category);
    return category;
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
