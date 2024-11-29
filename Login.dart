import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastosnoveno/Models/LoginResponse.dart';
import 'package:gastosnoveno/Pages/Home.dart';
import 'package:gastosnoveno/Utils/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'package:wear_plus/wear_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  bool isLoading = false;

  bool isWearDevice(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return size.width < 200;
  }

  _ResponsiveDimensions getResponsiveDimensions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWear = isWearDevice(context);

    return _ResponsiveDimensions(
      imageSize: isWear ? size.width * 0.25 : size.width * 0.2,
      inputHeight: isWear ? 32.0 : 50.0,
      buttonHeight: isWear ? 30.0 : 50.0,
      fontSize: isWear ? 10.0 : 16.0,
      buttonFontSize: isWear ? 12.0 : 18.0,
      iconSize: isWear ? 14.0 : 24.0,
      padding: isWear ? 8.0 : 20.0,
      spacing: isWear ? 4.0 : 20.0,
      borderRadius: isWear ? 16.0 : 30.0,
      inputPadding: isWear
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWear = isWearDevice(context);
    final dim = getResponsiveDimensions(context);

    Widget loginContent = LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(dim.padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(flex: 1),

                    // Imagen
                    Container(
                      width: dim.imageSize,
                      height: dim.imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://pic.pngsucai.com/00/07/21/714bfdc17ab4016f.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: dim.spacing),

                    // Campo usuario
                    SizedBox(
                      height: dim.inputHeight,
                      child: TextFormField(
                        controller: txtUser,
                        decoration: InputDecoration(
                          isDense: isWear,
                          labelText: 'Usuario',
                          contentPadding: dim.inputPadding,
                          prefixIcon: Icon(Icons.person, size: dim.iconSize),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(dim.borderRadius),
                          ),
                          labelStyle: TextStyle(fontSize: dim.fontSize),
                        ),
                        style: TextStyle(fontSize: dim.fontSize),
                      ),
                    ),

                    SizedBox(height: dim.spacing),

                    // Campo contraseña
                    SizedBox(
                      height: dim.inputHeight,
                      child: TextFormField(
                        controller: txtPass,
                        obscureText: true,
                        decoration: InputDecoration(
                          isDense: isWear,
                          labelText: 'Contraseña',
                          contentPadding: dim.inputPadding,
                          prefixIcon: Icon(Icons.lock, size: dim.iconSize),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(dim.borderRadius),
                          ),
                          labelStyle: TextStyle(fontSize: dim.fontSize),
                        ),
                        style: TextStyle(fontSize: dim.fontSize),
                      ),
                    ),

                    SizedBox(height: dim.spacing),

                    // Botón de acceso
                    isLoading
                        ? SizedBox(
                            width: isWear ? 20 : 30,
                            height: isWear ? 20 : 30,
                            child: CircularProgressIndicator(
                                strokeWidth: isWear ? 2 : 3),
                          )
                        : SizedBox(
                            height: dim.buttonHeight,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(dim.borderRadius),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: dim.padding),
                              ),
                              onPressed: _login,
                              child: Text(
                                'Acceder',
                                style: TextStyle(fontSize: dim.buttonFontSize),
                              ),
                            ),
                          ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // Si es un smartwatch, usamos WatchShape, si no, usamos Scaffold directamente
    return isWear
        ? WatchShape(
            builder: (context, shape, child) {
              return Scaffold(body: loginContent);
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: loginContent,
              ),
            ),
          );
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}login'),
        body: jsonEncode(<String, dynamic>{
          'email': txtUser.text,
          'password': txtPass.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseJson = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(responseJson);

      if (loginResponse.acceso == "Ok") {
        Ambiente.id_usuario = loginResponse.idUsuario;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        _showErrorAlert();
      }
    } catch (e) {
      _showErrorAlert();
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorAlert() {
    final isWear = isWearDevice(context);

    if (isWear) {
      // Solución simplificada para smartwatch
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Text(
                'Usuario o contraseña incorrecta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(30, 20),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Alerta para dispositivos normales
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Usuario o contraseña incorrecta.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

// Clase auxiliar para manejar dimensiones responsivas
class _ResponsiveDimensions {
  final double imageSize;
  final double inputHeight;
  final double buttonHeight;
  final double fontSize;
  final double buttonFontSize;
  final double iconSize;
  final double padding;
  final double spacing;
  final double borderRadius;
  final EdgeInsets inputPadding;

  _ResponsiveDimensions({
    required this.imageSize,
    required this.inputHeight,
    required this.buttonHeight,
    required this.fontSize,
    required this.buttonFontSize,
    required this.iconSize,
    required this.padding,
    required this.spacing,
    required this.borderRadius,
    required this.inputPadding,
  });
}
