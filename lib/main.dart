import 'package:flutter/material.dart';
import 'package:king_cook/screens/login_page.dart';
import 'package:king_cook/screens/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: _rutas,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(0, 131, 143, 1),
        secondaryHeaderColor: Colors.cyan[300],
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  final _rutas = {
    '/': (context) => const login_page(),
    '/register': (context) => const register_page(),
  };
}
