import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noveno/Models/Categorias.dart';
import 'package:http/http.dart' as http;
import 'package:noveno/Models/NuevaCategoria.dart';

import '../Utils/Ambiente.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Categorias> categorias = [];

  void fnObtenerCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/categorias'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Iterable mapCategorias = jsonDecode(response.body);
        categorias = List<Categorias>.from(
          mapCategorias.map((model) => Categorias.fromJson(model)),
        );
      } else {
        print('Error en la carga de categorias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
  }

  Widget _ListViewCategorias() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categorias[index].id.toString()),
          subtitle: Text(categorias[index].nombre),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnObtenerCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
      ),
      body: _ListViewCategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Nuevacategoria()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
