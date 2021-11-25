import 'package:educap_flutter/login.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const port = 'https://gentle-lowlands-24763.herokuapp.com/API';

// Define a custom Form widget.
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<RegisterFormState>.
  final _formKey = GlobalKey<FormState>();

  //Variables donde se guardara la informacion de el input del usuario despues de la validacion tienen que ser del tipo TextEditingController
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  final passVal = String;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de cuenta'),
      ),
      //SingleChildScrollView es para que puedas hacer scroll en el formulario
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logoEducap-bg.png'),
            Form(
              //Key necesaria del formulario
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //INPUT DE NOMBRE
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      // El controlador es donde se va a guardar el input del usuario despues de la validacion
                      controller: firstName,
                      // Validacion del input del usuario
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre(s)';
                        }

                        return null;
                      },
                      //Decoracion para que se vea cool el input
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //Label
                        labelText: 'Ingresa tu nombre(s)',
                      ),
                    ),
                  ),
                  //INPUT DE APELLIDO
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido(s)';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingresa tu apellido(s)',
                      ),
                    ),
                  ),
                  //INPUT DE EDAD
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: age,
                      //El keyboard type para que sea numerico
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu edad';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingresa tu edad',
                      ),
                    ),
                  ),
                  //INPUT DE CORREO
                  //Aqui se pone interesante
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: password,
                      //Estos parametros son para esconder la contrasena y de mas
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validators.compose([
                        Validators.required(
                            'Por favor introduzca una contraseña'),
                        Validators.minLength(8,
                            'Contraseña Inválida, debe de ser mayor o igual a 8 caracteres'),
                      ]),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingresa tu contraseña',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: password2,
                      //Estos parametros son para esconder la contrasena y de mas
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Las contraseñas deben de coincidir';
                        } else if (password2.text != password.text) {
                          return 'Las contraseñas deben de coincidir';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingresa tu contraseña de nuevo',
                      ),
                    ),
                  ),
                  //Un boton que al ser presionado revisa el formulario
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Procesando información')),
                        );
                        //Aqui va lo que es la comunicacion con la api, en este caso solo imprimi los inputs del usuario en la consola
                        createUser(
                          firstName.text,
                          lastName.text,
                          int.parse(age.text),
                          email.text,
                          password.text,
                          context,
                        );
                      }
                    },
                    child: const Text('Registrar cuenta'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createUser(
  String firstName,
  String lastName,
  int age,
  String email,
  String password,
  context,
) async {
  final response = await http.post(
    Uri.parse('$port/auth/register/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    }),
  );

  int conversion(Map<String, dynamic> json) {
    return json['id'];
  }

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    var id =
        conversion(jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    createStudent(age, id, context);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create user.');
  }
}

Future<http.Response> createStudent(
  int age,
  int id,
  context,
) async {
  final response = await http.post(
    Uri.parse('$port/auth/register/student'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'edad': '$age',
      'user': '$id',
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Text(
                'Registro exitoso!',
              ),
              Icon(Icons.check),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginForm(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    return response;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.

    throw Exception('Failed to create student.');
  }
}
