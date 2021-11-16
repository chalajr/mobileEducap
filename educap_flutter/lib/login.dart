import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'dart:developer' as developer;
import 'register_form.dart';

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
                                      builder: (context) =>
                                          const RegisterForm()));
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
                                      content: Text('Procesando información')),
                                );
                                //Aqui va lo que es la comunicacion con la api, en este caso solo imprimi los inputs del usuario en la consola

                                var correo = email.text;
                                var contrasena = password.text;
                                developer.log(
                                    'correo: $correo, contrasena: $contrasena');
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
