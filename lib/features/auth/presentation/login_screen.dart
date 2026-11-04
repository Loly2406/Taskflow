import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/core/widgets/campo_texto.dart';
import 'package:taskflow/features/auth/domain/auth_repository.dart';
import 'package:taskflow/features/auth/presentation/auth_providers.dart';
import 'package:taskflow/features/tareas/presentation/listado_tareas_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  bool _cargando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _correoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  String? _validarCorreo(String? valor) {
    final texto = valor?.trim() ?? '';
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formato.hasMatch(texto)) return 'Escribe un correo válido';
    return null;
  }

  String? _validarClave(String? valor) {
    if (valor == null || valor.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  Future<void> _irARegistro() async {
    final correo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const RegistroScreen()),
    );
    if (!mounted) return;
    if (correo != null) {
      _correoController.text = correo;
    }
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });
    try {
      await ref.read(authRepositoryProvider).iniciarSesion(
            _correoController.text,
            _claveController.text,
          );
      if (!mounted) return;
      // PROVISIONAL: con go_router esto se borra y el redirect decide.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ListadoTareasScreen()),
        (ruta) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _mensajeError = e.mensaje;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CampoTexto(
                etiqueta: 'Correo',
                controlador: _correoController,
                validador: _validarCorreo,
                teclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                etiqueta: 'Contraseña',
                controlador: _claveController,
                validador: _validarClave,
                oculto: true,
              ),
              const SizedBox(height: 16),
              if (_mensajeError != null)
                Text(
                  _mensajeError!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cargando ? null : _iniciarSesion,
                child: _cargando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),
              TextButton(
                onPressed: _irARegistro,
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}