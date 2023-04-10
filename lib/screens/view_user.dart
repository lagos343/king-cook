import 'package:flutter/material.dart';
import '../users.dart';

// Pantalla principal que muestra la información del usuario
class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Ajustes')),
        backgroundColor: Color.fromRGBO(0, 131, 143, 1),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(0, 131, 143, 1),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                              Usuarios.nombre[0].toUpperCase()),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  Usuarios.nombre,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  Usuarios.email,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Contraseña: ${Usuarios.contrasenia.replaceRange(2, Usuarios.contrasenia.length, '*' * (Usuarios.contrasenia.length - 2))}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 131, 143, 1),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'changepassword');
                  },
                  child: Text('Cambiar contraseña'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
