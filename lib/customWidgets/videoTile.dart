import 'package:YoutubeFavorites/models/videoModel.dart';
import 'package:flutter/material.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    video.title,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                  IconButton(
                    icon: Icon(Icons.star_border, color: Colors.yellow),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ));
  }
}
