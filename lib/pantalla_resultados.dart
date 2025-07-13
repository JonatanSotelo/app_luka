import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

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
      body: ListView.builder(
        itemCount: estadisticas.length,
        itemBuilder: (context, index) {
          final preguntaId = estadisticas.keys.elementAt(index);
          final opciones = estadisticas[preguntaId]!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pregunta $preguntaId", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 200, child: BarChart(_crearGrafico(opciones))),
              ],
            ),
          );
        },
      ),
    );
  }

  BarChartData _crearGrafico(Map<String, int> opciones) {
    final barGroups = opciones.entries.map((entry) {
      final index = opciones.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChartData(
      barGroups: barGroups,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              final clave = opciones.keys.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(clave, style: TextStyle(fontSize: 12)),
              );
            },
          ),
        ),
      ),
    );
  }
}
