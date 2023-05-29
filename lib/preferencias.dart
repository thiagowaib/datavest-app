import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
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

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<Preferencia>> preferenciasFuture = getPreferencias();
  TextEditingController filtrarController = TextEditingController();
  bool filtrando = false;

  static Future<List<Preferencia>> getPreferencias() async {
    final response = await http.post(
      Uri.parse('https://datavest-api.glitch.me/buscarPreferencias'),
      body: json.encode({'email': globals.email}),
      headers: {'content-type': 'application/json'}
    );

    final body = json.decode(response.body);

    return body.map<Preferencia>(Preferencia.fromJson).toList();
  }


  static alterarPreferencias(preferenciasUsuario) async {
    globals.preferencias = preferenciasUsuario;
    final response = await http.put(
    Uri.parse('https://datavest-api.glitch.me/alterarPreferencias'),
    body: json.encode({'email': globals.email, 'preferencias': globals.preferencias}),
    headers: {'content-type': 'application/json'}
    );

    final body = json.decode(response.body);

    if(response.statusCode==200) {
      Fluttertoast.showToast(
        msg: body['message'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
    Fluttertoast.showToast(
      msg: body['message'].toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Media Queries that fetch current screen width and height
    double screenWidth   = MediaQuery.of(context).size.width;
    // double screenHeight  = MediaQuery.of(context).size.height;

    List<String> preferenciasUsuario = ["."];

    Widget buildPreferencias(List<Preferencia> preferencias) => ListView.builder(
      itemCount: preferencias.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        final preferencia  = preferencias[index];
        var estadoSwitch = preferencia.prefere;

        if(preferencia.prefere) {
          preferenciasUsuario.add(preferencia.id);
        }

        if(!filtrando) {
          return Card(
            child: ListTile(
              title: Text(preferencia.descricao),
              trailing: Switch(
                value: estadoSwitch,
                activeTrackColor: Colors.green.shade400,
                activeColor: Colors.green.shade700,
                inactiveTrackColor: Colors.grey.shade400,
                inactiveThumbColor: Colors.grey.shade700,
                onChanged: (value) {
                  preferencia.prefere = !preferencia.prefere;
                  if(preferenciasUsuario.contains(preferencia.id)) {
                    preferenciasUsuario.remove(preferencia.id);
                  } else {
                    preferenciasUsuario.add(preferencia.id);
                  }
                  setState(() {
                    estadoSwitch = value;
                  });
                },
              ),
            ),
          );
        } else if(filtrando && preferencia.descricao.toLowerCase().contains(filtrarController.text.toLowerCase())) {
          return Card(
            child: ListTile(
              title: Text(preferencia.descricao),
              trailing: Switch(
                value: estadoSwitch,
                activeTrackColor: Colors.green.shade400,
                activeColor: Colors.green.shade700,
                inactiveTrackColor: Colors.grey.shade400,
                inactiveThumbColor: Colors.grey.shade700,
                onChanged: (value) {
                  preferencia.prefere = !preferencia.prefere;
                  if(preferenciasUsuario.contains(preferencia.id)) {
                    preferenciasUsuario.remove(preferencia.id);
                  } else {
                    preferenciasUsuario.add(preferencia.id);
                  }
                  setState(() {
                    estadoSwitch = value;
                  });
                },
              ),
            ),
          );
        } else {
          return const SizedBox(width: 0,height: 0);
        }       
      }),
    );


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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: filtrarController,
                        onChanged: (value) {
                          if(value.length >= 3) {
                            setState(() {
                              filtrando = true;
                            });
                          } else {
                            setState(() {
                              filtrando = false;
                            });
                          }
                        },
                        maxLength: 16,
                        decoration: const InputDecoration(
                          hintText: "Filtrar por Vestibular",
                          counterText: "",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                    width: 30,
                    child: TextButton(
                      onPressed: (){
                        if(filtrarController.text != "") {
                          filtrarController.clear();
                          setState(() {
                            filtrando = false;
                          });
                        }
                      },
                      child: (filtrarController.text == "" ? const Icon(Icons.search, color: Colors.grey) : const Icon(Icons.close, color: Colors.grey)),
                    ),
                  )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              FutureBuilder<List<Preferencia>>(
                                future: preferenciasFuture,
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasData) {
                                    final preferencias = snapshot.data!;
                                    return buildPreferencias(preferencias);
                                  } else {
                                    return const Center(child: Text("""


Não há vestibulares para exibir, 
 verifique sua conexão de rede 
  ou tente de novo mais tarde."""));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                          child: SizedBox(
                            width: screenWidth-60.0,
                            child: ElevatedButton(
                              child: const Text("SALVAR", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                              onPressed: () { 
                                alterarPreferencias(preferenciasUsuario);
                              },
                            ),
                          ),
                        ),
                      ],
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
                  ],
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}