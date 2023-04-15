import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kingcook/puente.dart';
import 'package:kingcook/screens/change_password.dart';
import 'package:kingcook/screens/home_screen.dart';
import 'package:kingcook/screens/login_page.dart';
import 'package:kingcook/screens/photo_upload.dart';
import 'package:kingcook/screens/register_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kingcook/screens/view_user.dart';

void main() async {
  await initializeDateFormatting('es_ES', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    '/puente': (context) => const Puente(
          namelocal: 'home',
        ),
    '/photoupload': (context) => const PhotoUpload(),
    '/userview': (context) => const Puente(
          namelocal: 'userview',
        ),
    'changepassword': (context) => const CambiarContrasenaScreen(),
    '/misrecetas': (context) => const Puente(namelocal: 'misrecetas')
  };
}
