import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Ambiente.dart';

class Nuevacategoria extends StatefulWidget {
  const Nuevacategoria({super.key});

  @override
  State<Nuevacategoria> createState() => _NuevacategoriaState();
}

class _NuevacategoriaState extends State<Nuevacategoria> {
  TextEditingController txtNombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Categoria"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: txtNombre, // Asigna el controlador aquí
            decoration: const InputDecoration(
              label: Text("Nombre"),
            ),
          ),
          TextButton(
            onPressed: () async {
              final response = await http.post(
                Uri.parse('${Ambiente.urlServer}/api/categoria/guardar'), // Corrige el endpoint
                body: jsonEncode(<String, dynamic>{
                  'nombre': txtNombre.text,
                  'id_usuario': Ambiente.id_usuario,
                }),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              );
              if (response.body == 'Ok') {
                // Si la categoría se crea correctamente
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Categoría creada exitosamente')),
                );
                Navigator.pop(context); // Regresar a la pantalla anterior
              } else {
                // Manejo de errores
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al crear la categoría')),
                );
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
