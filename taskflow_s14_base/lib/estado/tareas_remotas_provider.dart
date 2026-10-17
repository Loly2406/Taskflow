// SEMANA 14 - SESIÓN 2 (Paso 6): estado asíncrono con Riverpod.
//
// TODO(Paso 6): crea estos providers:
//   - httpClientProvider: un único http.Client; ciérralo con ref.onDispose.
//   - tareasApiProvider: construye TareasApi con el cliente anterior.
//
// TODO(Paso 6): crea TareasRemotasNotifier extends AsyncNotifier<List<Tarea>>:
//   - build(): obtiene las tareas de la API.
//   - recargar(): pasa a AsyncLoading y usa AsyncValue.guard.
//   - crear(Tarea): envía la tarea y la agrega a una lista NUEVA.
//     Pregunta para tu bitácora: ¿por qué aquí NO conviene usar guard?
//
// TODO(Paso 6): expón tareasRemotasProvider con AsyncNotifierProvider.
//
// No modifiques task_provider.dart: las tareas locales siguen igual
// esta semana (deuda técnica que resolverás en la Semana 15).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../datos/tareas_api.dart';
import '../modelos/tarea.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
    ref.onDispose(client.close);
      return client;
      });

      final tareasApiProvider = Provider<TareasApi>((ref) {
        return TareasApi(ref.watch(httpClientProvider));
        });

        class TareasRemotasNotifier extends AsyncNotifier<List<Tarea>> {
          @override
            Future<List<Tarea>> build() {
                return ref.watch(tareasApiProvider).obtenerTareas();
                  }

                    Future<void> recargar() async {
                        state = const AsyncLoading();
                            state = await AsyncValue.guard(
                                  () => ref.read(tareasApiProvider).obtenerTareas(),
                                      );
                                        }

                                          Future<void> crear(Tarea tarea) async {
                                              final creada = await ref.read(tareasApiProvider).crearTarea(tarea);
                                                  final actuales = state.value ?? <Tarea>[];
                                                      state = AsyncData([...actuales, creada]);
                                                        }
                                                        }

                                                        final tareasRemotasProvider =
                                                            AsyncNotifierProvider<TareasRemotasNotifier, List<Tarea>>(
                                                              TareasRemotasNotifier.new,
                                                                retry: (_, _) => null,
                                                                );