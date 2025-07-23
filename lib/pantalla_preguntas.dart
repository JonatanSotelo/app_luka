
import 'package:flutter/material.dart';
import 'pantalla_resultado_parcial.dart';

class PantallaPreguntas extends StatefulWidget {
  final List<Map<String, dynamic>> preguntas;

  PantallaPreguntas({required this.preguntas});

  @override
  _PantallaPreguntasState createState() => _PantallaPreguntasState();
}

class _PantallaPreguntasState extends State<PantallaPreguntas> {
  int preguntaActual = 0;

  void responder(String respuesta) {
    final pregunta = widget.preguntas[preguntaActual];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaResultadoParcial(
          preguntaId: pregunta['id'],
          preguntaTexto: pregunta['texto'],
        ),
      ),
    ).then((_) {
      if (preguntaActual < widget.preguntas.length - 1) {
        setState(() {
          preguntaActual++;
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = widget.preguntas[preguntaActual];

    return Scaffold(
      appBar: AppBar(title: Text("Pregunta ${preguntaActual + 1}")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pregunta['texto'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List<Widget>.from(
              (pregunta['opciones'] as List<dynamic>).map(
                (opcion) => ElevatedButton(
                  onPressed: () => responder(opcion),
                  child: Text(opcion),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
