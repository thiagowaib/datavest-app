import 'dart:convert';

import 'package:datavest/cadastro.dart';
import 'package:datavest/datas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

part 'login.g.dart';
void main() {
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataVest',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Comfortaa'
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/datas': (context) => const DatasPage()
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController senhaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FormData formData = FormData();
  // String jwt = '';



  @override
  Widget build(BuildContext context) {

    double screenWidth   = MediaQuery.of(context).size.width;
    var httpClient = http.Client();


    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: SizedBox(
                      child: SvgPicture.asset(
                        'assets/Logo-Login.svg',
                        semanticsLabel: 'DataVest Logo',
                        height: 100,
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => formData.email = value,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email"
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (value) => formData.senha = value,
                      controller: senhaController,
                      decoration: const InputDecoration(
                        hintText: "Senha"
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: SizedBox(
                      width: screenWidth-20.0,
                      child: ElevatedButton(
                        child: const Text("ENTRAR", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                        onPressed: () async { 
                          if(formKey.currentState!.validate()){
                            // Use a JSON encoded string to send
                            var result = await httpClient.post(
                                Uri.parse('https://datavest-servidor.glitch.me/login'),
                                body: json.encode(formData.toJson()),
                                headers: {'content-type': 'application/json'});
                            
                            var response = json.decode(result.body);

                            if(result.statusCode==202) {
                              // jwt = response['tokenAcesso'];
                              Fluttertoast.showToast(
                                msg: "Login feito com sucesso!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, "/datas");
                            } else {
                              Fluttertoast.showToast(
                                msg: "Login inválido",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Não tem Conta? ", style: TextStyle(
                          fontSize: 16,
                      ),),
                      GestureDetector(
                        onTap: () {
                          emailController.clear();
                          senhaController.clear();
                          Navigator.pushNamed(context, "/cadastro", arguments: "1");
                        },
                        child: const Text("Fazer Cadastro.", style: TextStyle(
                          color: Colors.orange, 
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline
                        ),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
