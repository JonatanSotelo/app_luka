from flask import Flask, request, jsonify
import psycopg2
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# ✅ Conexión a PostgreSQL externa (Render)
conn = psycopg2.connect(
    host="dpg-d1ac4nadbo4c73cbefog-a.oregon-postgres.render.com",
    port=5432,
    dbname="preguntas_json",
    user="preguntas_json_user",
    password="4u8OJ6mNY4vwNjc88VaNbCRtKMRSjG9w"
)
cursor = conn.cursor()

# ✅ Crear tabla si no existe
def crear_tablas():
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS preguntas (
            id SERIAL PRIMARY KEY,
            texto TEXT NOT NULL,
            opciones TEXT[] NOT NULL
        );
    """)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS respuestas (
            id SERIAL PRIMARY KEY,
            pregunta_id INTEGER NOT NULL,
            respuesta TEXT NOT NULL,
            fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)
    conn.commit()

crear_tablas()

@app.route("/")
def index():
    return "✅ Backend Encuesta Luka funcionando."

# 🟩 Obtener preguntas desde la base de datos
@app.route("/preguntas", methods=["GET"])
def obtener_preguntas():
    try:
        cursor.execute("SELECT id, texto, opciones FROM preguntas ORDER BY id;")
        filas = cursor.fetchall()

        preguntas = []
        for fila in filas:
            preguntas.append({
                "id": fila[0],
                "texto": fila[1],
                "opciones": fila[2]
            })

        return jsonify(preguntas)

    except Exception as e:
        print("❌ Error al obtener preguntas:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/responder", methods=["POST"])
def responder():
    data = request.get_json()
    pregunta_id = int(data["pregunta_id"])
    respuesta = data["respuesta"]

    cursor.execute(
        "INSERT INTO respuestas (pregunta_id, respuesta) VALUES (%s, %s);",
        (pregunta_id, respuesta)
    )
    conn.commit()

    return jsonify({"ok": True})

@app.route("/estadisticas", methods=["GET"])
def estadisticas():
    cursor.execute("SELECT pregunta_id, respuesta, COUNT(*) FROM respuestas GROUP BY pregunta_id, respuesta;")
    filas = cursor.fetchall()

    resultado = {}
    for pregunta_id, respuesta, cantidad in filas:
        pid = str(pregunta_id)
        if pid not in resultado:
            resultado[pid] = {}
        resultado[pid][respuesta] = cantidad

    return jsonify(resultado)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
