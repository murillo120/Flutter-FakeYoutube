import 'dart:async';

import 'package:YoutubeFavorites/models/videoModel.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class FavoritesBLOC implements BlocBase {


  final favoritesStream = StreamController<List<Video>>();
  Stream get getmyFavorites => favoritesStream.stream;
  Sink get setMyfavorites => favoritesStream.sink;


  @override
  void dispose() {
    favoritesStream.close();
  }
}
