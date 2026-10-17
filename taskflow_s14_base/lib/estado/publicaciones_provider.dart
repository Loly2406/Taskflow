import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datos/publicaciones_api.dart';

class EstadoListado {
  const EstadoListado({
      this.items = const [],
          this.pagina = 0,
              this.hayMas = true,
                  this.cargando = false,
                      this.cargandoMas = false,
                          this.error,
                              this.errorMas,
                                });

                                  final List<Publicacion> items;
                                    final int pagina;
                                      final bool hayMas;
                                        final bool cargando; // primera carga
                                          final bool cargandoMas; // siguiente página
                                            final String? error; // error de la primera carga
                                              final String? errorMas; // error al cargar más
                                              }

                                              class PublicacionesNotifier extends Notifier<EstadoListado> {
                                                final _api = PublicacionesApi();

                                                  @override
                                                    EstadoListado build() {
                                                        Future.microtask(cargarInicial);
                                                            return const EstadoListado(cargando: true);
                                                              }

                                                                Future<void> cargarInicial() async {
                                                                    state = const EstadoListado(cargando: true);
                                                                        await _cargarPrimera();
                                                                          }

                                                                            // Para deslizar hacia abajo y recargar
                                                                              Future<void> recargar() => _cargarPrimera();

                                                                                Future<void> _cargarPrimera() async {
                                                                                    try {
                                                                                          final datos = await _api.obtenerPagina(1);
                                                                                                state = EstadoListado(
                                                                                                        items: datos,
                                                                                                                pagina: 1,
                                                                                                                        hayMas: datos.length == PublicacionesApi.porPagina,
                                                                                                                              );
                                                                                                                                  } on ErrorApi catch (e) {
                                                                                                                                        state = EstadoListado(error: e.mensaje);
                                                                                                                                            }
                                                                                                                                              }

                                                                                                                                                Future<void> cargarMas() async {
                                                                                                                                                    // Evita peticiones duplicadas y pedir páginas que no existen
                                                                                                                                                        if (state.cargando || state.cargandoMas || !state.hayMas) return;

                                                                                                                                                            state = EstadoListado(
                                                                                                                                                                  items: state.items,
                                                                                                                                                                        pagina: state.pagina,
                                                                                                                                                                              cargandoMas: true,
                                                                                                                                                                                  );
                                                                                                                                                                                      try {
                                                                                                                                                                                            final siguiente = state.pagina + 1;
                                                                                                                                                                                                  final datos = await _api.obtenerPagina(siguiente);
                                                                                                                                                                                                        state = EstadoListado(
                                                                                                                                                                                                                items: [...state.items, ...datos],
                                                                                                                                                                                                                        pagina: siguiente,
                                                                                                                                                                                                                                hayMas: datos.length == PublicacionesApi.porPagina,
                                                                                                                                                                                                                                      );
                                                                                                                                                                                                                                          } on ErrorApi catch (e) {
                                                                                                                                                                                                                                                state = EstadoListado(
                                                                                                                                                                                                                                                        items: state.items,
                                                                                                                                                                                                                                                                pagina: state.pagina,
                                                                                                                                                                                                                                                                        errorMas: e.mensaje,
                                                                                                                                                                                                                                                                              );
                                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                    }

                                                                                                                                                                                                                                                                                    final publicacionesProvider =
                                                                                                                                                                                                                                                                                        NotifierProvider<PublicacionesNotifier, EstadoListado>(
                                                                                                                                                                                                                                                                                          PublicacionesNotifier.new,
                                                                                                                                                                                                                                                                                          );