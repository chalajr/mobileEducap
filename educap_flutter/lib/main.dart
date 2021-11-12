import 'package:flutter/material.dart';
import 'home_page.dart';
import 'categories.dart';
import 'my_account.dart';
import 'lessons.dart';

void main() {
  runApp(const Layout());
}

const eduCapBlue = Color(0xff5c8ec8);

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: eduCapBlue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Educap'),
            backgroundColor: eduCapBlue,
          ),
          body: HomePage(),
          bottomNavigationBar: navBar()),
    );
  }
}

Widget navBar() {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: Colors.white,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
        label: 'Lecciones',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.school,
          color: Colors.white,
        ),
        label: 'Categorias',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
          color: Colors.white,
        ),
        label: 'Mi cuenta',
      ),
    ],
    backgroundColor: eduCapBlue,
  );
}
