import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pantalla_resultado_parcial.dart';
import 'pantalla_inicio.dart';

class PantallaPreguntas extends StatefulWidget {
  @override
  _PantallaPreguntasState createState() => _PantallaPreguntasState();
}

class _PantallaPreguntasState extends State<PantallaPreguntas> {
  List<dynamic> preguntas = [];
  int preguntaActual = 0;
  Map<int, String> respuestas = {};

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    final url = Uri.parse('https://app-luka.onrender.com/preguntas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        preguntas = json.decode(response.body);
        preguntaActual = 0;
        respuestas.clear();
      });
    } else {
      print('❌ Error al cargar preguntas');
    }
  }

  Future<void> responder(String opcion) async {
    respuestas[preguntaActual] = opcion;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaResultadoParcial(
          preguntaIndex: preguntaActual,
          totalPreguntas: preguntas.length,
        ),
      ),
    );

    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PantallaInicio()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (preguntas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Cargando...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pregunta = preguntas[preguntaActual]['texto'];

    return Scaffold(
      appBar: AppBar(title: Text("Encuesta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              pregunta,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => responder("Sí"),
              child: Text("Sí"),
            ),
            ElevatedButton(
              onPressed: () => responder("No"),
              child: Text("No"),
            ),
            ElevatedButton(
              onPressed: () => responder("No sé"),
              child: Text("No sé"),
            ),
          ],
        ),
      ),
    );
  }
}