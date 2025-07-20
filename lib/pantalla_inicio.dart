import 'package:flutter/material.dart';
import 'pantalla_preguntas.dart';

class PantallaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaPreguntas()),
                );
              },
              child: Text("Responder preguntas"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // En Android, esto no cierra la app, pero simula salir.
                Navigator.pop(context);
              },
              child: Text("Salir"),
            ),
          ],
        ),
      ),
    );
  }
}