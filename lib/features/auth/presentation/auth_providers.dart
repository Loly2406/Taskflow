import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/features/auth/data/firebase_auth_repository.dart';
import 'package:taskflow/features/auth/domain/auth_repository.dart';

/// Entrega el repositorio de autenticación (hoy, el de Firebase).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

/// Quién tiene la sesión abierta; null si nadie.
final sesionProvider = StreamProvider<UsuarioSesion?>(
  (ref) => ref.watch(authRepositoryProvider).observarSesion(),
);