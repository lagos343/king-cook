import 'package:flutter/material.dart';
import 'package:king_cook/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(0, 131, 143, 1),
        secondaryHeaderColor: Colors.cyan[300],
      ),
      home: login_page(),
      debugShowCheckedModeBanner: false,
    );
  }
}
