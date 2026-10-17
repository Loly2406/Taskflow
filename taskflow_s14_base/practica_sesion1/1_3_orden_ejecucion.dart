// ignore_for_file: avoid_print
// SEMANA 14 - SESIÓN 1 (sección 1.3)
//
// ANTES de ejecutar, escribe en tu bitácora el orden en que crees que
// aparecerán los mensajes. Luego ejecuta desde la carpeta del proyecto:
//
//   dart run practica_sesion1/1_3_orden_ejecucion.dart
import 'dart:async';

void main() {
  print('A. inicio de main');

  Future(() => print('B. evento (cola de eventos)'));

  scheduleMicrotask(() => print('C. microtarea'));

  Future.delayed(Duration.zero, () => print('D. temporizador de 0 ms'));

  print('E. fin de main');
}
