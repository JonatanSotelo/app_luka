import 'package:flutter/material.dart';
import '../app_luka_backend/pantalla_preguntas.dart';

void main() {
  runApp(EncuestaApp());
}

class EncuestaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuesta Beta',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PantallaPreguntas(),
    );
  }
}
