import 'dart:convert';
import 'package:YoutubeFavorites/BLOCs/VideoBLOC.dart';
import 'package:YoutubeFavorites/api.dart';
import 'package:YoutubeFavorites/customWidgets/videoTile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty)
      return Container();
    else {
      return StreamBuilder(
        stream: BlocProvider.of<VideoBLOC>(context).outVideos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            BlocProvider.of<VideoBLOC>(context).inSearch.add(query);
            return Center(
              child: CircularProgressIndicator(), 
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return VideoTile(snapshot.data[index]);
              },
            );
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return Container();
    else {
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.play_arrow),
                        Divider(),
                        Text(snapshot.data[index],
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  )),
                  onTap: () {
                    close(context, snapshot.data[index]);
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  @override
  String get searchFieldLabel => "Pesquise o video";
}

Future<List> suggestions(String search) async {
  http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json");

  if (response.statusCode == 200) {
    return json.decode(response.body)[1].map((data) {
      return data[0];
    }).toList();
  } else {
    throw Exception("failed");
  }
}

Future<List> results(String search) async {
  http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");

  if (response.statusCode == 200) {
    return json.decode(response.body)['items'].map((data) {
      print(data['id']['videoId']);
      return data;
    }).toList();
  } else {
    throw Exception("failed");
  }
}
