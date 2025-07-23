
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://app-luka.onrender.com";

  static Future<List<Map<String, dynamic>>> obtenerPreguntas() async {
    final response = await http.get(Uri.parse("\$baseUrl/preguntas"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Error al cargar preguntas");
    }
  }

  static Future<void> enviarRespuesta(int preguntaId, String respuesta) async {
    await http.post(
      Uri.parse("\$baseUrl/responder"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"pregunta_id": preguntaId, "respuesta": respuesta}),
    );
  }

  static Future<Map<String, dynamic>> obtenerEstadisticas() async {
    final response = await http.get(Uri.parse("\$baseUrl/estadisticas"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar estadísticas");
    }
  }
}
