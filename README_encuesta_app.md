# Proyecto Encuesta Flutter + Backend Flask

Este proyecto es una app de encuesta desarrollada con Flutter (frontend) y un backend en Flask desplegado en Render. A continuación, se resume el funcionamiento y estructura para continuar el desarrollo en caso de cambio de entorno o versión de modelo.

---

## Estructura general

### Flutter App

- `main.dart`: inicia la app y llama a la pantalla de inicio.
- `pantalla_inicio.dart`: muestra botones “Responder preguntas” y “Salir”.
- `pantalla_preguntas.dart`: muestra una pregunta por vez con opciones “Sí”, “No”, “No sé” y al responder muestra un gráfico de resultados inmediato.
- `pantalla_resultados.dart`: muestra un gráfico con resultados de la **última** pregunta respondida, cantidad total de participantes y opción para volver al inicio.

### Backend Flask

- API desarrollada en Flask (Python).
- Rutas:
  - `/preguntas`: devuelve las preguntas desde `preguntas.json`.
  - `/responder`: guarda las respuestas en `respuestas.json`.
  - `/estadisticas`: analiza las respuestas y devuelve estadísticas por pregunta.
- Desplegado en Render.
- Actualmente suspendido por falta de pago.

---

## Flujo de usuario

1. El usuario abre la app y ve la pantalla de inicio.
2. Pulsa “Responder preguntas”.
3. Se le muestra una pregunta y opciones.
4. Al elegir una opción, se guarda la respuesta y se muestra un gráfico circular con los resultados de esa pregunta.
5. Luego puede continuar a la siguiente pregunta.
6. Al llegar a la última pregunta, se muestra su gráfico y un botón para volver al inicio.

---

## Cómo continuar

### 1. Restaurar backend
- Subir nuevamente `preguntas.json` y `respuestas.json` a un backend funcional (Render o alternativa).
- Actualizar la URL en Flutter si se cambia de dominio.

### 2. Subir código a GitHub
```bash
git init
git remote add origin https://github.com/usuario/encuesta_app.git
git add .
git commit -m "Primer commit"
git push -u origin main
```

### 3. Compilar APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```
- El archivo generado estará en: `build/app/outputs/flutter-apk/app-release.apk`

---

## Notas finales

- Los gráficos usan la librería `pie_chart`.
- Se usa `http` para consumir la API REST.
- Los datos son locales (JSON) pero podrían migrarse a base de datos real.

---

_Cualquier modelo GPT-4 puede continuar el proyecto si se adjunta este README.md o el resumen original en .txt_
