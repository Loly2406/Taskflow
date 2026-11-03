import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modelos/tarea.dart';
import '../validacion/validadores_tarea.dart';

/// Estado de la APP (Semana 10): la lista de tareas confirmadas.
/// Aqui solo entran tareas terminadas y validas; los borradores del
/// formulario NUNCA llegan a este archivo.
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
    // Dos tareas de ejemplo para que la lista no inicie vacia en clase.
    final hoy = DateTime.now();
    return TaskState(tareas: [
      Tarea(
        titulo: 'Leer Cap. 3 del Libro A',
        descripcion: 'Estado efímero vs. estado de la app, pp. 76-78',
        fechaLimite: hoy.add(const Duration(days: 2)),
        categoria: 'Estudio',
        prioridad: 3,
      ),
      Tarea(
        titulo: 'Publicar en el foro',
        fechaLimite: hoy.add(const Duration(days: 4)),
        categoria: 'Estudio',
      ),
    ]);
  }

  /// SEMANA 13: recibe una tarea completa construida por el formulario.
  void agregar(Tarea tarea) {
    // Defensa en profundidad: aunque la UI ya valido, el gestor de
    // estado no acepta datos invalidos de NINGUN origen (formulario,
    // API en la Semana 15, almacenamiento local en la Semana 17).
    if (ValidadoresTarea.titulo(tarea.titulo) != null) return;
    state = state.copyWith(tareas: [...state.tareas, tarea]);
  }

  /// Version de la Semana 10. Se conserva, pero ahora tambien valida.
  void agregarTarea(String titulo) {
    agregar(Tarea(titulo: titulo, fechaLimite: DateTime.now()));
  }

  void alternarCompletada(int indice) {
    final copia = [...state.tareas];
    copia[indice].completada = !copia[indice].completada;
    state = state.copyWith(tareas: copia); // lista NUEVA -> Riverpod notifica
  }

  void eliminarTarea(int indice) {
    final copia = [...state.tareas]..removeAt(indice);
    state = state.copyWith(tareas: copia);
  }
}

final taskProvider =
    NotifierProvider<TaskNotifier, TaskState>(TaskNotifier.new);
