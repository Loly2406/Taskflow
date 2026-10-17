import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Publicacion {
  const Publicacion({
      required this.id,
          required this.titulo,
              required this.cuerpo,
                });

                  final int id;
                    final String titulo;
                      final String cuerpo;

                        factory Publicacion.fromJson(Map<String, dynamic> json) {
                            return Publicacion(
                                  id: json['id'] as int,
                                        titulo: json['title'] as String,
                                              cuerpo: json['body'] as String,
                                                  );
                                                    }
                                                    }

                                                    /// Error con un mensaje entendible para el usuario.
                                                    class ErrorApi implements Exception {
                                                      const ErrorApi(this.mensaje);
                                                        final String mensaje;

                                                          @override
                                                            String toString() => mensaje;
                                                            }

                                                            class PublicacionesApi {
                                                              static const int porPagina = 15;

                                                                Future<List<Publicacion>> obtenerPagina(int pagina) async {
                                                                    final uri = Uri.parse(
                                                                          'https://jsonplaceholder.typicode.com/posts?_page=$pagina&_limit=$porPagina',
                                                                              );
                                                                                  try {
                                                                                        final respuesta = await http.get(uri).timeout(
                                                                                                    const Duration(seconds: 10),
                                                                                                              );
                                                                                                                    if (respuesta.statusCode != 200) {
                                                                                                                            throw ErrorApi(
                                                                                                                                      'El servidor tuvo un problema (código ${respuesta.statusCode}). '
                                                                                                                                                'Intenta de nuevo.',
                                                                                                                                                        );
                                                                                                                                                              }
                                                                                                                                                                    final datos = jsonDecode(respuesta.body) as List<dynamic>;
                                                                                                                                                                          return datos
                                                                                                                                                                                    .map((e) => Publicacion.fromJson(e as Map<String, dynamic>))
                                                                                                                                                                                              .toList();
                                                                                                                                                                                                  } on SocketException {
                                                                                                                                                                                                        throw const ErrorApi(
                                                                                                                                                                                                                'No hay conexión a internet. Revisa tu red e intenta de nuevo.',
                                                                                                                                                                                                                      );
                                                                                                                                                                                                                          } on http.ClientException {
                                                                                                                                                                                                                                throw const ErrorApi(
                                                                                                                                                                                                                                        'No hay conexión a internet. Revisa tu red e intenta de nuevo.',
                                                                                                                                                                                                                                              );
                                                                                                                                                                                                                                                  } on TimeoutException {
                                                                                                                                                                                                                                                        throw const ErrorApi(
                                                                                                                                                                                                                                                                'La conexión tardó demasiado. Intenta de nuevo.',
                                                                                                                                                                                                                                                                      );
                                                                                                                                                                                                                                                                          } on FormatException {
                                                                                                                                                                                                                                                                                throw const ErrorApi('Recibimos datos que no se pudieron leer.');
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                      }
                                                                                                                                                                                                                                                                                      }