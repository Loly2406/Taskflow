/// Tarea de TaskFlow: inmutable. Para "cambiarla" se crea una copia nueva.
class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.fechaLimite,
    this.descripcion = '',
    this.categoria = 'General',
    this.prioridad = 2, // 1 = baja, 2 = media, 3 = alta
    this.completada = false,
  }) : assert(prioridad >= 1 && prioridad <= 3);

  final String id; // vacío ('') hasta que el repositorio lo asigna
  final String titulo;
  final String descripcion;
  final DateTime fechaLimite;
  final String categoria;
  final int prioridad;
  final bool completada;

  Tarea copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaLimite,
    String? categoria,
    int? prioridad,
    bool? completada,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      categoria: categoria ?? this.categoria,
      prioridad: prioridad ?? this.prioridad,
      completada: completada ?? this.completada,
    );
  }

  String get prioridadTexto => switch (prioridad) {
        1 => 'Baja',
        3 => 'Alta',
        _ => 'Media',
      };
}