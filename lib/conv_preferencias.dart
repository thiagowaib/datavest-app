import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

@JsonSerializable()
class Preferencia{
  String id;
  String descricao;
  bool prefere;

  Preferencia({
    required this.id,
    required this.descricao,
    required this.prefere
  });

  static Preferencia fromJson(json) => Preferencia(
    id: json['id'],
    descricao: json['descricao'],
    prefere: json['prefere']
  );
}

class ConvPreferenciasPage extends StatefulWidget {
  const ConvPreferenciasPage({super.key});

  @override
  State<ConvPreferenciasPage> createState() => _ConvPreferenciasPageState();
}

class _ConvPreferenciasPageState extends State<ConvPreferenciasPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<Preferencia>> preferenciasFuture = getPreferencias();
  TextEditingController filtrarController = TextEditingController();
  bool filtrando = false;

  static Future<List<Preferencia>> getPreferencias() async {
    final response = await http.post(
      Uri.parse('https://datavest-api.glitch.me/buscarPreferencias'),
      body: json.encode({'email': 'teste@email.com'}),
      headers: {'content-type': 'application/json'}
    );

    final body = json.decode(response.body);

    return body.map<Preferencia>(Preferencia.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Media Queries that fetch current screen width and height
    double screenWidth   = MediaQuery.of(context).size.width;
    // double screenHeight  = MediaQuery.of(context).size.height

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                        'assets/Logo-Menu.svg',
                        semanticsLabel: 'DataVest Logo',
                        height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        globals.email = '';
                        globals.jwt = '';
                        globals.preferencias = [];
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      child: SvgPicture.asset(
                          'assets/Sair.svg',
                          semanticsLabel: 'DataVest Logo',
                          height: 45,
                      ),
                    )
                  ]),
              ),
                SizedBox(
                  width: screenWidth,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text("""
Não é possível personalizar suas preferências
        enquanto estiver como convidado.""", style: TextStyle(
                        color: Colors.black, 
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),),
                    ),
                    SizedBox(
                      width: screenWidth - 60,
                      child: ElevatedButton(
                        onPressed: (){
                          globals.email = '';
                          globals.jwt = '';
                          globals.preferencias = [];
                          Navigator.pushReplacementNamed(context, "/"); 
                        }, 
                        child: const Text("FAZER LOGIN", style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                        ),),
                      ),
                    )   
                  ],
                  ),
                ),
                Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                      child: Container(
                        width: screenWidth - 30,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                            Colors.orange.shade200,
                            Colors.orange.shade800
                          ]),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/datas');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/Icone-Datas.svg',
                                    semanticsLabel: 'Icone Datas',
                                    height: 18,
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  const Text(' '),
                                  const Text('Datas', style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    decorationThickness: 2
                                    ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/Icone-Preferencias.svg',
                                    semanticsLabel: 'Icone Preferencias',
                                    height: 18,
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  const Text(' '),
                                  const Text('Preferências', style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    ),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
            ]
          ),
        ),
      ),
    );
  }
}