import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'pantalla_preguntas.dart';
import 'pantalla_inicio.dart';

class PantallaResultadoIndividual extends StatefulWidget {
  final int preguntaIndex;
  final int totalPreguntas;
  final Map<int, String> respuestas;

  PantallaResultadoIndividual({
    required this.preguntaIndex,
    required this.totalPreguntas,
    required this.respuestas,
  });

  @override
  _PantallaResultadoIndividualState createState() => _PantallaResultadoIndividualState();
}

class _PantallaResultadoIndividualState extends State<PantallaResultadoIndividual> {
  Map<String, double> dataMap = {};
  int totalVotos = 0;

  @override
  void initState() {
    super.initState();
    cargarEstadistica();
  }

  Future<void> cargarEstadistica() async {
    final url = Uri.parse('https://app-luka.onrender.com/estadisticas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final Map<String, dynamic> preguntaStats = jsonData["${widget.preguntaIndex}"] ?? {};

      Map<String, double> map = {};
      int votos = 0;

      preguntaStats.forEach((key, value) {
        map[key] = (value as int).toDouble();
        votos += value;
      });

      setState(() {
        dataMap = map;
        totalVotos = votos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resultados")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: dataMap.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text(
                    "Participantes: \$totalVotos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(child: PieChart(dataMap: dataMap)),
                  SizedBox(height: 24),
                  if (widget.preguntaIndex < widget.totalPreguntas - 1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaPreguntas(),
                          ),
                        );
                      },
                      child: Text("Próxima pregunta"),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PantallaInicio(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text("Volver al inicio"),
                    ),
                ],
              ),
      ),
    );
  }
}