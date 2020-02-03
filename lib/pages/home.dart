import 'package:YoutubeFavorites/BLOCs/VideoBLOC.dart';
import 'package:YoutubeFavorites/customWidgets/videoTile.dart';
import 'package:YoutubeFavorites/delegates/data_search.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideoBLOC>(context);
    bloc.sinkInit.add(null);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            height: 25,
            child: GestureDetector(
              child: Image.asset("images/logoo.png"),
              onTap: () {
                bloc.sinkInit.add(null);
              },
            ),
          ),
          actions: <Widget>[
            Center(
              child: Text("0", style: TextStyle(color: Colors.black)),
            ),
            IconButton(
                icon: Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () async {
                  String suggestion = await showSearch(
                      context: context, delegate: DataSearch());
                  if (suggestion != null) {
                    BlocProvider.of<VideoBLOC>(context)
                        .inSearch
                        .add(suggestion);
                        bloc.isHome = true;
                        
                  }
                })
          ],
        ),
        body: bloc.isHome
            ? StreamBuilder(
                stream: bloc.outVideos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index < snapshot.data.length) {
                          return VideoTile(snapshot.data[index]);
                        } else {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              )
            : StreamBuilder(
                stream: bloc.outInitVideos,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return VideoTile(snapshot.data[index]);
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,));
                  }
                },
              ));
  }
}
