import 'dart:async';

import 'package:YoutubeFavorites/api.dart';
import 'package:YoutubeFavorites/models/videoModel.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class VideoBLOC implements BlocBase {

  bool isHome = false;
  Api api;

  List<Video> videos;

  final _videoController = StreamController<List<Video>>.broadcast();
  Stream get outVideos => _videoController.stream;

  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  final initVideosController = StreamController();
  Sink get sinkInit => initVideosController.sink;

  final initialVideosController = StreamController<List<Video>>();
  Stream get outInitVideos => initialVideosController.stream;



  VideoBLOC() {
    api = Api();

    _searchController.stream.listen((_search) async {
      if (_search != null) {
        videos.clear();
        videos = await api.search(_search);
      }else{
        videos.addAll(await api.nextPage());
      }
      _videoController.sink.add(videos);
    });

    initVideosController.stream.listen((data) async {
      videos = await api.trendingVideos();
      initialVideosController.sink.add(videos);
    });
  }

  @override
  void dispose() {
    _videoController.close();
    _searchController.close();
    initVideosController.close();
    initialVideosController.close();
  }
}
