import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

part 'datas.g.dart';
@JsonSerializable()
class Vestibular {
  String descricao;
  String data;

  Vestibular({
    required this.descricao,
    required this.data
  });

  static Vestibular fromJson(json) => Vestibular(
    descricao: json['descricao'],
    data: json['data'],
  );
}

class DatasPage extends StatefulWidget {
  const DatasPage({super.key});

  @override
  State<DatasPage> createState() => _DatasPageState();
}

class _DatasPageState extends State<DatasPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<Vestibular>> vestibularesFuture = getVestibulares();

  static Future<List<Vestibular>> getVestibulares() async {
    final response = await http.post(
      Uri.parse('https://datavest-api.glitch.me/listarDatas'),
      body: json.encode({'vestibulares': []}),
      headers: {'content-type': 'application/json'}
    );

    final body = json.decode(response.body);

    return body.map<Vestibular>(Vestibular.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {

    // Media Queries that fetch current screen width and height
    double screenWidth   = MediaQuery.of(context).size.width;
    // double screenHeight  = MediaQuery.of(context).size.height;

    Widget buildVestibulares(List<Vestibular> vestibulares) => ListView.builder(
      itemCount: vestibulares.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        final vestibular = vestibulares[index];
        final data = vestibular.data;
        final dataHoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        final dataVest = DateTime.parse('${data.split('/')[2]}-${data.split('/')[1]}-${data.split('/')[0]}');

        final diasRestantes = (dataVest.difference(dataHoje).inHours / 24).round();
        
        if(diasRestantes > 0) {
          return Card(
            child: ListTile(
              title: Text(vestibular.descricao),
              subtitle: Text('Faltam $diasRestantes dias'),
              trailing: Text(vestibular.data, style: const TextStyle(
                color: Colors.orange,
              ),),
            ),
          );
        }
      }),
    );

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
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      FutureBuilder<List<Vestibular>>(
                        future: vestibularesFuture,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if(snapshot.hasData) {
                            final vestibulares = snapshot.data!;
                
                            return buildVestibulares(vestibulares);
                          } else {
                            return const Center(child: Text("Não há vestibulares para acessar"));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                child: Container(
                  width: screenWidth - 30,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                      Colors.orange.shade800,
                      Colors.orange.shade200
                    ]),
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                  ),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                
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
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              decorationThickness: 2
                              ),)
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/preferencias');
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