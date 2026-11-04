import 'dart:async';

import 'package:taskflow/features/tareas/domain/tarea.dart';
import 'package:taskflow/features/tareas/domain/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository([List<Tarea> iniciales = const []])
      : _tareas = [...iniciales];

  final List<Tarea> _tareas;
  final _controller = StreamController<List<Tarea>>.broadcast();
  int _contador = 0;

  void _emitir() => _controller.add(List.unmodifiable(_tareas));

  @override
  Stream<List<Tarea>> observar() async* {
    yield List.unmodifiable(_tareas);
    yield* _controller.stream;
  }

  @override
  Future<void> agregar(Tarea tarea) async {
    final id = tarea.id.isEmpty ? 'mem-${_contador++}' : tarea.id;
    _tareas.add(tarea.copyWith(id: id));
    _emitir();
  }

  @override
  Future<void> actualizar(Tarea tarea) async {
    final i = _tareas.indexWhere((t) => t.id == tarea.id);
    if (i == -1) return;
    _tareas[i] = tarea;
    _emitir();
  }

  @override
  Future<void> eliminar(String id) async {
    _tareas.removeWhere((t) => t.id == id);
    _emitir();
  }
}