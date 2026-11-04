import 'package:taskflow/features/tareas/domain/tarea.dart';
/// Contrato de acceso a datos. La app solo conoce esta interfaz;
/// no sabe si abajo hay memoria, SQLite o Firestore.
abstract class TaskRepository {
  Stream<List<Tarea>> observar();
  Future<void> agregar(Tarea tarea);
  Future<void> actualizar(Tarea tarea);
  Future<void> eliminar(String id);
}