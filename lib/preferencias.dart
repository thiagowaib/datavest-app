import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

part 'preferencias.g.dart';
@JsonSerializable()
class FormData {
  String? email;
  String? senha;

  FormData({
    this.email,
    this.senha,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FormData formData = FormData();

    // Media Queries that fetch current screen width and height
    double screenWidth   = MediaQuery.of(context).size.width;
    // double screenHeight  = MediaQuery.of(context).size.height;

    var httpClient = http.Client();


    return Scaffold(
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