import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskflow/core/utils/formato.dart';
import 'package:taskflow/features/tareas/domain/tarea.dart';
import 'package:taskflow/features/tareas/presentation/task_provider.dart';
import 'nueva_tarea_screen.dart';

/// Listado de tareas. Lee del repositorio y le pide los cambios.
class ListadoTareasScreen extends ConsumerWidget {
  const ListadoTareasScreen({super.key});

  Future<void> _abrirNuevaTarea(BuildContext context, WidgetRef ref) async {
    final nueva = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaTareaScreen()),
    );
    if (nueva == null) return;

    await ref.read(taskRepositoryProvider).agregar(nueva);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea "${nueva.titulo}" creada')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareasAsync = ref.watch(tareasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),
      body: tareasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('No se pudieron cargar las tareas')),
        data: (tareas) => tareas.isEmpty
            ? const Center(child: Text('No hay tareas. Crea la primera con +'))
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: tareas.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) => _TareaTile(tarea: tareas[i]),
              ),
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
  final Tarea tarea;

  const _TareaTile({required this.tarea});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(taskRepositoryProvider);
    return ListTile(
      leading: Checkbox(
        value: tarea.completada,
        onChanged: (_) =>
            repo.actualizar(tarea.copyWith(completada: !tarea.completada)),
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
        tooltip: 'Eliminar "${tarea.titulo}"',
        icon: const Icon(Icons.delete_outline),
        onPressed: () => repo.eliminar(tarea.id),
      ),
    );
  }
}