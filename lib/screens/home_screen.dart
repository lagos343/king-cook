import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kingcook/screens/photo_upload.dart';
import 'package:kingcook/screens/posts.dart';
import 'package:kingcook/users.dart';
import 'package:expandable/expandable.dart';

bool _showDetails =
    false; //variable que verifica si se muestra todo el contenido
var texto = "ver mas";

class HomePage extends StatefulWidget {
  final bool ismyRecipes;
  const HomePage({super.key, required this.ismyRecipes});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = []; //lista de Comidas o Recetas

  @override
  void initState() {
    super.initState();
    //extracion de la informacion de la base de datos y llenado de la lista de Posts usando la clase
    if (widget.ismyRecipes) {
      FirebaseFirestore.instance
          .collection('Posts')
          .where('user', isEqualTo: Usuarios.email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Posts post = Posts(
              image: doc['image'],
              description: doc['description'],
              date: doc['date'],
              time: doc['time'],
              name: doc['name'],
              ingre1: doc['ingre1'],
              ingre2: doc['ingre2'],
              ingre3: doc['ingre3'],
              ingre4: doc['ingre4'],
              pasos: doc['pasos']);
          postList.add(post);
        });
        setState(() {
          print("${postList.length}");
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('Posts')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Posts post = Posts(
              image: doc['image'],
              description: doc['description'],
              date: doc['date'],
              time: doc['time'],
              name: doc['name'],
              ingre1: doc['ingre1'],
              ingre2: doc['ingre2'],
              ingre3: doc['ingre3'],
              ingre4: doc['ingre4'],
              pasos: doc['pasos']);
          postList.add(post);
        });
        setState(() {
          print("${postList.length}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: !widget.ismyRecipes
              ? Center(child: Text("King Cook"))
              : Center(child: Text("Mis Recetas")),
          backgroundColor: Color.fromRGBO(0, 131, 143, 1),
        ),
        body: Container(
          //container que alvergara la interfa grafica
          child: postList.length == 0
              ? Center(child: Text("No hay recetas aun"))
              : ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (_, index) {
                    ///si la lista tiene registros se llama a la funcion
                    ///que crea cada uno de los posts con recetas mandandole por
                    ///parametro la informacion
                    return postsUI(
                        postList[index].image,
                        postList[index].description,
                        postList[index].date,
                        postList[index].time,
                        postList[index].name,
                        postList[index].ingre1,
                        postList[index].ingre2,
                        postList[index].ingre3,
                        postList[index].ingre4,
                        postList[index].pasos);
                  },
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          //boton que se encarga de ir a la pantalla para subir posts
          color: const Color.fromRGBO(0, 131, 143, 1),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/photoupload');
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget postsUI(
      //funcion que crea los posts
      String image,
      String description,
      String date,
      String time,
      String name,
      String ingre1,
      String ingre2,
      String ingre3,
      String ingre4,
      String pasos) {
    ///verificamos si mostramos o no toda la informacion
    ///en caso que si se llama una funcionque muestra toda la informacion
    ///en caso que no solo se muestra cierta informacion

    return Card(
        margin: EdgeInsets.all(14.0),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Image.network(image, fit: BoxFit.cover),
              SizedBox(
                height: 10.0,
              ),
              ExpandablePanel(
                  header: Text(
                    name,
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.left,
                  ),
                  collapsed:
                      cartaPequenia(date, time, image, name, description),
                  expanded: cartaGrande(date, time, image, name, description,
                      ingre1, ingre2, ingre3, ingre4, pasos)),
            ],
          ),
        ));
    // if (_showDetails == true) {
    //   return cartaGrande(date, time, image, name, description, ingre1, ingre2,
    //       ingre3, ingre4, pasos);
    // } else {
    //   return cartaPequenia(date, time, image, name, description);
    // }
  }

  Widget cartaGrande(
      String date,
      String time,
      String image,
      String name,
      String description,
      String ingre1,
      String ingre2,
      String ingre3,
      String ingre4,
      String pasos) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10.0,
          ),
          //ingredientes
          Text(
            "Ingredientes:",
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "- $ingre1 \n- $ingre2 \n- $ingre3 \n- $ingre4",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10.0,
          ),
          //pasos
          Text(
            "Pasos:",
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            pasos,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget cartaPequenia(
      String date, String time, String image, String name, String description) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
