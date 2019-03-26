import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final textController = TextEditingController();
  List _toDoLinst = [];

  Map<String, dynamic> _removed;
  int _lastPost;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoLinst = json.decode(data);
      });
    });
  }

  void addToDo() {
    setState(() {
      String titulo = textController.text;
      textController.text = "";
      Map<String, dynamic> newMap = new Map();
      newMap["title"] = titulo;
      newMap["ok"] = false;
      _toDoLinst.add(newMap);
    });
    _saveData();
  }

  void checkList(index, c) {
    setState(() {
      _toDoLinst[index]["ok"] = c;
    });
    _saveData();
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoLinst.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de tarefas",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: addToDo,
                  color: Colors.red,
                  child: Text("ADD"),
                  textColor: Colors.black,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                      itemCount: _toDoLinst.length,
                      itemBuilder: buildItem),
                  onRefresh: _refresh))
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        onChanged: (c) {
          checkList(index, c);
        },
        title: Text(_toDoLinst[index]["title"]),
        value: _toDoLinst[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoLinst[index]["ok"] ? Icons.check : Icons.error),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _removed = Map.from(_toDoLinst[index]);
          _lastPost = index;
          _toDoLinst.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa ${_removed["title"]}\" removida"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoLinst.insert(_lastPost, _removed);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoLinst);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
