import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favoritos_bloc.dart';
import 'package:fluttertube/models/video.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data.values.map((v) {
              return InkWell(
                onTap: (){

                },
                onLongPress: (){
                  bloc.toggleFavorite(v);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 50,
                      child: Image.network(v.thumb),
                    ),
                    Expanded(
                      child: Text(
                        v.title,
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
