import 'dart:isolate';  
import 'package:flutter/material.dart';

/// SEMANA 14 - SESIÓN 1 (sección 1.8): esperar no es lo mismo que trabajar.
///
/// Observa el indicador de carga mientras se ejecuta cada botón:
///  - Con "Sin isolate", ¿sigue girando o se detiene?
///  - Con "Con isolate", ¿qué cambia?
/// Registra en tu bitácora cuántos segundos se congeló la pantalla.
class ExperimentoIsolateScreen extends StatefulWidget {
  const ExperimentoIsolateScreen({super.key});

  @override
  State<ExperimentoIsolateScreen> createState() =>
      _ExperimentoIsolateScreenState();
}

/// Cálculo deliberadamente pesado (CPU), sin ninguna espera de red.
/// Si en tu equipo termina demasiado rápido o demasiado lento,
/// ajusta este número.
const int _iteraciones = 50000000;
int calculoPesado(int n) {
  var total = 0;
  for (var i = 0; i < n; i++) {
    total += i % 7;
  }
  return total;
}

/// TODO(Sesión 1 - 1.8): devuelve calculoPesado(_iteraciones)
/// ejecutándolo directamente en el hilo principal.
Future<int> sinIsolate() async {
  return calculoPesado(_iteraciones);
}

/// TODO(Sesión 1 - 1.8): devuelve el mismo cálculo, pero ejecutado
/// en otro isolate con Isolate.run(() => ...).
Future<int> conIsolate() async {
  // Pista: agrega `import 'dart:isolate';` al inicio del archivo.
return Isolate.run(() => calculoPesado(_iteraciones)); 
}

class _ExperimentoIsolateScreenState extends State<ExperimentoIsolateScreen> {
  String _resultado = 'Presiona un botón y observa el indicador.';
  bool _ocupado = false;

  Future<void> _ejecutar(String nombre, Future<int> Function() tarea) async {
    setState(() {
      _ocupado = true;
      _resultado = 'Ejecutando "$nombre"...';
    });
    final reloj = Stopwatch()..start();
    String mensaje;
    try {
      final valor = await tarea();
      mensaje = '$nombre: resultado $valor en ${reloj.elapsedMilliseconds} ms';
    } on UnimplementedError catch (e) {
      mensaje = '$nombre: aún no implementado (${e.message})';
    }
    if (!mounted) return;
    setState(() {
      _ocupado = false;
      _resultado = mensaje;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experimento: isolates')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Este indicador SIEMPRE está girando: si se detiene,
            // la pantalla está congelada.
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _ocupado ? null : () => _ejecutar('Sin isolate', sinIsolate),
              child: const Text('Sin isolate'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _ocupado ? null : () => _ejecutar('Con isolate', conIsolate),
              child: const Text('Con isolate'),
            ),
            const SizedBox(height: 24),
            Text(_resultado, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
