import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PantallaPreguntas extends StatefulWidget {
  @override
  _PantallaPreguntasState createState() => _PantallaPreguntasState();
}

class _PantallaPreguntasState extends State<PantallaPreguntas> {
  List preguntas = [];
  Map<int, String> respuestas = {};
  int preguntaActual = 0;

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    final url = Uri.parse('https://app-luka.onrender.com/preguntas'); // Cambiar luego
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        preguntas = json.decode(response.body);
      });
    } else {
      print('Error al cargar preguntas');
    }
  }

  void guardarRespuesta(String respuesta) {
    setState(() {
      respuestas[preguntaActual] = respuesta;
      if (preguntaActual < preguntas.length - 1) {
        preguntaActual++;
      } else {
        // Aquí podrías navegar a otra pantalla o enviar al backend
        print("Respuestas: $respuestas");
        // Navigator.push(...)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (preguntas.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pregunta = preguntas[preguntaActual];

    return Scaffold(
      appBar: AppBar(title: Text("Pregunta ${preguntaActual + 1} de ${preguntas.length}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(pregunta['texto'], style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...(pregunta['opciones'] as List).map((opcion) {
              return ElevatedButton(
                onPressed: () => guardarRespuesta(opcion),
                child: Text(opcion),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
