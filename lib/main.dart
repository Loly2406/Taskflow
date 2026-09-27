import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// ─────────────────────────────────────────────────────────
// Paleta del mockup — Guía #3, Semana 6
// ─────────────────────────────────────────────────────────
class TaskFlowColors {
  static const Color moradoOscuro = Color(0xFF2C215C);
  static const Color moradoMedio = Color(0xFF453A7A);
  static const Color dorado = Color(0xFFE8A33D);
  static const Color lilaClaro = Color(0xFFEEEBF7);
  static const Color fondo = Color(0xFFF5F4FA);
  static const Color borde = Color(0xFFE4E1F0);
  static const Color textoOscuro = Color(0xFF2B2B2B);
  static const Color textoGris = Color(0xFF6B6B6B);
}

// ─────────────────────────────────────────────────────────
// Modelo de datos — INMUTABLE (Guía #5 / Riverpod)
// Antes (setState) el campo `completada` era mutable y se
// modificaba en el sitio (tarea.completada = !tarea.completada).
// Con Riverpod, el estado se reemplaza siempre por una copia
// nueva (copyWith), nunca se muta el objeto existente.
// ─────────────────────────────────────────────────────────
class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.meta,
    required this.prioridad,
    this.completada = false,
  });

  final String id;
  final String titulo;
  final String meta;
  final String prioridad;
  final bool completada;

  Tarea copyWith({bool? completada}) {
    return Tarea(
      id: id,
      titulo: titulo,
      meta: meta,
      prioridad: prioridad,
      completada: completada ?? this.completada,
    );
  }
}

// ─────────────────────────────────────────────────────────
// Notifier — reemplaza a _ResumenPantallaState + setState
// ─────────────────────────────────────────────────────────
class TareasNotifier extends Notifier<List<Tarea>> {
  @override
  List<Tarea> build() {
    return const [
      Tarea(
        id: '1',
        titulo:
            'Terminar el laboratorio de layouts y composición visual con todos los detalles del mockup y corrigiendo cada desbordamiento posible',
        meta: 'Hoy · Universidad',
        prioridad: 'Alta',
      ),
      Tarea(
        id: '2',
        titulo: 'Revisar los pull requests',
        meta: 'Hoy · Trabajo',
        prioridad: 'Media',
        completada: true,
      ),
      Tarea(
        id: '3',
        titulo: 'Leer la documentación',
        meta: 'Mañana · Aprendizaje',
        prioridad: 'Baja',
      ),
    ];
  }

  void alternarCompletada(String id) {
    state = [
      for (final tarea in state)
        if (tarea.id == id)
          tarea.copyWith(completada: !tarea.completada)
        else
          tarea,
    ];
  }

  void eliminarTarea(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void insertarTarea(int indice, Tarea tarea) {
    final nuevaLista = [...state];
    final indiceSeguro = indice.clamp(0, nuevaLista.length);
    nuevaLista.insert(indiceSeguro, tarea);
    state = nuevaLista;
  }

  void agregarTarea(Tarea nueva) {
    state = [...state, nueva];
  }
}

final tareasProvider = NotifierProvider<TareasNotifier, List<Tarea>>(
  TareasNotifier.new,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const ResumenPantalla(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Pantalla principal — ahora ConsumerWidget en vez de
// StatefulWidget. Ya no guarda _tareas ni tiene setState:
// lee el estado con ref.watch(tareasProvider).
// ─────────────────────────────────────────────────────────
class ResumenPantalla extends ConsumerWidget {
  const ResumenPantalla({super.key});

  void _eliminarTarea(BuildContext context, WidgetRef ref, String id) {
    final tareas = ref.read(tareasProvider);
    final indice = tareas.indexWhere((t) => t.id == id);
    if (indice == -1) return;
    final tareaEliminada = tareas[indice];

    ref.read(tareasProvider.notifier).eliminarTarea(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea "${tareaEliminada.titulo}" eliminada'),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: TaskFlowColors.dorado,
          onPressed: () {
            ref.read(tareasProvider.notifier).insertarTarea(indice, tareaEliminada);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _mostrarDialogoNuevaTarea(BuildContext context, WidgetRef ref) {
    final controladorTitulo = TextEditingController();
    final controladorMeta = TextEditingController();
    String prioridadSeleccionada = 'Media';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nueva tarea'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controladorTitulo,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controladorMeta,
                    decoration: const InputDecoration(
                      labelText: 'Meta (ej. Hoy · Universidad)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: prioridadSeleccionada,
                    decoration: const InputDecoration(labelText: 'Prioridad'),
                    items: const [
                      DropdownMenuItem(value: 'Alta', child: Text('Alta')),
                      DropdownMenuItem(value: 'Media', child: Text('Media')),
                      DropdownMenuItem(value: 'Baja', child: Text('Baja')),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setDialogState(() => prioridadSeleccionada = valor);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TaskFlowColors.moradoOscuro,
                  ),
                  onPressed: () {
                    if (controladorTitulo.text.trim().isEmpty) return;
                    ref.read(tareasProvider.notifier).agregarTarea(
                      Tarea(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        titulo: controladorTitulo.text.trim(),
                        meta: controladorMeta.text.trim().isEmpty
                            ? 'Sin fecha'
                            : controladorMeta.text.trim(),
                        prioridad: prioridadSeleccionada,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tareas = ref.watch(tareasProvider);
    final pendientes = tareas.where((t) => !t.completada).length;

    return Scaffold(
      backgroundColor: TaskFlowColors.fondo,
      floatingActionButton: FloatingActionButton(
        backgroundColor: TaskFlowColors.moradoOscuro,
        onPressed: () => _mostrarDialogoNuevaTarea(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _BarraSuperior(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _TarjetaCabecera(pendientes: pendientes),
                    const SizedBox(height: 56),
                    _FilaEstadisticas(tareas: tareas),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _EncabezadoSeccion(),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          for (final tarea in tareas) ...[
                            TarjetaTarea(
                              tarea: tarea,
                              onToggle: () => ref
                                  .read(tareasProvider.notifier)
                                  .alternarCompletada(tarea.id),
                              onEliminar: () =>
                                  _eliminarTarea(context, ref, tarea.id),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _TarjetaFrase(),
                    ),
                  ],
                ),
              ),
            ),
            const _BarraInferior(),
          ],
        ),
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TaskFlow',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: TaskFlowColors.textoOscuro,
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              'A',
              style: TextStyle(
                color: TaskFlowColors.moradoOscuro,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCabecera extends StatelessWidget {
  const _TarjetaCabecera({required this.pendientes});

  final int pendientes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 104,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TaskFlowColors.moradoOscuro,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Buenos días, Ana',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Viernes 22 de agosto',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  pendientes == 1
                      ? '1 tarea pendiente para hoy'
                      : '$pendientes tareas pendientes para hoy',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 4,
            bottom: -38,
            child: InsigniaProgreso(porcentaje: 0.6),
          ),
        ],
      ),
    );
  }
}

class InsigniaProgreso extends StatelessWidget {
  const InsigniaProgreso({super.key, required this.porcentaje});

  final double porcentaje;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: CircularProgressIndicator(
              value: porcentaje,
              strokeWidth: 5,
              backgroundColor: TaskFlowColors.borde,
              valueColor: const AlwaysStoppedAnimation(TaskFlowColors.dorado),
            ),
          ),
          Text(
            '${(porcentaje * 100).round()}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: TaskFlowColors.textoOscuro,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaEstadisticas extends StatelessWidget {
  const _FilaEstadisticas({required this.tareas});

  final List<Tarea> tareas;

  @override
  Widget build(BuildContext context) {
    final total = tareas.length;
    final completadas = tareas.where((t) => t.completada).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TarjetaEstadistica(valor: '$total', etiqueta: 'Tareas'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TarjetaEstadistica(
              valor: '$completadas',
              etiqueta: 'Completadas',
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: TarjetaEstadistica(valor: '5', etiqueta: 'Racha semanal'),
          ),
        ],
      ),
    );
  }
}

class TarjetaEstadistica extends StatelessWidget {
  const TarjetaEstadistica({
    super.key,
    required this.valor,
    required this.etiqueta,
  });

  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TaskFlowColors.borde),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TaskFlowColors.moradoOscuro,
            ),
          ),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: TaskFlowColors.textoGris),
          ),
        ],
      ),
    );
  }
}

class _EncabezadoSeccion extends StatelessWidget {
  const _EncabezadoSeccion();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Tareas de hoy',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: TaskFlowColors.textoOscuro,
          ),
        ),
        Text(
          'Ver todas',
          style: TextStyle(
            fontSize: 13,
            color: TaskFlowColors.dorado,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({
    super.key,
    required this.tarea,
    required this.onToggle,
    required this.onEliminar,
  });

  final Tarea tarea;
  final VoidCallback onToggle;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(tarea.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onEliminar(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFD9534F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 84),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TaskFlowColors.borde),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: CasillaVerificacion(marcada: tarea.completada),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarea.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: TaskFlowColors.textoOscuro,
                      decoration:
                          tarea.completada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: TaskFlowColors.textoGris,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          tarea.meta,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: TaskFlowColors.textoGris,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ChipPrioridad(etiqueta: tarea.prioridad),
          ],
        ),
      ),
    );
  }
}

class CasillaVerificacion extends StatelessWidget {
  const CasillaVerificacion({super.key, required this.marcada});

  final bool marcada;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: marcada ? TaskFlowColors.moradoMedio : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: marcada ? TaskFlowColors.moradoMedio : TaskFlowColors.borde,
          width: 2,
        ),
      ),
      child: marcada
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }
}

class ChipPrioridad extends StatelessWidget {
  const ChipPrioridad({super.key, required this.etiqueta});

  final String etiqueta;

  static const Map<String, Color> _colorTexto = {
    'Alta': Color(0xFFD9534F),
    'Media': TaskFlowColors.moradoMedio,
    'Baja': TaskFlowColors.textoGris,
  };

  static const Map<String, Color> _colorFondo = {
    'Alta': Color(0xFFFBEAEA),
    'Media': TaskFlowColors.lilaClaro,
    'Baja': TaskFlowColors.fondo,
  };

  @override
  Widget build(BuildContext context) {
    final Color texto = _colorTexto[etiqueta] ?? TaskFlowColors.textoGris;
    final Color fondo = _colorFondo[etiqueta] ?? TaskFlowColors.fondo;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        etiqueta,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: texto),
      ),
    );
  }
}

class _TarjetaFrase extends StatelessWidget {
  const _TarjetaFrase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TaskFlowColors.lilaClaro,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u201C',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              height: 0.8,
              color: const Color.fromARGB(255, 190, 190, 191),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'La disciplina es el puente entre las metas '
                  'y los logros que realmente importan.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    color: TaskFlowColors.moradoOscuro,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '— Jim Rohn',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: TaskFlowColors.moradoOscuro,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarraInferior extends StatelessWidget {
  const _BarraInferior();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: TaskFlowColors.borde)),
      ),
      child: Row(
        children: const [
          Expanded(
            child: _ItemBarraInferior(
              icono: Icons.format_list_bulleted,
              etiqueta: 'Tareas',
              activo: true,
            ),
          ),
          Expanded(
            child: _ItemBarraInferior(
              icono: Icons.water_drop_outlined,
              etiqueta: 'Hábitos',
            ),
          ),
          Expanded(
            child: _ItemBarraInferior(
              icono: Icons.person_outline,
              etiqueta: 'Perfil',
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemBarraInferior extends StatelessWidget {
  const _ItemBarraInferior({
    required this.icono,
    required this.etiqueta,
    this.activo = false,
  });

  final IconData icono;
  final String etiqueta;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    final Color color =
        activo ? TaskFlowColors.moradoOscuro : TaskFlowColors.textoGris;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: activo
              ? BoxDecoration(
                  color: TaskFlowColors.moradoOscuro.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                )
              : null,
          child: Icon(icono, color: color),
        ),
        const SizedBox(height: 4),
        Text(etiqueta, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}