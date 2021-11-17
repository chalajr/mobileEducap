import 'package:flutter/material.dart';

const eduCapBlue = Color(0xff5c8ec8);

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black26,
            child: CircleAvatar(
              radius: 49.5,
              backgroundColor: Colors.white,
              child: Image.asset('images/output-onlinepngtools.png'),
            ),
          ),
          const Text(
            'Juan Chalita',
            style: TextStyle(
              fontSize: 40.0,
              color: eduCapBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Estudiante',
            style: TextStyle(
              fontSize: 20.0,
              color: eduCapBlue,
              letterSpacing: 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
            width: 150,
            child: Divider(
              color: Colors.blue[800],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.mail,
                color: eduCapBlue,
              ),
              title: Text(
                'chalajr@hotmail.com',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.settings_accessibility,
                color: eduCapBlue,
              ),
              title: Text(
                '25',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: Card(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.menu_book,
                  color: eduCapBlue,
                ),
                title: Text(
                  'Mis lecciones',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: eduCapBlue,
              ),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
