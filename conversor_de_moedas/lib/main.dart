import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/quotations?format=json&key=71d8957d";

void main() async {
  runApp(MaterialApp(
    title: "Conversor de moedas",
    home: Home(),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(response.body);
  print(json.decode(response.body)["results"]["currencies"]["USD"]["buy"]);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar = 1.0;
  double euro = 1.0;
  double brl = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return mensagemErro("Carregando dados, aguarde...");
            default:
              if (snapshot.hasError) {
                return mensagemErro("Erro carregando dados.");
              } else {
                dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                brl = snapshot.data["results"]["currencies"]["BRL"]["buy"];
                return leiauteTela();
              }
          }
        },
      ),
    );
  }

  Widget leiauteTela() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,)
        ],
      ),
    );
  }

  Widget mensagemErro(String texto) {
    return Center(
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.amber,
          fontSize: 35.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}