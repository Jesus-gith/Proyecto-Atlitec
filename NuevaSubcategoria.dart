import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noveno/Models/ListadoSubcategorias.dart';

import '../Utils/Ambiente.dart';

class Nuevasubcategoria extends StatefulWidget {
  final int id_categoria;
  const Nuevasubcategoria({super.key, required this.id_categoria});

  @override
  State<Nuevasubcategoria> createState() => _NuevasubcategoriaState();
}

class _NuevasubcategoriaState extends State<Nuevasubcategoria> {
  TextEditingController txtNombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Subcategoria"),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(40),
          child: TextFormField(
            controller: txtNombre,
            decoration: InputDecoration(
              label: Text("Nombre"),
            ),
          ),
          ),
          TextButton(onPressed: () async {
            final response = await http.post(Uri.parse('${Ambiente.urlServer}/api/subcategoria/guardar'),
            body: jsonEncode(<String, dynamic>{
              'nombre' : txtNombre.text,
              'id_categoria' : widget.id_categoria,
            }),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                }
            );
            if (response.body == "Ok") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Listadosubcategorias(id_categoria: widget.id_categoria)));
            }
            return;
          }, child: Text("Guardar"))
        ],
      ),
    );
  }
}
