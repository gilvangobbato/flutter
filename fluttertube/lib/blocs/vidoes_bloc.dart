import 'dart:async';

import 'package:fluttertube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;
  List<Video> videos;

  final _controller = new StreamController<List<Video>>();
  Stream get outVideos => _controller.stream;

  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = new Api();
    _searchController.stream.listen(_search);
  }

  Future _search(String search) async {
    if (search != null) {
      _controller.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }
    _controller.sink.add(videos);
  }

  @override
  void addListener(listener) {}

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}

  @override
  void dispose() {
    _controller.close();
    _searchController.close();
  }
}
