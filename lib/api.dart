import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/videoModel.dart';

const API_KEY = "AIzaSyAlXBspV0-8XvCG4HjyAWLRnIHRftIsTvc";

class Api {
  String _search;
  String _nextToken;

  search(String query) async {
    _search = query;
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$API_KEY&maxResults=10");

    return decode(response);
  }

  nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");

    return decode(response);
  }

  trendingVideos() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyDBizZ1l4coZvEmFCLcE6AxQyEzBfDPK1E&maxResults=10");

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded['nextPageToken'];

      List<Video> videos = decoded['items'].map<Video>((mapa) {
        return Video.fromJson(mapa);
      }).toList();

      return videos;
    } else {
      throw Exception("failed to load videos:  ${response.statusCode} - ${response.body}");
    }
  }
}

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"

//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"

//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
