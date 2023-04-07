import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kingcook/screens/photo_upload.dart';
import 'package:kingcook/screens/posts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('Posts').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Posts post = Posts(
            image: doc['image'],
            description: doc['description'],
            date: doc['date'],
            time: doc['time'],
            name: doc['name']);
        postList.add(post);
      });
      setState(() {
        print("${postList.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("King Cook")),
          backgroundColor: Color.fromRGBO(0, 131, 143, 1),
        ),
        body: Container(
          child: postList.length == 0
              ? Center(child: Text("No hay recetas aun"))
              : ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (_, index) {
                    return postsUI(
                        postList[index].image,
                        postList[index].description,
                        postList[index].date,
                        postList[index].time,
                        postList[index].name);
                  },
                ),
        ),
        bottomNavigationBar: BottomAppBar(
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
      String image, String description, String date, String time, String name) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            Text(
              name,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }
}
