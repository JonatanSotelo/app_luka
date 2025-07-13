import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pantalla_resultados.dart'; // ⬅️ importante

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
    final url = Uri.parse('https://app-luka.onrender.com/preguntas');
    try {
      final response = await http.get(url);

      print('Respuesta: ${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          preguntas = json.decode(response.body);
        });
      } else {
        print('Error al cargar preguntas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }

  void guardarRespuesta(String respuesta) {
    respuestas[preguntaActual] = respuesta;
    if (preguntaActual < preguntas.length - 1) {
      setState(() {
        preguntaActual++;
      });
    } else {
      enviarRespuestas(respuestas).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaResultados(respuestas: respuestas),
          ),
        );
      });
    }
  }

  Future<void> enviarRespuestas(Map<int, String> respuestas) async {
    final url = Uri.parse('https://app-luka.onrender.com/responder');
    try {
      final body = jsonEncode(
          respuestas.map((k, v) => MapEntry(k.toString(), v))); // convertir claves a string
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print("🔁 Respuesta del backend: ${response.body}");
    } catch (e) {
      print("❌ Error al enviar respuestas: $e");
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

    final pregunta = preguntas[preguntaActual];

    return Scaffold(
      appBar: AppBar(
        title: Text("Pregunta ${preguntaActual + 1} de ${preguntas.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pregunta['texto'],
              style: TextStyle(fontSize: 20),
            ),
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
