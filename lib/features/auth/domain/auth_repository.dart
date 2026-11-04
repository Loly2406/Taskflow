/// Datos mínimos de quien tiene la sesión abierta.
/// No es el User de Firebase: el dominio no conoce a Firebase.
class UsuarioSesion {
  const UsuarioSesion({required this.uid, this.correo});
  final String uid;
  final String? correo;
}

/// Error de autenticación con un mensaje ya listo para mostrar.
class AuthException implements Exception {
  const AuthException(this.mensaje);
  final String mensaje;

  @override
  String toString() => mensaje;
}

abstract class AuthRepository {
  /// Emite el usuario actual, o null si no hay sesión.
  Stream<UsuarioSesion?> observarSesion();
  UsuarioSesion? get usuarioActual;

  Future<void> iniciarSesion(String correo, String clave);
  Future<void> registrar(String correo, String clave);
  Future<void> cerrarSesion();
}