import 'package:flutter/material.dart';
import 'categories.dart';
import 'my_account.dart';
import 'lessons.dart';

const eduCapBlue = Color(0xff5c8ec8);

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    (const LessonsLayout()),
    (const CategoriesLayout()),
    (const MyAccount()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu_book,
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
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
