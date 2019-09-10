import 'package:flutter/material.dart';
import 'package:fluttertube/models/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  const VideoTile({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(video.thumb, fit: BoxFit.cover),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(video.title),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(video.channel),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
