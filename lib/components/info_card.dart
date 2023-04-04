import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//Informacion del Usuario
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key, 
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          //Image(image: NetworkImage('https://img.freepik.com/vector-premium/icono-circulo-usuario-anonimo-ilustracion-vector-estilo-plano-sombra_520826-1931.jpg')),
          CupertinoIcons.person, //El logo de persona
          color: Colors.white,
        ),
      ),
      title: Text(
        name, //Nombre del usuario
        style: const TextStyle(color: Colors.white),
        ), 
    );
  }
}