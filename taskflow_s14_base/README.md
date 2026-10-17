# TaskFlow · Proyecto base de la Semana 14

Punto de partida para la actividad de la **Semana 14: Programación asíncrona y consumo de APIs REST**.
Contiene TaskFlow tal como queda al cerrar la Semana 13. La actividad de esta semana **no está resuelta**: los archivos marcados con `TODO` indican dónde trabajar, siguiendo los pasos de la página de Canvas.

## Cómo ejecutarlo

```bash
flutter create . --project-name taskflow   # genera android/, ios/, web/... (no toca lib/ ni test/)
flutter pub get
flutter run
flutter test
```

Requiere **Flutter 3.35 o superior**. Si tienes una versión anterior, cambia `initialValue:` por `value:` en `lib/pantallas/nueva_tarea_screen.dart`.

## Lo que ya funciona (Semanas 3 a 13)

- Modelo `Tarea` con encapsulamiento de la prioridad.
- Estado local con Riverpod (`taskProvider`): agregar, completar y eliminar tareas.
- Pantalla **Nueva tarea** con formulario validado que devuelve la tarea con `Navigator.pop`.
- Validadores puros (`ValidadoresTarea`) y sus pruebas en `test/`.

## Lo que harás esta semana

### Sesión 1 — Asincronía en Dart

| Sección | Archivo | Qué hacer |
|---|---|---|
| 1.3 | `practica_sesion1/1_3_orden_ejecucion.dart` | Predecir el orden y luego ejecutar con `dart run`. |
| 1.6 | `practica_sesion1/1_6_await_olvidado.dart` | Encontrar y corregir el error; activar `unawaited_futures`. |
| 1.7 | `practica_sesion1/1_7_futures_independientes.dart` | Medir los tiempos y responder la pregunta sobre `.wait`. |
| 1.8 | `lib/practica/experimento_isolate_screen.dart` | Implementar `sinIsolate()` y `conIsolate()`. Se abre con el ícono 🧪 del listado. |

### Sesión 2 — TaskFlow se conecta a una API REST

| Paso | Archivo | Qué hacer |
|---|---|---|
| 3 | `pubspec.yaml`, `AndroidManifest.xml`, `lib/modelos/tarea.dart` | Agregar `http`, el permiso de internet, el campo `id`, `fromJson` y `toJson`. |
| 4–5 | `lib/datos/tareas_api.dart` | Crear `ApiException` y `TareasApi` (GET y POST con manejo de errores). |
| 6 | `lib/estado/tareas_remotas_provider.dart` | Crear los providers y `TareasRemotasNotifier`. |
| 7 | `lib/pantallas/tareas_remotas_screen.dart` y `listado_tareas_screen.dart` | Crear la pantalla «Tareas en la nube» y el botón ☁ que la abre. |
| 9 | — | Probar los cuatro escenarios de fallo y documentarlos. |
| 10 | — | Validar `fromJson` con casos generados por IA y ejecutados por ti. |

**No modifiques** `nueva_tarea_screen.dart` ni `task_provider.dart`: la pantalla de la Semana 13 se reutiliza tal cual, y unir las tareas locales con las remotas es el tema de la Semana 15.

Para ver todos los pendientes en VS Code, busca `TODO(` en el proyecto (Ctrl+Shift+F).
