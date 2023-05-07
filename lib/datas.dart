import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

part 'datas.g.dart';
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

class DatasPage extends StatefulWidget {
  const DatasPage({super.key});

  @override
  State<DatasPage> createState() => _DatasPageState();
}

class _DatasPageState extends State<DatasPage> {
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
            ]
          ),
        ),
      ),
    );
  }
}