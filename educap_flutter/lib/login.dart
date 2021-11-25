import 'package:educap_flutter/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'register_form.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const eduCapBlue = Color(0xff5c8ec8);

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          backgroundColor: eduCapBlue,
        ),
        title: "Login",
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const LoginForm(),
        supportedLocales: const [
          Locale('es', ''),
        ]);
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  //Variables donde se guardara la informacion de el input del usuario despues de la validacion tienen que ser del tipo TextEditingController
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SingleChildScrollView es para que puedas hacer scroll en el formulario
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logoEducap-bg.png'),
                Form(
                  //Key necesaria del formulario
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //INPUT DE CORREO
                      //Aqui se pone interesante
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: email,
                          //Keyboard type de tipo email
                          keyboardType: TextInputType.emailAddress,
                          //La validacion del correo es diferente por lo que importe un paquete
                          validator: (value) {
                            //Primero hay que revisar que el input del usuario no sea nullo
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un correo valido';
                              //Si el input del usuario no es nulo entonces ya se puede utilizar el paquete, tiene que ser asi
                            } else if (!EmailValidator.validate(value)) {
                              return 'Por favor ingresa un correo valido';
                            }
                            //Si le regresas null quiere decir que la validacion paso
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ingresa tu correo electronico',
                          ),
                        ),
                      ),
                      //INPUT DE CONTRASENA
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: password,
                          //Estos parametros son para esconder la contrasena y de mas
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ingresa tu contraseña',
                          ),
                        ),
                      ),
                      //Un boton que al ser presionado revisa el formulario
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterForm(),
                                ),
                              );
                            },
                            child: const Text('¿No tienes cuenta? Registrate'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Procesando información'),
                                  ),
                                );
                                //Aqui va lo que es la comunicacion con la api, en este caso solo imprimi los inputs del usuario en la consola

                                login(email.text, password.text, context);
                              }
                            },
                            child: const Text('Iniciar Sesión'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> login(
  String email,
  String password,
  context,
) async {
  final response = await http.post(
    Uri.parse('$port/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  String conversion(Map<String, dynamic> json) {
    return json['refresh'];
  }

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setBool('session', true);
    var refresh =
        conversion(jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    prefs.setString('refresh', refresh);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Layout(),
      ),
    );
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create user.');
  }
}
