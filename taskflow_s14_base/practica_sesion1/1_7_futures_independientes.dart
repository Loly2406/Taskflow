// ignore_for_file: avoid_print
// SEMANA 14 - SESIÓN 1 (sección 1.7)
//
//  1. Ejecuta y anota ambos tiempos en tu bitácora.
//  2. Cambia cargarPendientes para que NECESITE el perfil:
//       Future<int> cargarPendientes(String perfil)
//     ¿Puedes seguir usando .wait? Explica por qué.
//
//   dart run practica_sesion1/1_7_futures_independientes.dart
import 'dart:async';

Future<String> cargarPerfil() =>
    Future.delayed(const Duration(seconds: 2), () => 'Ana');

Future<int> cargarPendientes(String perfil) =>
    Future.delayed(const Duration(seconds: 3), () => 7);

Future<void> main() async {
  final reloj = Stopwatch()..start();

  // 1) Secuencial
  final perfil = await cargarPerfil();
  final pendientes = await cargarPendientes(perfil);
  print('Secuencial: ${reloj.elapsed.inSeconds} s -> $perfil, $pendientes');

  reloj.reset();

  // 2) Concurrente (record de Dart 3 con .wait)
  final (perfil2, pendientes2) = await (cargarPerfil(), cargarPendientes()).wait;
  print('Concurrente: ${reloj.elapsed.inSeconds} s -> $perfil2, $pendientes2');
}
