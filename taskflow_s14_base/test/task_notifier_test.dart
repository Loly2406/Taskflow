import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/estado/task_provider.dart';
import 'package:taskflow/modelos/tarea.dart';

/// "Defensa en profundidad": el Notifier rechaza tareas invalidas
/// aunque no vengan del formulario.
void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  int cantidad() => container.read(taskProvider).tareas.length;

  test('agregar una tarea valida aumenta la lista', () {
    final antes = cantidad();
    container.read(taskProvider.notifier).agregar(
          Tarea(titulo: 'Tarea válida', fechaLimite: DateTime.now()),
        );
    expect(cantidad(), antes + 1);
  });

  test('una tarea con titulo de espacios se ignora', () {
    final antes = cantidad();
    container.read(taskProvider.notifier).agregar(
          Tarea(titulo: '   ', fechaLimite: DateTime.now()),
        );
    expect(cantidad(), antes);
  });

  test('agregarTarea (Semana 10) tambien queda protegido', () {
    final antes = cantidad();
    container.read(taskProvider.notifier).agregarTarea('');
    expect(cantidad(), antes);
  });
}
