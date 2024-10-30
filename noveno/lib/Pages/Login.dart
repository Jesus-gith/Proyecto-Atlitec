import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noveno/Models/LoginResponse.dart';
import 'package:noveno/Pages/Home.dart';
import 'package:noveno/Utils/Ambiente.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network('https://w7.pngwing.com/pngs/312/283/png-transparent-man-s-face-avatar-computer-icons-user-profile-business-user-avatar-blue-face-heroes-thumbnail.png'),
          Padding(
        padding: const EdgeInsets.all(40),
      child: TextFormField(
        controller: txtUser,
        decoration: const InputDecoration(
          label: Text('Usuario')
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: TextFormField(
          controller: txtPass,
          decoration: const InputDecoration(
            label: Text('Contraseña')
          ),
          obscureText: true,
        ),
      ),
      TextButton(
        onPressed: () async {
          final response = await http.post(Uri.parse('${Ambiente.urlServer}/api/login'),
          body: jsonEncode(<String, dynamic>{
            'email' : txtUser.text,
            'password' : txtPass.text,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }
          );
          print(response.body);
          Map<String, dynamic> responseJson = jsonDecode(response.body);
          final loginresponse = LoginResponse.fromJson(responseJson);
          if (loginresponse.acceso == "Ok"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Home())
            );
          }
          else{
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Sorry, something went wrong',
            );
          }
          return;
        }, child: const Text('Accesar'),
      )
          ],
        ),
      ),
    );
  }
}