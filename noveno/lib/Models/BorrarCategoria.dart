import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Ambiente.dart';

class BorrarCategoria extends StatefulWidget{
  const BorrarCategoria ({super.key});
  @override
  state <BorrarCategoria> createState () => _BorrarcategoriaState();
}

class _BorrarcategoriaState extends State<BorrarCategoria> {
  TextEditingController txtNombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("borrar categoria"),
    ),
    body: Column(
      children: [
        TextFormField(
        controller: txtNombre,
        decoration: const InputDecoration(
           label: Text("nombre")
          ),
        ),
        TextButton(
          onPressed: () async {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/categoria/borrar'),
        body: jsonEncode(<String, dynamic>{
          'nombre': txtNombre.text,
          'id_usuario': Ambiente.id_usuario,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.body == 'Ok') {
        //Si la categoria la borra correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar (content: Text('Categoria borrada correctamente')),
        );
        Navigator.pop(context);
      } else {
        //Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al borrar la categoria')),
        );
      }
    },
    })
    , child: child)
    ],
    ),
  }
}