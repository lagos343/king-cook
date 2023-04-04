import 'package:flutter/material.dart';
import 'package:king_cook/screens/register_page.dart';

var _loading = false;

// ignore: camel_case_types
class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

// ignore: camel_case_types
class _login_pageState extends State<login_page> {
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
                        decoration:
                            const InputDecoration(labelText: "Usuario")),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Contraseña"),
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
                          const Text("Iniciar Sesion"),
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
                      onPressed: () {
                        _login(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/puente', (route) => false);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        const Text("¿No estas registrado?"),
                        TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Color.fromRGBO(77, 208, 225, 1))),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/register', (route) => false);
                          },
                          child: Text("Registrarse"),
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

  void _login(BuildContext context) {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }
  }
}
