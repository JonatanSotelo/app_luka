
import 'package:flutter/material.dart';
import 'package:encuesta_app/pantalla_preguntas.dart';
import 'package:encuesta_app/api_service.dart';

class PantallaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final preguntas = await ApiService.obtenerPreguntas();

                if (preguntas.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PantallaPreguntas(preguntas: preguntas),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudieron cargar las preguntas')),
                  );
                }
              },
              child: Text("Responder preguntas"),
            ),
          ],
        ),
      ),
    );
  }
}
