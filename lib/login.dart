import 'dart:convert';

import 'package:datavest/cadastro.dart';
import 'package:datavest/datas.dart';
import 'package:datavest/conv_datas.dart';
import 'package:datavest/preferencias.dart';
import 'package:datavest/conv_preferencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'globals.dart' as globals;

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
        '/datas': (context) => const DatasPage(),
        '/conv_datas': (context) => const ConvDatasPage(),
        '/preferencias': (context) => const PreferenciasPage(),
        '/conv_preferencias': (context) => const ConvPreferenciasPage()
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

  // Controla o show/hide do campo de senha
  bool hidePwd = true;
  void toggleHidePwd(){
    setState(() {
      hidePwd = !hidePwd;
    });
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(globals.jwt != ''){
        Navigator.pushReplacementNamed(context, "/datas");
      }
    });
  }

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
                      maxLength: 50,
                      decoration: const InputDecoration(
                        hintText: "Email",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: hidePwd,
                            onChanged: (value) => formData.senha = value,
                            controller: senhaController,
                            maxLength: 16,
                            decoration: const InputDecoration(
                              hintText: "Senha",
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
                          onPressed: toggleHidePwd,
                          child: (hidePwd ? const Icon(Icons.visibility_off, color: Colors.grey) : const Icon(Icons.visibility, color: Colors.grey)),
                        ),
                      )
                      ],
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
                                Uri.parse('https://datavest-api.glitch.me/login'),
                                body: json.encode(formData.toJson()),
                                headers: {'content-type': 'application/json'});
                            
                            var response = json.decode(result.body);

                            if(result.statusCode==202) {
                              Fluttertoast.showToast(
                                msg: response['message'].toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              globals.email = formData.email.toString();
                              globals.jwt = response['tokenAcesso'];

                              result = await httpClient.post(
                                Uri.parse('https://datavest-api.glitch.me/buscarPreferencias'),
                                body: json.encode({'email': formData.email.toString()}),
                                headers: {'content-type': 'application/json'});
                            
                              response = json.decode(result.body);
                              var preferencias = (response.map<Preferencia>(Preferencia.fromJson).toList());
                              List<String> preferenciasUsuario = ["."];
                              for (var i = 0; i < preferencias.length; i++) {
                                var preferencia = preferencias[i];
                                if(preferencia.prefere){
                                  preferenciasUsuario.add(preferencia.id);
                                }
                              }
                              globals.preferencias = preferenciasUsuario;
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, "/datas");
                            } else {
                              Fluttertoast.showToast(
                                msg: response['message'].toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
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
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                    child: Text("―――――――――――  ou  ―――――――――――", style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.italic
                        ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                          emailController.clear();
                          senhaController.clear();
                          globals.email = '';
                          globals.jwt = '';
                          globals.preferencias = [];
                          Navigator.pushNamed(context, "/conv_datas", arguments: "1");
                      },
                      child: const Text("Entrar como Convidado", style: TextStyle(
                          color: Colors.orange, 
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline
                      ),),
                    ),
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
