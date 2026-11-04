import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/features/tareas/domain/tarea.dart';
import 'package:taskflow/features/tareas/domain/validadores_tarea.dart';

/// Estado de la APP: la lista de tareas confirmadas.
class TaskState {
  final List<Tarea> tareas;
  const TaskState({required this.tareas});

  TaskState copyWith({List<Tarea>? tareas}) {
    return TaskState(tareas: tareas ?? this.tareas);
  }
}

class TaskNotifier extends Notifier<TaskState> {
  @override
  TaskState build() {
    final hoy = DateTime.now();
    return TaskState(tareas: [
      Tarea(
        id: 'ej-1',
        titulo: 'Leer Cap. 3 del Libro A',
        descripcion: 'Estado efímero vs. estado de la app, pp. 76-78',
        fechaLimite: hoy.add(const Duration(days: 2)),
        categoria: 'Estudio',
        prioridad: 3,
      ),
      Tarea(
        id: 'ej-2',
        titulo: 'Publicar en el foro',
        fechaLimite: hoy.add(const Duration(days: 4)),
        categoria: 'Estudio',
      ),
    ]);
  }

  void agregar(Tarea tarea) {
    if (ValidadoresTarea.titulo(tarea.titulo) != null) return;
    // Provisional: el id lo asignará el repositorio en el siguiente paso.
    final conId = tarea.id.isEmpty
        ? tarea.copyWith(id: DateTime.now().microsecondsSinceEpoch.toString())
        : tarea;
    state = state.copyWith(tareas: [...state.tareas, conId]);
  }

  void agregarTarea(String titulo) {
    agregar(Tarea(id: '', titulo: titulo, fechaLimite: DateTime.now()));
  }

  void alternarCompletada(int indice) {
    final copia = [...state.tareas];
    final actual = copia[indice];
    copia[indice] = actual.copyWith(completada: !actual.completada);
    state = state.copyWith(tareas: copia);
  }

  void eliminarTarea(int indice) {
    final copia = [...state.tareas]..removeAt(indice);
    state = state.copyWith(tareas: copia);
  }
}

final taskProvider =
    NotifierProvider<TaskNotifier, TaskState>(TaskNotifier.new);