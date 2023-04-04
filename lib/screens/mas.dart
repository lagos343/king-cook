import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class mas extends StatelessWidget {
  const mas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
                //Hay que agregar un Sixed Box para que el
                //boton tenga su espacio, el valor es relativo
                height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Pantalla Main'),
            ),
            Image(
                image: NetworkImage(
                    'https://storage.googleapis.com/cms-storage-bucket/a9d6ce81aee44ae017ee.png'))
          ],
        ),
      ),
    );
  }
}
