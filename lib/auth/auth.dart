import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kingcook/users.dart';

class Auth {
  Future<bool> authUser(String email, String password) async {
    bool result = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .where("contrasenia", isEqualTo: password)
        .get();
    result = querySnapshot.docs.isNotEmpty;

    if (result) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final usersQuery = usersCollection.where('email', isEqualTo: email);
      final usersSnapshot = await usersQuery.get();

      final Map<dynamic, dynamic> usuario = usersSnapshot.docs.first.data();
      Usuarios.email = usuario['email'].toString();
      Usuarios.contrasenia = usuario['contrasenia'].toString();
      Usuarios.nombre = usuario['nombre'].toString();
    }
    return result;
  }

  Future<bool> registerUser(
      String email, String nombre, String contrasenia) async {
    bool result = false;

    Map<String, dynamic> data = {
      'email': email,
      'nombre': nombre,
      'contrasenia': contrasenia
    };

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: contrasenia,
      );
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('users').add(data);
      print('Document added with ID: ${documentReference.id}');
      result = true;
    } catch (error) {
      print('Error registering user: $error');
    }
    return result;
  }
}
