// SEMANA 14 - SESIÓN 2 (Pasos 4 y 5): servicio TareasApi.
//
// Antes de empezar:
//   1. flutter pub add http
//   2. Agrega el permiso de internet en
//      android/app/src/main/AndroidManifest.xml (Paso 3).
//   3. Agrega a Tarea el campo `id`, `fromJson` y `toJson` (Paso 3).
//
// TODO(Paso 4): crea la clase ApiException (mensaje + código opcional).
//
// TODO(Paso 4): crea la clase TareasApi que reciba un http.Client
//               por constructor y tenga:
//   - Future<List<Tarea>> obtenerTareas()   -> GET  /todos?_limit=15
//   - Future<Tarea> crearTarea(Tarea tarea) -> POST /todos (espera 201)
//   - un método privado que aplique .timeout(...) y convierta
//     TimeoutException y http.ClientException en ApiException.
//
// TODO(Paso 5): verifica que cada fallo de la tabla del Paso 5 termine
//               en una ApiException con un mensaje comprensible.
//
// Regla de diseño: las pantallas NUNCA importan el paquete http;
// toda la comunicación con el servidor vive en este archivo.
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/tarea.dart';

class ApiException implements Exception {
  final String mensaje;
  final int? codigo;

  ApiException(this.mensaje, [this.codigo]);

  @override
  String toString() => mensaje;
}

class TareasApi {
  TareasApi(this._client);

  final http.Client _client;
  static const _base = 'https://jsonplaceholder.typicode.com';
  static const _limite = Duration(seconds: 10);

  Future<http.Response> _enviar(
    Future<http.Response> Function() peticion,
  ) async {
    try {
      return await peticion().timeout(_limite);
    } on TimeoutException {
      throw ApiException('El servidor tardó demasiado en responder.');
    } on http.ClientException {
      throw ApiException('No fue posible conectar con el servidor. Revisa tu conexión a internet.');
    }
  }

  Future<List<Tarea>> obtenerTareas() async {
    final respuesta = await _enviar(
      () => _client.get(Uri.parse('$_base/todos?_limit=15')),
    );
    if (respuesta.statusCode != 200) {
      throw ApiException(
        'El servidor respondió con un error (${respuesta.statusCode}).',
        respuesta.statusCode,
      );
    }
    try {
      final datos = jsonDecode(respuesta.body) as List<dynamic>;
      return datos
          .map((e) => Tarea.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw ApiException('La respuesta del servidor no es válida.');
    } on TypeError {
      throw ApiException('La respuesta del servidor no es válida.');
    }
  }

  Future<Tarea> crearTarea(Tarea tarea) async {
    final respuesta = await _enviar(
      () => _client.post(
        Uri.parse('$_base/todos'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(tarea.toJson()),
      ),
    );
    if (respuesta.statusCode != 201) {
      throw ApiException(
        'No se pudo crear la tarea (${respuesta.statusCode}).',
        respuesta.statusCode,
      );
    }
    try {
      final json = jsonDecode(respuesta.body) as Map<String, dynamic>;
      tarea.id = json['id'] as int?;
      return tarea;
    } on FormatException {
      throw ApiException('La respuesta del servidor no es válida.');
    } on TypeError {
      throw ApiException('La respuesta del servidor no es válida.');
    }
  }
}
