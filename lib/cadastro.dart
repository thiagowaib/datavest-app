import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

part 'cadastro.g.dart';
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

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  FormData formData = FormData();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController senhaConfController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Controla o show/hide dos campos de senha
  bool hidePwd     = true;
  bool hidePwdConf = true;

  void toggleHidePwd(){
    setState(() {
      hidePwd = !hidePwd;
    });
  }

  void toggleHidePwdConf(){
    setState(() {
      hidePwdConf = !hidePwdConf;
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
                        'assets/Logo-Cadastro.svg',
                        semanticsLabel: 'DataVest Logo',
                        height: 100,
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      onChanged: (value) => formData.email = value,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        hintText: "Email"
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                          return 'Email inválido';
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
                          obscureText: hidePwd,
                          keyboardType: TextInputType.text,
                          controller: senhaController,
                          onChanged: (value) => formData.senha = value,
                          maxLength: 16,
                          decoration: const InputDecoration(
                            hintText: "Senha"
                          ),
                          validator: (String? value) {
                            if(value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            if(value.length <= 3) {
                              return 'A senha deve ter mais de 3 caracteres';
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
                    ],)
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: senhaConfController,
                            obscureText: hidePwdConf,
                            maxLength: 16,
                            decoration: const InputDecoration(
                              hintText: "Confirmar Senha"
                            ),
                            validator: (String? value) {
                              if(value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              if(value != formData.senha) {
                                return 'As senhas devem ser iguais!';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: TextButton(
                            onPressed: toggleHidePwdConf,
                            child: (hidePwdConf ? const Icon(Icons.visibility_off, color: Colors.grey) : const Icon(Icons.visibility, color: Colors.grey)),
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
                        child: const Text("CADASTRAR", style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                        onPressed: () async { 
                          if(formKey.currentState!.validate()){
                            // Use a JSON encoded string to send
                            var result = await httpClient.post(
                                Uri.parse('https://datavest-api.glitch.me/cadastrarUsuario'),
                                body: json.encode(formData.toJson()),
                                headers: {'content-type': 'application/json'});
            
                            debugPrint(result.body);
                            if(result.statusCode == 201) {
                              Fluttertoast.showToast(
                                msg: "Cadastro feito com sucesso!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Houve um problema",
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
                      const Text("Já tem Conta? ", style: TextStyle(
                          fontSize: 16,
                      ),),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Fazer Login.", style: TextStyle(
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