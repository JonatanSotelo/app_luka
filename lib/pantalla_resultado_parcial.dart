
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'pantalla_preguntas.dart';
import 'pantalla_resultado_individual.dart';

class PantallaResultadoParcial extends StatelessWidget {
  final int preguntaIndex;
  final List<Map<String, dynamic>> preguntas;
  final Map<int, String> respuestas;

  PantallaResultadoParcial({
    required this.preguntaIndex,
    required this.preguntas,
    required this.respuestas,
  });

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntas[preguntaIndex];
    final opciones = ['Sí', 'No', 'No sé'];

    return Scaffold(
      appBar: AppBar(title: Text('Resultados Parciales')),
      body: FutureBuilder<Map<String, Map<String, int>>>(
        future: ApiService.obtenerRespuestas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.containsKey(pregunta['id'].toString())) {
            return Center(child: Text('No hay datos disponibles.'));
          }

          final datos = snapshot.data![pregunta['id'].toString()]!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pregunta['texto'], style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ...opciones.map((opcion) {
                final cantidad = datos[opcion] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('$opcion: $cantidad respuestas'),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (preguntaIndex + 1 < preguntas.length) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaPreguntas(
                          preguntas: preguntas,
                          preguntaActual: preguntaIndex + 1,
                          respuestas: respuestas,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaResultadoIndividual(respuestas: respuestas),
                      ),
                    );
                  }
                },
                child: Text('Próxima pregunta'),
              ),
            ],
          );
        },
      ),
    );
  }
}
