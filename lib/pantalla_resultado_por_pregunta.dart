import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'pantalla_preguntas.dart';

class PantallaResultadoPorPregunta extends StatefulWidget {
  final String preguntaId;
  final bool esUltima;
  final VoidCallback onSiguiente;

  PantallaResultadoPorPregunta({
    required this.preguntaId,
    required this.esUltima,
    required this.onSiguiente,
  });

  @override
  _PantallaResultadoPorPreguntaState createState() => _PantallaResultadoPorPreguntaState();
}

class _PantallaResultadoPorPreguntaState extends State<PantallaResultadoPorPregunta> {
  Map<String, double> resultados = {};
  int total = 0;

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {
    final url = Uri.parse('https://app-luka.onrender.com/estadisticas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mapa = Map<String, int>.from(data[widget.preguntaId] ?? {});
      setState(() {
        resultados = mapa.map((k, v) => MapEntry(k, v.toDouble()));
        total = mapa.values.fold(0, (a, b) => a + b);
      });
    } else {
      print("❌ Error al cargar estadísticas");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (resultados.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Resultados")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Resultados de la pregunta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Participaron $total personas", style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Expanded(child: PieChart(dataMap: resultados)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.esUltima) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  widget.onSiguiente();
                  Navigator.pop(context);
                }
              },
              child: Text(widget.esUltima ? "Volver al inicio" : "Siguiente pregunta"),
            ),
          ],
        ),
      ),
    );
  }
}
