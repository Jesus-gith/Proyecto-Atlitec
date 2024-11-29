import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noveno/Models/EditarSubcategoria.dart';
import 'package:noveno/Models/NuevaSubcategoria.dart';
import 'package:noveno/Models/Subcategorias.dart';
import 'package:http/http.dart' as http;

import '../Utils/Ambiente.dart';

class Listadosubcategorias extends StatefulWidget {
  final int id_categoria;
  const Listadosubcategorias({super.key, required this.id_categoria});

  @override
  State<Listadosubcategorias> createState() => _ListadosubcategoriasState();
}

class _ListadosubcategoriasState extends State<Listadosubcategorias> {
  List<Subcategorias> subcategorias = [];

  void fnObtenerSubcategorias() async {
    try{
      final response = await http.get(Uri.parse('${Ambiente.urlServer}/api/subcategorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Iterable mapSubcategorias = jsonDecode(response.body);
        subcategorias = List<Subcategorias>.from(
          mapSubcategorias.map((model) => Subcategorias.fromJson(model)),
        );
      } else {
        print('Error al cargar subcategorias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
  }

  Widget _ListViewSubcategorias(){
    return ListView.builder(
      itemCount: subcategorias.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(subcategorias[index].id.toString()),
          subtitle: Text(subcategorias[index].nombre),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Editarsubcategoria(id: subcategorias[index].id, id_categoria: widget.id_categoria, nombre: subcategorias[index].nombre,)));
              }, icon: Icon(Icons.edit)),
              IconButton(onPressed: () async {
                final Eliminarresponse = await http.post(Uri.parse('${Ambiente.urlServer}/api/subcategoria/borrar/'),
                body: jsonEncode(<String, dynamic>{
                  'id' : subcategorias[index].id,
                }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8'
                    }
                );
                if (Eliminarresponse.body == "Ok"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Listadosubcategorias(id_categoria: widget.id_categoria,)));
                }
              }, icon: Icon(Icons.delete))
            ],
          ),
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    fnObtenerSubcategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategorias"),
      ),
      body: _ListViewSubcategorias(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Nuevasubcategoria(id_categoria: widget.id_categoria,)));
          },child: Icon(Icons.add),)
        ],
      ),
    );
  }
}
