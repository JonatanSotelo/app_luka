
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'pantalla_preguntas.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  bool _cargando = false;

  Future<void> _cargarPreguntas() async {
    setState(() {
      _cargando = true;
    });

    try {
      final preguntas = await ApiService.obtenerPreguntas();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PantallaPreguntas(preguntas: List<Map<String, dynamic>>.from(preguntas)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar preguntas: \$e')),
      );
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Encuesta')),
      body: Center(
        child: _cargando
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _cargarPreguntas,
                child: Text('Responder preguntas'),
              ),
      ),
    );
  }
}
