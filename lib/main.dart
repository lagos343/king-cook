import 'package:flutter/material.dart';
import 'package:king_cook/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: login_page(),
      debugShowCheckedModeBanner: false,
    );
  }
}
