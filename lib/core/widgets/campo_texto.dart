import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
      super.key,
          required this.etiqueta,
              required this.controlador,
                  this.validador,
                      this.oculto = false,
                          this.teclado,
                            });

                              final String etiqueta;
                                final TextEditingController controlador;
                                  final String? Function(String?)? validador;
                                    final bool oculto;
                                      final TextInputType? teclado;

                                        @override
                                          Widget build(BuildContext context) {
                                              return TextFormField(
                                                    controller: controlador,
                                                          validator: validador,
                                                                obscureText: oculto,
                                                                      keyboardType: teclado,
                                                                            decoration: InputDecoration(
                                                                                    labelText: etiqueta,
                                                                                            border: const OutlineInputBorder(),
                                                                                                  ),
                                                                                                      );
                                                                                                        }
                                                                                                        }