import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'dart:developer' as developer;

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
    developer.log('hola');
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
                        Validators.patternString(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                            'Contraseña Inválida')
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
                          return 'Por favor ingresa tu edad';
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
                        var nombre = firstName.text;
                        var apellido = lastName.text;
                        var edad = age.text;
                        var correo = email.text;
                        var contrasena = password.text;
                        var contrasena2 = password2.text;
                        developer.log(
                            'Nombres: $nombre, apellidos: $apellido, edad: $edad, correo: $correo, contrasena: $contrasena, contrasena: $contrasena2');
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
