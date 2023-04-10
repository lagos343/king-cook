// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kingcook/users.dart';
import '../auth/auth.dart';

class CambiarContrasenaScreen extends StatefulWidget {
  const CambiarContrasenaScreen({Key? key}) : super(key: key);

  @override
  _CambiarContrasenaScreenState createState() =>
      _CambiarContrasenaScreenState();
}

class _CambiarContrasenaScreenState extends State<CambiarContrasenaScreen> {
  var auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambio de Contraseña'),
        backgroundColor: const Color.fromRGBO(0, 131, 143, 1),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña Antigua',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña antigua';
                      }
                      if (value != Usuarios.contrasenia) {
                        return 'La contraseña ingresada no es correcta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña Nueva',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nueva contraseña';
                      }
                      if (value == Usuarios.contrasenia) {
                        return 'la contraseña nueva debe ser distinta a la vieja';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Contraseña',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirme su nueva contraseña';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(0, 131, 143, 1),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cambioContrasenia();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Cambiar Contraseña',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> cambioContrasenia() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Cambiando la contraseña..'),
            // ignore: sized_box_for_whitespace
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(
                    color: Color.fromRGBO(0, 131, 143, 1),
                  ),
                )
              ],
            ));
      },
      barrierDismissible: false, // El usuario no puede cerrar el dialogo
    );

    if (await auth.changePassword(
        Usuarios.email, Usuarios.contrasenia, _newPasswordController.text)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contraseña cambiada exitosamente")),
      );
      Usuarios.contrasenia = _newPasswordController.text;
      // ignore: use_build_context_synchronously
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Ha ocurrido un problema, espere un rato e intente de nuevo")),
      );
    }

    Navigator.pushNamedAndRemoveUntil(context, '/userview', (route) => false);
  }
}
