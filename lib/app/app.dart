import 'package:flutter/material.dart';
import 'package:taskflow/features/auth/presentation/login_screen.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

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
      home: const LoginScreen(),
    );
  }
}
