import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/features/tareas/data/in_memory_task_repository.dart';
import 'package:taskflow/features/tareas/domain/tarea.dart';
import 'package:taskflow/features/tareas/domain/task_repository.dart';

/// Entrega el repositorio. Hoy es en memoria; en la Sesión 2 se cambia
/// SOLO esta pieza por el de Firestore y la pantalla no se entera.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final hoy = DateTime.now();
  return InMemoryTaskRepository([
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
});

/// La lista que ve la pantalla: un Stream que se actualiza solo
/// cada vez que el repositorio cambia.
final tareasProvider = StreamProvider.autoDispose<List<Tarea>>((ref) {
  return ref.watch(taskRepositoryProvider).observar();
});