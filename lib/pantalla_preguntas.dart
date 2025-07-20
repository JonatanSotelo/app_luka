import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pantalla_resultado_por_pregunta.dart';

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

  void responder(String opcion) async {
    respuestas[preguntaActual] = opcion;

    final preguntaId = preguntaActual.toString();

    await http.post(
      Uri.parse('https://app-luka.onrender.com/responder'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({preguntaId: opcion}),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaResultadoPorPregunta(
          preguntaId: preguntaId,
          esUltima: preguntaActual == preguntas.length - 1,
          onSiguiente: () {
            if (preguntaActual < preguntas.length - 1) {
              setState(() {
                preguntaActual++;
              });
            }
          },
        ),
      ),
    );
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
      appBar: AppBar(title: Text("Pregunta ${preguntaActual + 1}/${preguntas.length}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(pregunta, style: TextStyle(fontSize: 20)),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () => responder("Sí"), child: Text("Sí")),
            ElevatedButton(onPressed: () => responder("No"), child: Text("No")),
            ElevatedButton(onPressed: () => responder("No sé"), child: Text("No sé")),
          ],
        ),
      ),
    );
  }
}
