
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pantalla_inicio.dart';
import 'pantalla_preguntas.dart';

class PantallaResultadoParcial extends StatefulWidget {
  final int preguntaIndex;
  final Map<int, String> respuestas;
  final int totalPreguntas;

  PantallaResultadoParcial({
    required this.preguntaIndex,
    required this.respuestas,
    required this.totalPreguntas,
  });

  @override
  _PantallaResultadoParcialState createState() =>
      _PantallaResultadoParcialState();
}

class _PantallaResultadoParcialState extends State<PantallaResultadoParcial> {
  Map<String, int> conteo = {};
  int totalVotos = 0;
  String preguntaTexto = "";

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {
    final url = Uri.parse('https://app-luka.onrender.com/estadisticas');
    final preguntasUrl = Uri.parse('https://app-luka.onrender.com/preguntas');

    try {
      final estadisticasResponse = await http.get(url);
      final preguntasResponse = await http.get(preguntasUrl);

      if (estadisticasResponse.statusCode == 200 &&
          preguntasResponse.statusCode == 200) {
        final estadisticas =
            Map<String, dynamic>.from(json.decode(estadisticasResponse.body));
        final preguntas = List<dynamic>.from(json.decode(preguntasResponse.body));

        setState(() {
          conteo = Map<String, int>.from(
              estadisticas[widget.preguntaIndex.toString()] ?? {});
          totalVotos = conteo.values.fold(0, (sum, val) => sum + val);
          preguntaTexto = preguntas[widget.preguntaIndex]['texto'];
        });
      }
    } catch (e) {
      print("❌ Error al cargar datos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultado")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: conteo.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    preguntaTexto,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text("Total de participantes: $totalVotos"),
                  ...conteo.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text("${entry.key}: ${entry.value} votos"),
                    );
                  }).toList(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.preguntaIndex < widget.totalPreguntas - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaPreguntas(
                                desdePregunta: widget.preguntaIndex + 1),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaInicio(),
                          ),
                        );
                      }
                    },
                    child: Text(widget.preguntaIndex < widget.totalPreguntas - 1
                        ? "Próxima pregunta"
                        : "Finalizar y volver al inicio"),
                  )
                ],
              ),
      ),
    );
  }
}
