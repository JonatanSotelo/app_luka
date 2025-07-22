import 'package:flutter/material.dart';
import 'api_service.dart';

class PantallaResultadoParcial extends StatefulWidget {
  final int preguntaId;
  final String preguntaTexto;

  PantallaResultadoParcial({
    required this.preguntaId,
    required this.preguntaTexto,
  });

  @override
  _PantallaResultadoParcialState createState() =>
      _PantallaResultadoParcialState();
}

class _PantallaResultadoParcialState extends State<PantallaResultadoParcial> {
  Map<String, dynamic> estadisticas = {};
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
  }

  Future<void> _cargarEstadisticas() async {
    try {
      final datos = await ApiService.obtenerEstadisticas();
      setState(() {
        estadisticas = datos[widget.preguntaId.toString()] ?? {};
        cargando = false;
      });
    } catch (e) {
      print("❌ Error al cargar estadísticas: $e");
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.preguntaTexto,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ...estadisticas.entries.map((entry) {
                    final opcion = entry.key;
                    final cantidad = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(opcion, style: const TextStyle(fontSize: 16)),
                          Text("$cantidad respuestas"),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true); // Volver a la siguiente pregunta
                    },
                    child: const Text("Siguiente pregunta"),
                  ),
                ],
              ),
      ),
    );
  }
}
