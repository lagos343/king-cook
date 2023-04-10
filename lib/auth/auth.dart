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

      Usuarios.id = usersSnapshot.docs.first.id.toString();

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

  Future<bool> changePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      // Iniciar sesión con el correo y contraseña actual
      var credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Autenticación exitosa, se puede cambiar la contraseña y actualizar el documento
        await userCredential.user!.updatePassword(newPassword);

        //actualizacion del doc
        final DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(Usuarios.id);
        await userDocRef.update({
          'email': email,
          'nombre': Usuarios.nombre,
          'contrasenia': newPassword
        });

        // Si no hubo errores, retornar true
        return true;
      } else {
        // El usuario no está autenticado
        print('Usuario no autenticado');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Si hubo algún error en la autenticación
      print('Error al cambiar la contraseña: $e');
      return false;
    } catch (e) {
      // Otro tipo de error
      print('Error al cambiar la contraseña: $e');
      return false;
    }
  }
}
