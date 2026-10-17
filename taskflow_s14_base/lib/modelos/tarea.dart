// ignore_for_file: avoid_print
// (Los print vienen de la Semana 3; se conservan para no romper ejercicios previos.)

/// Clase Tarea de TaskFlow (creada en la Semana 3).
///
/// Semana 13: el formulario construye objetos Tarea con este constructor.
///
/// TODO(Semana 14 - Paso 3):
///   - Agrega el campo `int? id;` y el parámetro opcional `this.id`.
///   - Agrega `factory Tarea.fromJson(Map<String, dynamic> json)` que
///     lance FormatException si `title` no es un String no vacío.
///   - Agrega `Map<String, dynamic> toJson()` con title, completed y userId.
///   Revisa la tabla de mapeo del Paso 2 antes de escribir el código.
class Tarea {
  String titulo;
  String descripcion;
  DateTime fechaLimite;
  bool completada = false;
  String categoria;
  int? id; 
  int _prioridad; // privado: 1 = baja, 2 = media, 3 = alta

  Tarea({
    required this.titulo,
    this.descripcion = '',
    required this.fechaLimite,
    this.id,
    this.categoria = 'General',
    int prioridad = 2,
  }) : _prioridad = prioridad;
factory Tarea.fromJson(Map<String, dynamic> json) {
  final titulo = json['title']; 
  if (titulo is! String || titulo.trim().isEmpty) {
    throw const FormatException('El campo "title" debe ser un texto no vacío');
  }
    final id = json['id'];
  return Tarea( 
    id: id is int ? id : null, 
    titulo: titulo, 
    fechaLimite: DateTime.now(), 
  )..completada = json ['completed'] == true; 
} 

Map<String, dynamic> toJson() => { 
  'title': titulo, 
  'completed': completada, 
  'userId': 1, 
}; 

  set prioridad(int valor) {
    if (valor >= 1 && valor <= 3) {
      _prioridad = valor;
    } else {
      print('La prioridad debe estar entre 1 (baja) y 3 (alta).');
    }
  }

  /// Texto legible de la prioridad para mostrar en la interfaz.
  String get prioridadTexto => switch (_prioridad) {
        1 => 'Baja',
        3 => 'Alta',
        _ => 'Media',
      };

  void completar() {
    completada = true;
  }

  @override
  String toString() {
    final estado = completada ? 'completada' : 'pendiente';
    return '[$categoria] $titulo (prioridad $_prioridad, $estado)';
  }
}
