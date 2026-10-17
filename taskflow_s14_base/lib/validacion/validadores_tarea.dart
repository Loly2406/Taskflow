/// SEMANA 13 - SESION 1
///
/// Reglas de negocio para los campos de una Tarea.
///
/// Decisiones de diseno (para explicar en clase):
///  - NO importa Flutter: se prueba con un test unitario simple.
///  - Metodos static: no hay estado que guardar.
///  - Constantes con nombre: el mismo numero se usa en el validador,
///    en el mensaje y en el contador maxLength del campo.
///  - Convencion de Flutter: null = valido; String = mensaje de error.
class ValidadoresTarea {
  ValidadoresTarea._(); // no se instancia

  static const int tituloMin = 3;
  static const int tituloMax = 60;
  static const int descripcionMax = 200;

  /// Obligatorio, entre [tituloMin] y [tituloMax] caracteres.
  static String? titulo(String? valor) {
    // Normalizar ANTES de medir: "   " debe contar como vacio.
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'El título es obligatorio.';
    }
    if (texto.length < tituloMin) {
      return 'El título debe tener al menos $tituloMin caracteres.';
    }
    if (texto.length > tituloMax) {
      return 'El título no puede superar $tituloMax caracteres.';
    }
    return null;
  }

  /// Opcional: vacio es valido, pero tiene un maximo.
  static String? descripcion(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.length > descripcionMax) {
      return 'La descripción no puede superar $descripcionMax caracteres.';
    }
    return null;
  }

  /// Obligatoria y no anterior a hoy.
  ///
  /// [hoy] es opcional para poder fijar la fecha en las pruebas:
  /// una prueba que dependa de DateTime.now() cambia segun el dia.
  static String? fechaLimite(DateTime? fecha, {DateTime? hoy}) {
    if (fecha == null) {
      return 'Selecciona una fecha límite.';
    }
    final referencia = hoy ?? DateTime.now();
    final inicioDeHoy =
        DateTime(referencia.year, referencia.month, referencia.day);
    if (fecha.isBefore(inicioDeHoy)) {
      return 'La fecha límite no puede estar en el pasado.';
    }
    return null;
  }
}
