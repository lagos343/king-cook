import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {

  bool authUser(String email, String password){
    bool result = false;
      DocumentReference documentReference = FirebaseFirestore.instance.collection('users').where("email","==",email).where("contrasenia","==",password);
      documentReference.get().then((DocumentSnapshot documentSnapshot) {
    result= documentSnapshot.exists;
    }).catchError((error) {
      print('Error getting document: $error');
    });
  return result;
  }

  Future<bool> registerUser(Usuarios user){
    bool result = false;

    Map<String, dynamic> data = {
      'email': user.email,
      'nombre': user.nombre,
      'contrasenia':user.contrasenia
    };
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email,
      password: user.contrasenia,
    );
    collectionReference.add(data).then((DocumentReference documentReference) {
      print('Document added with ID: ${documentReference.id}');
      resultado = true;
    }).catchError((error) {
    print('Error adding document: $error');
    });
  return result;
  }
}
