import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Resultado")),
      body: resultados.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¿Te parece nutritivo el contenido de los programas de TV argentinos?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text("Total de participantes: $total"),
                  ...resultados.entries.map(
                    (e) => Text("${e.key}: ${e.value.toInt()} votos"),
                  ),
                  SizedBox(height: 24),
                  resultados.length > 1
                      ? SizedBox(
                          height: 200,
                          child: PieChart(dataMap: resultados),
                        )
                      : Text(
                          "Aún no hay suficientes respuestas para generar una gráfica.",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onSiguiente(); // 👉 Esto debe ir después del pop
                      },
                      child: Text(widget.esUltima ? "Volver al inicio" : "Próxima pregunta"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
