import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pantallas/listado_tareas_screen.dart';

/// TaskFlow - Semana 13: formularios y validacion.
void main() {
  runApp(const ProviderScope(child: TaskFlowApp()));
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  // Colores del curso.
  static const morado = Color(0xFF2C215C);
  static const dorado = Color(0xFFE8A33D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: morado,
          secondary: dorado,
        ),
      ),
      home: const ListadoTareasScreen(),
    );
  }
}
