from flask import Flask, jsonify, request
from flask_cors import CORS
import os, json
from collections import defaultdict

app = Flask(__name__)
CORS(app)

RESPUESTAS_FILE = "respuestas.json"

@app.route("/")
def home():
    return "✅ API de Encuesta Activa"

@app.route("/preguntas")
def preguntas():
    try:
        ruta = os.path.join(os.path.dirname(__file__), "preguntas.json")
        print("📂 Leyendo archivo:", ruta)

        with open(ruta, "r", encoding="utf-8") as f:
            data = json.load(f)

        print("✅ Archivo cargado correctamente")
        return jsonify(data)

    except Exception as e:
        print("❌ Error al leer preguntas.json:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/responder", methods=["POST"])
def guardar_respuestas():
    try:
        nuevas_respuestas = request.get_json()

        try:
            if os.path.exists(RESPUESTAS_FILE) and os.path.getsize(RESPUESTAS_FILE) > 0:
                with open(RESPUESTAS_FILE, "r", encoding="utf-8") as f:
                    respuestas_existentes = json.load(f)
            else:
                respuestas_existentes = []
        except Exception as e:
            print("❌ Error leyendo respuestas.json:", e)
            respuestas_existentes = []

        respuestas_existentes.append(nuevas_respuestas)

        with open(RESPUESTAS_FILE, "w", encoding="utf-8") as f:
            json.dump(respuestas_existentes, f, ensure_ascii=False, indent=2)

        return jsonify({"mensaje": "Respuestas guardadas correctamente"}), 200

    except Exception as e:
        print("❌ Error al guardar respuestas:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/estadisticas", methods=["GET"])
def estadisticas():
    try:
        if not os.path.exists(RESPUESTAS_FILE) or os.path.getsize(RESPUESTAS_FILE) == 0:
            return jsonify({})  # Si no hay respuestas todavía

        with open(RESPUESTAS_FILE, "r", encoding="utf-8") as f:
            respuestas = json.load(f)

        conteo = defaultdict(lambda: defaultdict(int))

        for respuesta in respuestas:
            for pregunta_id, opcion in respuesta.items():
                conteo[pregunta_id][opcion] += 1

        resultado = {pid: dict(opciones) for pid, opciones in conteo.items()}
        return jsonify(resultado)

    except Exception as e:
        print("❌ Error al calcular estadísticas:", e)
        return jsonify({"error": str(e)}), 500

# 🔥 Esta línea inicia el servidor
if __name__ == "__main__":
    app.run(debug=True)
