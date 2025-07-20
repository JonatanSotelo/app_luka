import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class PantallaResultados extends StatefulWidget {
  final Map<int, String> respuestas;

  PantallaResultados({required this.respuestas});

  @override
  _PantallaResultadosState createState() => _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  Map<String, Map<String, int>> estadisticas = {};

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {
    final url = Uri.parse('https://app-luka.onrender.com/estadisticas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        estadisticas = Map<String, Map<String, int>>.from(
          json.decode(response.body).map(
            (k, v) => MapEntry(k, Map<String, int>.from(v)),
          ),
        );
      });
    } else {
      print("❌ Error al cargar estadísticas");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (estadisticas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Resultados")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Resultados")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ...estadisticas.entries.map((entry) {
            final preguntaId = entry.key;
            final opciones = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pregunta $preguntaId",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 200, child: PieChart(dataMap: opciones.map((k, v) => MapEntry(k, v.toDouble())))),
                SizedBox(height: 32),
              ],
            );
          }).toList(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Volver al inicio"),
            ),
          ),
        ],
      ),
    );
  }
}
