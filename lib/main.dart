import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
// Pantalla principal: arma todas las piezas
// ─────────────────────────────────────────────────────────
class ResumenPantalla extends StatelessWidget {
  const ResumenPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaskFlowColors.fondo,
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
                    const _TarjetaCabecera(),
                    const SizedBox(height: 16),
                    const _FilaEstadisticas(),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: _EncabezadoSeccion(),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: const [
                          TarjetaTarea(
                            titulo: 'Terminar el laboratorio de layouts y composición visual con todos los detalles del mockup y corrigiendo cada desbordamiento posible',
                            meta: 'Hoy · Universidad',
                            prioridad: 'Alta',
                          ),
                          SizedBox(height: 12),
                          TarjetaTarea(
                            titulo: 'Revisar los pull requests',
                            meta: 'Hoy · Trabajo',
                            prioridad: 'Media',
                            completada: true,
                          ),
                          SizedBox(height: 12),
                          TarjetaTarea(
                            titulo: 'Leer la documentación',
                            meta: 'Mañana · Aprendizaje',
                            prioridad: 'Baja',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
          const CircleAvatar(
            radius: 18,
            backgroundColor: TaskFlowColors.moradoOscuro,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCabecera extends StatelessWidget {
  const _TarjetaCabecera();

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Buenos días, Ana',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Viernes 22 de agosto',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '3 tareas pendientes para hoy',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: -38,
            child: const InsigniaProgreso(porcentaje: 0.6),
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
  const _FilaEstadisticas();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(
            child: TarjetaEstadistica(valor: '12', etiqueta: 'Tareas'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TarjetaEstadistica(valor: '7', etiqueta: 'Completadas'),
          ),
          SizedBox(width: 12),
          Expanded(
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
            style: const TextStyle(
              fontSize: 11,
              color: TaskFlowColors.textoGris,
            ),
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
    required this.titulo,
    required this.meta,
    required this.prioridad,
    this.completada = false,
  });

  final String titulo;
  final String meta;
  final String prioridad;
  final bool completada;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          CasillaVerificacion(marcada: completada),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: TaskFlowColors.textoOscuro,
                    decoration: completada ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TaskFlowColors.textoGris,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ChipPrioridad(etiqueta: prioridad),
        ],
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
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: texto,
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '"La disciplina es el puente entre las metas y los logros que '
            'realmente importan."',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13,
              color: TaskFlowColors.textoOscuro,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '— Jim Rohn',
            style: TextStyle(fontSize: 12, color: TaskFlowColors.textoGris),
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
              icono: Icons.check_circle_outline,
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
    final Color color = activo
        ? TaskFlowColors.moradoOscuro
        : TaskFlowColors.textoGris;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icono, color: color),
        const SizedBox(height: 4),
        Text(etiqueta, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}
