import 'package:YoutubeFavorites/BLOCs/VideoBLOC.dart';
import 'package:YoutubeFavorites/pages/home.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

void main() {
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideoBLOC(),
      child: MaterialApp(
        title: "Favorites",
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}