import 'package:flutter/material.dart';

import 'nav_bottom_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: Testes',
      style: optionStyle,
    ),
    Text(
      'Index 3: School',
      style: optionStyle,
    ),
  ];

  Example bottom = Example();

  Color current;

  @override
  void initState() {
    super.initState();
    bottom.type = BottomNavigationBarType.fixed;
    bottom.onTap = (int index) {
      setState(() {
        current = bottom.selectedItemColor;
        bottom.selectedItemColor = current == Colors.greenAccent[400]
            ? Colors.amber[800]
            : Colors.greenAccent[400];
      });
    };

    bottom.selectedItemColor = Colors.amber[800];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: GestureDetector(
            onTap: () {
//              bottom.hide = !bottom.hide;
              bottom.selectedItemColor =
                  bottom.selectedItemColor == Colors.red[900]
                      ? current
                      : Colors.red[900];
              setState(() {});
            },
            child: _widgetOptions.elementAt(bottom.currentIndex)),
      ),
      bottomNavigationBar: bottom.show(),
    );
  }
}

class Example extends NavBottomBar {
  get items => const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Business'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Testes'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('School'),
        ),
      ];
}
