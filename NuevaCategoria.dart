import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/Categorias.dart';
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NuevaCategoria extends StatefulWidget {
  final Categorias? categoria;

  const NuevaCategoria({super.key, this.categoria});

  @override
  State<NuevaCategoria> createState() => _NuevaCategoriaState();
}

class _NuevaCategoriaState extends State<NuevaCategoria> {
  final TextEditingController txtNombre = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      txtNombre.text = widget.categoria!.nombre;
    }
  }

  Future<void> fnGuardarCategoria() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}categoria'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nombre': txtNombre.text,
          'id_usuario': Ambiente.id_usuario,
          'id': widget.categoria?.id ?? 0, // Envia 0 si es una nueva categoría
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresa con éxito
      } else {
        setState(() {
          errorMessage = 'Error al guardar la categoría';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria == null ? 'Nueva Categoría' : 'Editar Categoría',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: txtNombre,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null) // Mostrar mensaje de error
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ElevatedButton(
              onPressed: fnGuardarCategoria,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
              child: Text(
                widget.categoria == null ? 'Guardar' : 'Actualizar',
                style: const TextStyle(fontSize: 16), // Color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
