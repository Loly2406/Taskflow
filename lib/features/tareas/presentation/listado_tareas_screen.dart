import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../practica/experimento_isolate_screen.dart';
import '../estado/task_provider.dart';
import '../modelos/tarea.dart';
import '../utils/formato.dart';
import 'nueva_tarea_screen.dart';
import 'tareas_remotas_screen.dart'; 

/// Listado de tareas (Semana 10 + Semana 13).
/// Es quien ABRE el formulario y RECIBE la tarea creada.
class ListadoTareasScreen extends ConsumerWidget {
  const ListadoTareasScreen({super.key});

  Future<void> _abrirNuevaTarea(BuildContext context, WidgetRef ref) async {
    // push<Tarea> declara el TIPO que esperamos de vuelta.
    final nueva = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaTareaScreen()),
    );

    // El usuario presiono "atras" sin guardar: no hay nada que hacer.
    if (nueva == null) return;

    // Estado de la APP: ahora si, la tarea entra a Riverpod.
    // ref.read (no watch) porque estamos en un callback.
    ref.read(taskProvider.notifier).agregar(nueva);

    // Safe-await pattern (Libro B, Cap. 7, p. 266).
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea "${nueva.titulo}" creada')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareas = ref.watch(taskProvider).tareas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          // Práctica de la Sesión 1 (sección 1.8): experimento de isolates.
          IconButton(
            tooltip: 'Experimento: isolates',
            icon: const Icon(Icons.science_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExperimentoIsolateScreen()),
            ),
          ),
IconButton(
              tooltip: 'Tareas en la nube',
                          icon: const Icon(Icons.cloud),
                                      onPressed: () => Navigator.push(
                                                    context,
                                                                  MaterialPageRoute(builder: (_) => const TareasRemotasScreen()),
                                                                              ),
                                                                                        ),
        ],
      ),
      body: tareas.isEmpty
          ? const Center(child: Text('No hay tareas. Crea la primera con +'))
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: tareas.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _TareaTile(indice: i, tarea: tareas[i]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
        onPressed: () => _abrirNuevaTarea(context, ref),
      ),
    );
  }
}

class _TareaTile extends ConsumerWidget {
  final int indice;
  final Tarea tarea;

  const _TareaTile({required this.indice, required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskProvider.notifier);
    return ListTile(
      leading: Checkbox(
        value: tarea.completada,
        onChanged: (_) => notifier.alternarCompletada(indice),
      ),
      title: Text(
        tarea.titulo,
        style: tarea.completada
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text(
        '${tarea.categoria} · Prioridad ${tarea.prioridadTexto} · '
        'Vence ${formatearFecha(tarea.fechaLimite)}',
      ),
      trailing: IconButton(
        tooltip: 'Eliminar "${tarea.titulo}"', // etiqueta para lectores de pantalla
        icon: const Icon(Icons.delete_outline),
        onPressed: () => notifier.eliminarTarea(indice),
      ),
    );
  }
}
