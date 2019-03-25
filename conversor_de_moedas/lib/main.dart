import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=71d8957d";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body).toString());
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar;
  double euro;
  double clp;
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final clpController = TextEditingController();


  void _realChanged(String text){
    double real = double.parse(text);
    double totDollar = real / dollar;
    double totEuro = real / euro;
//    double clp = real / this.clp;
    dollarController.text = totDollar.toStringAsFixed(2);
    euroController.text = totEuro.toStringAsFixed(2);
//    clpController.text = clp.toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dollar = double.parse(text);
    double real = dollar * this.dollar;
    double euro = (dollar * this.dollar) / this.euro;
//    double clp = real / this.clp;
    realController.text = real.toStringAsFixed(2);
    euroController.text = euro.toStringAsFixed(2);
//    clpController.text = clp.toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    double real = euro * this.euro;
    double dollar = real / this.dollar;
//    double clp = real / this.clp;
    dollarController.text = dollar.toStringAsFixed(2);
    realController.text = real.toStringAsFixed(2);
//    clpController.text = clp.toStringAsFixed(2);
  }

  void _clpChanged(String text){
    double clp = double.parse(text);
    double real = clp * this.clp;
    double dollar = real / this.dollar;
    double euro = real / this.euro;
    dollarController.text = dollar.toStringAsFixed(2);
    realController.text = real.toStringAsFixed(2);
    euroController.text = euro.toStringAsFixed(2);
  }

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
                return buildLeiaute(snapshot);
              }
          }
        },
      ),
    );
  }

  Widget buildLeiaute(snapshot) {
    dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
//    clp = snapshot.data["results"]["currencies"]["CLP"]["buy"];
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 150.0,
            color: Colors.amber,
          ),
          buildTextField("Real", "R\$", realController, _realChanged),
          Divider(),
//          buildTextField("Peso Chileno", "\$", clpController, _clpChanged),
//          Divider(),
          buildTextField("Dólar", "\$", dollarController, _dolarChanged),
          Divider(),
          buildTextField("Euro", "€", euroController, _euroChanged),
        ],
      ),
    );
  }
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

Widget buildTextField(String nome, String prefixo, TextEditingController controller, Function funcao) {
  return TextField(
    decoration: InputDecoration(
      labelText: nome,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    controller: controller,
    onChanged: funcao,
    keyboardType: TextInputType.number,
  );
}


