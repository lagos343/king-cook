import 'package:flutter/material.dart';

import 'login_page.dart';

//variable paara verificar si esta cargando el registro
var _loading = false;

class register_page extends StatefulWidget {
  const register_page({super.key});

  @override
  State<register_page> createState() => _register_pageState();
}

class _register_pageState extends State<register_page> {
  //controladores
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 60),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(77, 208, 225, 1),
              Color.fromRGBO(0, 131, 143, 1),
            ])),
            child: Image.asset(
              "assets/images/unicah.png",
              color: Colors.white,
              height: 200,
            ),
          ),
          Center(
              child: SingleChildScrollView(
            padding: EdgeInsets.all(5),
            child: Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 250),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Nombre")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration:
                          const InputDecoration(labelText: "Contraseña"),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController2,
                      decoration: const InputDecoration(
                          labelText: "Verificar Contraseña"),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Registrar"),
                          if (_loading)
                            Container(
                              height: 20,
                              width: 20,
                              margin: const EdgeInsets.only(left: 20),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                        ],
                      ),
                      onPressed: () => _register(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text("¿Ya tienes una cuenta?"),
                        TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color.fromRGBO(77, 208, 225, 1))),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                          child: Text("Inicia Sesion"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });

      final String email = emailController.text;
      final String password = passwordController.text;
      final String password2 = passwordController2.text;
      final String name = nameController.text;

      if (email.isEmpty ||
          password.isEmpty ||
          password2.isEmpty ||
          name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Por favor, ingrese todos los datos requieridos")),
        );
      } else if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("La contraseña debe tener al menos 6 carcateres")),
        );
      } else if (password2 != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Las contraseña y su confirmacion deben ser iguales")),
        );
      } else {
        if (await auth.registerUser(email, name, password)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario registrado exitosamente")),
          );
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Ocurrio un problema con el registro, intente de nuevo y revise si su correo es valido")),
          );
        }
      }

      setState(() {
        _loading = false;
      });
    }
  }
}
