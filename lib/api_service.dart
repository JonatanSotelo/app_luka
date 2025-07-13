import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://app-luka.onrender.com/';

  static Future<List> obtenerPreguntas() async {
    final response = await http.get(Uri.parse('$baseUrl/preguntas'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener preguntas');
    }
  }
}
