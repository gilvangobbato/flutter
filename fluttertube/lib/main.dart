import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/blocs/favoritos_bloc.dart';
import 'package:fluttertube/blocs/vidoes_bloc.dart';

import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [Bloc((i) => VideosBloc()), Bloc((i) => FavoriteBloc())],
        child: MaterialApp(
          title: 'FlutterTube',
          home: Home(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
