import 'package:flutter/material.dart';

void main() {
  runApp(const Layout());
}

const eduCapBlue = Color(0xff5c8ec8);

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<Layout> {
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
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
        label: 'Sobre Nosotros',
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




// class SobreNosotros  extends StatefulWidget {
//   SobreNosotros ({ Key? key }) : super(key: key);

//   @override
//   SobreNosotrosState createState() => SobreNosotrosState();

// }
// class SobreNosotrosState extends State<SobreNosotros> {
//   @override
//   Widget build(BuildContext context) {
//     return (

      
//     );
//   }
// }