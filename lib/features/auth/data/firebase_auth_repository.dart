import 'package:firebase_auth/firebase_auth.dart';

import 'package:taskflow/features/auth/domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository([FirebaseAuth? auth])
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  UsuarioSesion? _aSesion(User? u) =>
      u == null ? null : UsuarioSesion(uid: u.uid, correo: u.email);

  @override
  Stream<UsuarioSesion?> observarSesion() =>
      _auth.authStateChanges().map(_aSesion);

  @override
  UsuarioSesion? get usuarioActual => _aSesion(_auth.currentUser);

  @override
  Future<void> iniciarSesion(String correo, String clave) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: clave,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mensaje(e.code));
    }
  }

  @override
  Future<void> registrar(String correo, String clave) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: clave,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mensaje(e.code));
    }
  }

  @override
  Future<void> cerrarSesion() => _auth.signOut();

  /// Errores en español. Correo inexistente y contraseña incorrecta
  /// comparten UN solo mensaje: así no revelamos qué correos existen.
  String _mensaje(String codigo) {
    switch (codigo) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo o contraseña incorrectos';
      case 'invalid-email':
        return 'El correo no tiene un formato válido';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres)';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento e inténtalo de nuevo';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu internet';
      default:
        return 'No se pudo completar la operación. Inténtalo de nuevo';
    }
  }
}