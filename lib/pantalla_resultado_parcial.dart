import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PantallaResultadoParcial extends StatefulWidget {
  final int preguntaIndex;
  final int totalPreguntas;

  PantallaResultadoParcial({
    required this.preguntaIndex,
    required this.totalPreguntas,
  });

  @override
  _PantallaResultadoParcialState createState() => _PantallaResultadoParcialState();
}

class _PantallaResultadoParcialState extends State<PantallaResultadoParcial> {
  Map<String, int> conteo = {};
  int totalVotos = 0;
  String preguntaTexto = "";
  bool cargando = true;

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
        final preguntas =
            List<dynamic>.from(json.decode(preguntasResponse.body));

        setState(() {
          conteo = Map<String, int>.from(
              estadisticas[widget.preguntaIndex.toString()] ?? {});
          totalVotos = conteo.values.fold(0, (sum, val) => sum + val);
          preguntaTexto = preguntas[widget.preguntaIndex]['texto'];
          cargando = false;
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
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preguntaTexto,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...conteo.entries.map((entry) {
                    final porcentaje = totalVotos == 0
                        ? 0
                        : (entry.value / totalVotos * 100).toStringAsFixed(1);
                    return Text("${entry.key}: ${entry.value} votos ($porcentaje%)");
                  }),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Siguiente pregunta"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
