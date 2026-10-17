import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import '../lib/modelos/tarea.dart';

void main() {
  test('casos fromJson', () {
    final casos = <String>[
      '{"id": "7", "title": "Leer"}',
      '{"id": 3, "title": 42}',
      '{"id": 4}',
      '{"id": 5, "title": ""}',
      '{"id": 6, "title": "   "}',
      '{"id": 7, "title": "Leer", "completed": null}',
      '{"id": 8, "title": "Leer", "completed": "true"}',
      '{"id": 9, "title": "  Leer  "}',
    ];
    for (final c in casos) {
      try {
        final t = Tarea.fromJson(jsonDecode(c) as Map<String, dynamic>);
        print('$c -> OK id=${t.id} titulo="${t.titulo}" completada=${t.completada}');
      } catch (e) {
        print('$c -> ${e.runtimeType}: $e');
      }
    }
  });
}
