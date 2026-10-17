import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/validacion/validadores_tarea.dart';

/// Prueba de escritorio de la Sesion 1 (seccion 1.6), automatizada.
/// Ejecutar con: flutter test
void main() {
  group('ValidadoresTarea.titulo', () {
    test('null y vacio son obligatorios', () {
      expect(ValidadoresTarea.titulo(null), 'El título es obligatorio.');
      expect(ValidadoresTarea.titulo(''), 'El título es obligatorio.');
    });

    test('solo espacios cuenta como vacio (trim)', () {
      expect(ValidadoresTarea.titulo('    '), 'El título es obligatorio.');
    });

    test('" ab " tiene 2 caracteres utiles', () {
      expect(ValidadoresTarea.titulo(' ab '), contains('al menos 3'));
    });

    test('titulo normal es valido', () {
      expect(ValidadoresTarea.titulo('Leer cap. 3'), isNull);
    });

    test('frontera: 60 valido, 61 invalido', () {
      expect(ValidadoresTarea.titulo('a' * 60), isNull);
      expect(ValidadoresTarea.titulo('a' * 61), contains('no puede superar 60'));
    });
  });

  group('ValidadoresTarea.descripcion', () {
    test('vacia es valida (campo opcional)', () {
      expect(ValidadoresTarea.descripcion(''), isNull);
    });

    test('frontera: 200 valido, 201 invalido', () {
      expect(ValidadoresTarea.descripcion('x' * 200), isNull);
      expect(ValidadoresTarea.descripcion('x' * 201), isNotNull);
    });
  });

  group('ValidadoresTarea.fechaLimite', () {
    // "Hoy" fijo: la prueba da el mismo resultado cualquier dia.
    final hoy = DateTime(2026, 10, 5, 15, 30);

    test('sin fecha es error', () {
      expect(ValidadoresTarea.fechaLimite(null, hoy: hoy), isNotNull);
    });

    test('ayer es error', () {
      expect(
        ValidadoresTarea.fechaLimite(DateTime(2026, 10, 4), hoy: hoy),
        'La fecha límite no puede estar en el pasado.',
      );
    });

    test('hoy a medianoche es valido aunque ya sean las 15:30', () {
      expect(ValidadoresTarea.fechaLimite(DateTime(2026, 10, 5), hoy: hoy), isNull);
    });

    test('manana es valido', () {
      expect(ValidadoresTarea.fechaLimite(DateTime(2026, 10, 6), hoy: hoy), isNull);
    });
  });
}
