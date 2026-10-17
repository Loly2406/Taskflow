// ignore_for_file: avoid_print
// SEMANA 14 - SESIÓN 1 (sección 1.6)
//
// Este programa tiene un error a propósito.
//  1. Ejecútalo y observa qué se imprime y qué error aparece.
//  2. Corrígelo.
//  3. Activa la regla `unawaited_futures` en analysis_options.yaml y
//     comprueba que `flutter analyze` detecta el problema original.
//
//   dart run practica_sesion1/1_6_await_olvidado.dart

Future<void> guardarTarea(String titulo) async {
  await Future.delayed(const Duration(seconds: 1));
  if (titulo.isEmpty) throw Exception('Título vacío');
  print('Guardada: $titulo');
}

Future<void> alPresionarGuardar() async {
  try {
    await guardarTarea('');
    print('¡Listo!');
  } catch (e) {
    print('Error controlado: $e');
  }
}

Future<void> main() async {
  await alPresionarGuardar();
  // Espera para que el error asíncrono alcance a ocurrir antes de terminar.
  await Future.delayed(const Duration(seconds: 2));
}
