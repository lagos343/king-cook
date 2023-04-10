import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:kingcook/screens/home_screen.dart';
import 'package:kingcook/users.dart';

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({super.key});
  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  var sampleImage; // imagen
  // ignore: prefer_typing_uninitialized_variables
  late var _myValue; // descripcion
  late String url; // url de la imagen
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subir Receta"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(0, 131, 143, 1),
      ),
      body: Center(
        child: sampleImage == null
            ? const Text("Selecionar una Imagen")
            : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Color.fromRGBO(0, 131, 143, 1),
        tooltip: "Añadir Imagen",
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();

    var tempImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (tempImage != null) {
        sampleImage = File(tempImage.path);
      }
    });
  }

  Widget enableUpload() {
    return SingleChildScrollView(
        child: Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              sampleImage != null
                  ? Image.file(
                      sampleImage,
                      height: 300.0,
                      width: 600.0,
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: "Descripcion de la receta"),
                validator: (value) {
                  return value != null && value.isEmpty
                      ? "Ingrese la descripcion de la receta"
                      : null;
                },
                onSaved: (value) {
                  if (value != null) {
                    // Verificar si value es nulo antes de asignarlo
                    _myValue = value;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(0, 131, 143, 1),
                  elevation: 10.0,
                ),
                onPressed: () {
                  // Realiza una acción al presionar el botón
                  uploadStatusImage();
                },
                child: Text(
                  'Añadir una nueva receta',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      // Mostrar un dialogo con una barra de carga
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Subiendo la receta...'),
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

      // Subir imagen a firebase storage
      var timeKey = DateTime.now();
      final Reference postImageRef =
          FirebaseStorage.instance.ref('Post Images').child('$timeKey.jpg');
      final UploadTask uploadTask = postImageRef.putFile(sampleImage);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image url: " + url);
      saveToDatabase(url);

      // Cerrar el dialogo y regresar a Home
      Navigator.pop(context); // Cerrar el dialogo
      Navigator.pushReplacementNamed(context, '/puente');
    }
  }

  void saveToDatabase(String url) {
    // Guardar un post (image, descripcion, date, time)
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat.yMMMMd('es_ES');
    var formatTime = DateFormat('HH:mm');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    //instancia de la clase Users

    var ref = FirebaseFirestore.instance;
    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
      "user": Usuarios.email,
      "name": Usuarios.nombre
    };

    ref.collection("Posts").add(data);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
